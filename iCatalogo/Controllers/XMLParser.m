//
//  XMLParser.m
//  iCatalogo
//
//  Created by Albertomac on 23/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize context, progressView;

- (id)initWithProgressView:(AProgressView *)progress
{
    self = [super init];
    if(self){
        context = [[AppDelegate sharedAppDelegate] managedObjectContext];
        progressView = progress;
        [progressView reset];
    }
    return self;
}

/*
 Estrapola l'attributo da 'childElement' dal padre 'parent' e normalizza la stringa.
*/
- (NSString *)getAttribute:(NSString *)childElement fromParent:(TBXMLElement *)parent capitalized:(BOOL)capitalized
{
    NSString *attribute = [TBXML textForElement:[TBXML childElementNamed:childElement parentElement:parent]];
    
    if(capitalized)
        return [[self xmlToText:attribute] capitalizedString];
    return [self xmlToText:attribute];
}

- (NSString *)getAttribute:(NSString *)childElement fromParent:(TBXMLElement *)parent numberOfDecimal:(int)decimal
{
    NSString *attribute = [self getAttribute:childElement fromParent:parent capitalized:YES];
    
    if(decimal == 0)
        return [NSString stringWithFormat:@"%d", [attribute intValue]];
    
    float value = [attribute floatValue];
    float pow = powf(10.0f, (float)decimal);
    value = roundf(value * pow) / pow * 2;
	
	NSString * baseString;
	
    switch (decimal) {
        case 1:
            baseString = [NSString stringWithFormat:@"%.1f", value];
			break;
        case 2:
            baseString = [NSString stringWithFormat:@"%.2f", value];
			break;
        case 3:
            baseString = [NSString stringWithFormat:@"%.3f", value];
			break;
        case 4:
            baseString = [NSString stringWithFormat:@"%.4f", value];
			break;
        default:
            baseString = [NSString stringWithFormat:@"%.5f", value];
			break;
    }
	
	return [baseString stringByReplacingOccurrencesOfString:@"." withString:@","];
}

/*
 Trasforma alcuni simboli e lettere dall'xml in caratteri normali.
 */
- (NSString *)xmlToText:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&Deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    
    return string;
}


- (void)importClients:(TBXMLElement *)root
{
	TBXMLElement *Clients = [TBXML childElementNamed:@"Clients" parentElement:root];
	TBXMLElement *Client = [TBXML childElementNamed:@"Client" parentElement:Clients];
	
	while (Client != nil){
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Clients" inManagedObjectContext:context];
        [object setValue:[self getAttribute:@"id" fromParent:Client capitalized:YES] forKey:@"id"];
        [object setValue:[self getAttribute:@"client" fromParent:Client capitalized:YES] forKey:@"client"];
        [object setValue:[self getAttribute:@"country" fromParent:Client capitalized:YES] forKey:@"country"];
        [object setValue:[self getAttribute:@"address" fromParent:Client capitalized:YES] forKey:@"address"];
        [object setValue:[self getAttribute:@"telephone" fromParent:Client capitalized:YES] forKey:@"telephone"];
        [object setValue:[[self getAttribute:@"email" fromParent:Client capitalized:NO] lowercaseString] forKey:@"email"];
                
        [progressView performSelectorInBackground:@selector(increment) withObject:nil];
        
        Client = [TBXML nextSiblingNamed:@"Client" searchFromElement:Client];
	}
}

