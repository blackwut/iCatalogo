//
//  PDFCreator.m
//  iCatalogo
//
//  Created by Albertomac on 08/01/14.
//  Copyright (c) 2014 Albertomac. All rights reserved.
//

#import "PDFCreator.h"

@implementation PDFCreator

@synthesize headerLabel, clientLabel, footerLabel, pageLabel;
@synthesize barcodeLabel, descriptionLabel, subproductLabel, quantityLabel, priceLabel;
@synthesize line;

#define maxRows 47
#define padding 10

//Ricava il codice a barre dall'ordine
- (NSString *)barcodeOfOrder:(NSManagedObject *)order
{
    return [[order valueForKey:@"subproduct"] valueForKey:@"barcode"];
}

//Ricava la descrizione dell'order
- (NSString *)descriptionOfOrder:(NSManagedObject *)order
{
    NSMutableString *product = [[[[order valueForKey: @"subproduct"] valueForKey:@"product"] valueForKey:@"product"] mutableCopy];
    
    NSString *note = [order valueForKey:@"note"];
    NSString *xSubproduct = [order valueForKey: @"xSubproduct"];
    NSString *xColor = [order valueForKey: @"xColor"];
    NSString *xType = [order valueForKey: @"xType"];
    NSString *xPackage = [order valueForKey: @"xPackage"];
    NSString *xCartoon = [order valueForKey: @"xCartoon"];
    
    if ([note length] > 0)
        [product appendFormat:@" - %@", note];
    if ([xSubproduct length] > 0)
        [product appendFormat:@" - %@ x Misura", xSubproduct];
    if ([xColor length] > 0)
        [product appendFormat:@" - %@ x Colore", xColor];
    if ([xType length] > 0)
        [product appendFormat:@" - %@ x Tipo", xType];
    if ([xPackage length] > 0)
        [product appendFormat:@" - %@ x Confezione", xPackage];
    if ([xCartoon length] > 0)
        [product appendFormat:@" - %@ x Cartone", xCartoon];
    
    return product;
}

//Ricava la misura dell'order
- (NSString *)subproductOfOrder:(NSManagedObject *)order
{
    return [[order valueForKey:@"subproduct"] valueForKey:@"subproduct"];
}

//Ricava la quantità dell'order
- (NSString *)quantityOfOrder:(NSManagedObject *)order
{
    return [order valueForKey:@"quantity"];
}

//Ricava il prezzo dall'order
- (NSString *)priceOfOrder:(NSManagedObject *)order
{
    NSString *price =[[order valueForKey:@"subproduct"] valueForKey:@"price"];
    return [NSString stringWithFormat:@"€ %@", price];
}

//Ricava la dimensione della stringa dipendente dalla grandezza del font
- (CGSize)sizeOfString:(NSString *)string withSizeFont:(CGFloat)sizeFont
{
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    return [string sizeWithAttributes:@{NSFontAttributeName:font}];
}

//Stampa la stringa nella label associata nel xib "PDFCreator", aggiunge il bordo, aggiunge un offset verticale e aggiunge un bordo interno trasparente
- (void)drawString:(NSString *)string inLabel:(UILabel *)label withBorder:(BOOL)border addingVerticalOffset:(NSInteger)offset withInset:(NSInteger)inset
{
 
    CGRect rect = CGRectOffset(label.frame, 0, offset);
    CGFloat sizeFont = label.font.pointSize;
    CGSize sizeString = [self sizeOfString:string withSizeFont:sizeFont];
    
    if(border){
        CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(graphicsContext, 1.0);
        CGContextSetStrokeColorWithColor(graphicsContext, [UIColor blackColor].CGColor);
        CGContextAddRect(graphicsContext, rect);
        CGContextStrokePath(graphicsContext);
    }

    rect = CGRectInset(rect, inset, inset);
    
    switch (label.textAlignment) {
        case NSTextAlignmentLeft:
            rect = CGRectInset(rect, 2, -1);
            break;
            
        case NSTextAlignmentCenter:
            rect = CGRectInset(rect, (rect.size.width - sizeString.width)/2, -1);
            break;
            
        case NSTextAlignmentRight:
            rect = CGRectMake((rect.origin.x + rect.size.width) - sizeString.width -2, rect.origin.y, sizeString.width, rect.size.height);
            break;
        default:
            break;
    }
    [self drawString:string inRect:rect withSizeFont:sizeFont];
}

- (void)drawString:(NSString *)string inRect:(CGRect)rect withSizeFont:(CGFloat)sizeFont
{
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    NSDictionary *attibutes = @{NSFontAttributeName:font};
    NSStringDrawingContext *stringContext = [NSStringDrawingContext new];
    [string drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:stringContext];
}

