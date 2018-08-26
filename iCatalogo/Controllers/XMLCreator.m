//
//  XMLCreator.m
//  iCatalogo
//
//  Created by Albertomac on 23/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "XMLCreator.h"

@implementation XMLCreator

@synthesize content;

#pragma mark ObjectMethods

- (id)init
{
    self = [super init];
    if(self){
        self.content = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n"];
    }
    return self;
}

- (NSString *)text
{
    return content;
}

- (NSData *)data
{
    return [content dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)saveWithFileName:(NSString *)fileName
{
    //Creazione Data di Oggi
	NSDate *today = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH-mm"];
    
    //Creazione dei paths necessari
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Xml da esportare nella cartella documents
    NSString *xmlPath = [documentsPath stringByAppendingPathComponent:fileName];
    
    //Xml da esportare come backup
    NSString *backupDirPath = [documentsPath stringByAppendingPathComponent:@"Backup"];
    NSString *backupXmlPath = [backupDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml", [formatter stringFromDate:today]]];
    
    //Crea la directory se non esiste e poi il file di backup
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:backupDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fm createFileAtPath:backupXmlPath contents:[self data] attributes:nil];
	[fm createFileAtPath:xmlPath contents:[self data] attributes:nil];
    
    return YES;
}

#pragma mark ModellingMethods

/*
 Trasforma alcuni simboli e lettere in formato xml.
 */
- (NSString *)textToXml:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"°" withString:@"&deg;"];
    string = [string stringByReplacingOccurrencesOfString:@"à" withString:@"&agrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"è" withString:@"&egrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"ì" withString:@"&igrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"ò" withString:@"&ograve;"];
    string = [string stringByReplacingOccurrencesOfString:@"ù" withString:@"&ugrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"À" withString:@"&Agrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"È" withString:@"&Egrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"Ì" withString:@"&Igrave;"];
    string = [string stringByReplacingOccurrencesOfString:@"Ò" withString:@"&Ograve;"];
    string = [string stringByReplacingOccurrencesOfString:@"Ù" withString:@"&Ugrave;"];
    
    return string;
}

- (void)addTag:(NSString *)tag withValue:(NSString *)value
{
	if ([value length] > 0)
		[content appendFormat:@"\t<%@>%@</%@>\n", tag, [self textToXml:value], tag];
	else [content appendFormat:@"\t<%@></%@>\n", tag, tag];
}

- (void)addSingleTag:(NSString *)tag
{
	[content appendFormat:@"<%@>\n", tag];
}

- (void)endSingleTag:(NSString *)tag
{
	[content appendFormat:@"</%@>\n", tag];
}

#pragma mark DatabaseMethods

- (void)createXMLOrders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY orders != nil"];
    NSArray *clients = [[AppDelegate sharedAppDelegate] searchEntity:@"Clients" withPredicate:predicate sortedBy:@"client"];
    NSArray *rowsOrders = [[AppDelegate sharedAppDelegate] searchEntity:@"Orders" withPredicate:nil sortedBy:nil];
    
    [self addSingleTag:@"Data"];
    
    [self addClients:clients];
    [self addRowsOrders:rowsOrders];
    
    [self endSingleTag:@"Data"];
	
}

- (void)addClients:(NSArray *)clients
{
    
    [self addSingleTag:@"Clients"];
    
    for (NSManagedObject *object in clients){
        
        //Prepara i dati da inserire nell'xml
		NSString *idClient = [object valueForKey: @"id"];
		NSString *client = [object valueForKey: @"client"];
		
        //Inserisce il record nell'xml
		[self addSingleTag:@"client"];
            [self addTag:@"idClient" withValue:idClient];
            [self addTag:@"client" withValue:client];
		[self endSingleTag:@"client"];
	}
    
	[self endSingleTag:@"Clients"];
}

- (void)addRowsOrders:(NSArray *)orders
{
    [self addSingleTag:@"RowsOrders"];
    
	for (NSManagedObject *object in orders){
        
        //Prepara i dati da inserire nell'xml
		NSString *idClient = [[object valueForKey: @"client"] valueForKey:@"id"];
		NSString *idProduct = [[[object valueForKey:@"subproduct"] valueForKey: @"product"] valueForKey:@"id"];
        NSString *idSubproduct = [[object valueForKey:@"subproduct"] valueForKey:@"id"];
        NSString *barcode = [[object valueForKey:@"subproduct"] valueForKey:@"barcode"];
        NSString *subproduct = [[object valueForKey:@"subproduct"] valueForKey:@"subproduct"];
        NSString *noteString = [[object valueForKey:@"subproduct"] valueForKey:@"note"];
        NSMutableString *supplier = [[[[object valueForKey:@"subproduct"] valueForKey:@"product"] valueForKey:@"supplier"] mutableCopy];
        
        NSString *quantity = [object valueForKey:@"quantity"];
        
        if([quantity length]==0)
            quantity = @"0";
        
        //Sistemo la descrizione del prodotto
        NSMutableString *product = [[[[object valueForKey: @"subproduct"] valueForKey:@"product"] valueForKey:@"product"] mutableCopy];
        
        NSString *note = [object valueForKey:@"note"];
        NSString *xSubproduct = [object valueForKey: @"xSubproduct"];
        NSString *xColor = [object valueForKey: @"xColor"];
        NSString *xType = [object valueForKey: @"xType"];
        NSString *xPackage = [object valueForKey: @"xPackage"];
        NSString *xCartoon = [object valueForKey: @"xCartoon"];
		
        if ([note length] > 0)
			[supplier appendFormat:@" - %@", note];
		
        //Se esistono valori per xSubproduct, xColor o xType allora non inserisce la misura.
        if ([xSubproduct length] > 0){
			[supplier appendFormat:@"- %@ xMisura", xSubproduct];
            subproduct = @" ";
        }
		if ([xColor length] > 0){
			[supplier appendFormat:@"- %@ xColore", xColor];
            subproduct = @" ";
        }
		if ([xType length] > 0){
			[supplier appendFormat:@"- %@ xTipo", xType];
            subproduct = @" ";
        }
		
        if ([xPackage length] > 0)
			[supplier appendFormat:@"- %@ xConfezione", xPackage];
        if ([xCartoon length] > 0)
			[supplier appendFormat:@"- %@ xCartone", xCartoon];
		
        
        //Inserisce il record nell'xml
		[self addSingleTag:@"row"];
            [self addTag:@"idClient" withValue:idClient];
            [self addTag:@"idProduct" withValue:idProduct];
            [self addTag:@"barcode" withValue:barcode];
            [self addTag:@"product" withValue:product];
            [self addTag:@"idSubproduct" withValue:idSubproduct];
            [self addTag:@"subproduct" withValue:subproduct];
            [self addTag:@"note" withValue:noteString];
            [self addTag:@"supplier" withValue:supplier];
            [self addTag:@"quantity" withValue:quantity];
		[self endSingleTag:@"row"];
	}
	
	[self endSingleTag:@"RowsOrders"];
}

@end