- (void)importProducts:(TBXMLElement *)root
{
    NSString *documents = [[[AppDelegate sharedAppDelegate] applicationDocumentsDirectory] path];
    
	TBXMLElement *Products = [TBXML childElementNamed:@"Products" parentElement:root];
	TBXMLElement *Product = [TBXML childElementNamed:@"Product" parentElement:Products];
	
	while (Product != nil){
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Products" inManagedObjectContext:context];
        [object setValue:[self getAttribute:@"id" fromParent:Product capitalized:YES] forKey:@"id"];
        [object setValue:[self getAttribute:@"product" fromParent:Product capitalized:YES] forKey:@"product"];
        
        NSString *photo = [documents stringByAppendingPathComponent:[[[self getAttribute:@"photo" fromParent:Product capitalized:NO] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@":" withString:@""]];
        
        BOOL isDirectory;
		if (![[NSFileManager defaultManager] fileExistsAtPath:photo isDirectory:&isDirectory] || isDirectory)
            photo = [documents stringByAppendingPathComponent:@"NotFound.png"];
        
        [object setValue:photo forKey:@"photo"];
        [object setValue:[self getAttribute:@"category" fromParent:Product capitalized:YES] forKey:@"category"];
        [object setValue:[self getAttribute:@"supplier" fromParent:Product capitalized:YES] forKey:@"supplier"];
        
        NSArray *subproducts = [self importSubproducts:Product];
        [[object valueForKey:@"subproducts"] addObjectsFromArray:subproducts];
        [subproducts setValue:object forKey:@"product"];
        
        [progressView performSelectorInBackground:@selector(increment) withObject:nil];
        
        Product = [TBXML nextSiblingNamed:@"Product" searchFromElement:Product];
    }
}

- (NSArray *)importSubproducts:(TBXMLElement *)root
{
    NSMutableArray *subproducts = [[NSMutableArray alloc] init];
    
    TBXMLElement *Subproducts = [TBXML childElementNamed:@"Subproducts" parentElement:root];
	TBXMLElement *Subproduct = [TBXML childElementNamed:@"Subproduct" parentElement:Subproducts];
	
	while (Subproduct != nil){
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Subproducts" inManagedObjectContext:context];
        [object setValue:[self getAttribute:@"id" fromParent:Subproduct capitalized:YES] forKey:@"id"];
        [object setValue:[self getAttribute:@"subproduct" fromParent:Subproduct capitalized:YES] forKey:@"subproduct"];
        [object setValue:[self getAttribute:@"barcode" fromParent:Subproduct capitalized:YES] forKey:@"barcode"];
        [object setValue:[self getAttribute:@"quantity" fromParent:Subproduct numberOfDecimal:0] forKey:@"quantity"];
        [object setValue:[self getAttribute:@"price" fromParent:Subproduct numberOfDecimal:3] forKey:@"price"];
        [object setValue:[self getAttribute:@"quantityPackage" fromParent:Subproduct numberOfDecimal:0] forKey:@"quantityPackage"];
        [object setValue:[self getAttribute:@"quantityCartoon" fromParent:Subproduct numberOfDecimal:0] forKey:@"quantityCartoon"];
        //[object setValue:[self getAttribute:@"quantityPackage" fromParent:Subproduct numberOfDecimal:0] forKey:@"quantityColor"];
        [object setValue:[self getAttribute:@"profit" fromParent:Subproduct capitalized:YES] forKey:@"profit"];
        [object setValue:[self getAttribute:@"note" fromParent:Subproduct capitalized:YES] forKey:@"note"];
        
        [subproducts addObject:object];
		
        [progressView performSelectorInBackground:@selector(increment) withObject:nil];
        
        Subproduct = [TBXML nextSiblingNamed:@"Subproduct" searchFromElement:Subproduct];
	}
    
    return subproducts;
}

- (NSString *)parseFile:(NSString *)fileName
{
    NSError *error;
    TBXML *xml = [TBXML tbxmlWithXMLFile:fileName error:&error];
    
    if(error)
        return @"Errore nel file XML.";
    
    TBXMLElement *root = [xml rootXMLElement];
    
    int rows = [[self getAttribute:@"rows" fromParent:root numberOfDecimal:0] intValue];
    
    [progressView setMax:rows];
    
    [self importClients:root];
    [self importProducts:root];
    
    if([context save:&error])
        return @"Aggiornamento database completato.";
    else return @"Problema aggiornamento database!";
}

@end