- (void)drawString:(NSString *)string withSizeFont:(CGFloat)sizeFont
{
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    
    CGSize sizeString = [self sizeOfString:string withSizeFont:sizeFont];
    CGRect rectString = CGRectMake(padding, line+padding, sizeString.width, sizeString.height);
    
    line += sizeString.height+padding;
    
    NSDictionary *attibutes = @{NSFontAttributeName:font};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    [string drawWithRect:rectString options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:context];
}

- (void)drawLineOrderWithBarcode:(NSString *)barcode description:(NSString *)description subproduct:(NSString *)subproduct quantity:(NSString *)quantity price:(NSString *)price
{
    [self drawString:barcode inLabel:barcodeLabel withBorder:YES addingVerticalOffset:line withInset:2];
    [self drawString:description inLabel:descriptionLabel withBorder:YES addingVerticalOffset:line withInset:2];
    [self drawString:subproduct inLabel:subproductLabel withBorder:YES addingVerticalOffset:line withInset:2];
    [self drawString:quantity inLabel:quantityLabel withBorder:YES addingVerticalOffset:line withInset:2];
    [self drawString:price inLabel:priceLabel withBorder:YES addingVerticalOffset:line withInset:2];
    
    line += barcodeLabel.frame.size.height;
}

- (void)drawHeader
{
    NSString *header = @"Mediterranea Casalinghi di Ottimo Vincenzo\nS.S. 115 Modica - Ispica Km 343 - 97915 - Modica (RG)\nTel.: 0932/453382 Cell.: 333/9717617";
    [self drawString:header inLabel:headerLabel withBorder:NO addingVerticalOffset:0 withInset:0];
}

- (void)drawClientName:(NSManagedObject *)client
{
    NSString *clientName = [NSString stringWithFormat:@"Cliente: %@", [client valueForKey:@"client"]];
    [self drawString:clientName inLabel:clientLabel withBorder:NO addingVerticalOffset:0 withInset:0];
}

- (void)drawTotal:(NSString *)total
{
    line = barcodeLabel.frame.origin.y + line + 8;
    total = [NSString stringWithFormat:@"Totale previsto %@", total];
    CGSize sizeTotal = [self sizeOfString:total withSizeFont:12];
    
    CGRect rectTotal =  CGRectMake(10, line, sizeTotal.width, sizeTotal.height);
    [self drawString:total inRect:rectTotal withSizeFont:12];
}

- (void)drawFooter
{
    NSString *footer = @"Il totale della fattura potrebbe variare sensibilmente in base agli articoli in magazzino.";
    [self drawString:footer inLabel:footerLabel withBorder:NO addingVerticalOffset:0 withInset:0];
}

- (void)drawPage:(int)page
{
    NSString *pageString = [NSString stringWithFormat:@"Pagina %d", page];
    [self drawString:pageString inLabel:pageLabel withBorder:NO addingVerticalOffset:0 withInset:0];
}

- (NSString *)createPdfOfClient:(NSManagedObject *)client
{
    NSString *fileName = @"Ordine.pdf";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    NSArray *orders = [[client valueForKey:@"orders"] allObjects];
    NSSortDescriptor *sortProduct = [NSSortDescriptor sortDescriptorWithKey:@"subproduct.product.product" ascending:YES];
    NSSortDescriptor *sortSubproduct = [NSSortDescriptor sortDescriptorWithKey:@"subproduct.subproduct" ascending:YES];
    orders = [orders sortedArrayUsingDescriptors:@[sortProduct, sortSubproduct]];
    
    
    BOOL done = false;
    int page = 1;
    int index = 0;
    int countOrders = (int)[orders count];
    
    do {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), nil);
        
        line = 0;
        [self drawHeader];
        [self drawClientName:client];
        [self drawLineOrderWithBarcode:@"Barcode" description:@"Descrizione" subproduct:@"Misura" quantity:@"Qt." price:@"Prezzo"];
        
        for (int i = 0; i < maxRows && index != countOrders; i++){
            
            NSManagedObject *order = [orders objectAtIndex:index++];
            
            [self drawLineOrderWithBarcode:[self barcodeOfOrder:order] description:[self descriptionOfOrder:order] subproduct:[self subproductOfOrder:order] quantity:[self quantityOfOrder:order] price:[self priceOfOrder:order]];
            
            //if(index == countOrders)
              //  break;
        }
        
        if(countOrders > maxRows)
            [self drawPage:page];
        
        /*if(index == countOrders){
            
            [self drawTotal:[[AppDelegate sharedAppDelegate] getTotalOrderOf:client]];
            [self drawFooter];
            
            done = true;
        }*/
        
        done = (index == countOrders);
        
        page++;
        
    } while (!done);
    
    [self drawTotal:[[AppDelegate sharedAppDelegate] getTotalOrderOf:client]];
    [self drawFooter];
    
    UIGraphicsEndPDFContext();
    
    return pdfFileName;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
