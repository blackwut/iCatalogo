//
//  PDF.m
//  iCatalogo
//
//  Created by Albertomac on 08/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "PDF.h"
#import "AppDelegate.h"

@implementation PDF

@synthesize line;

static const int padding = 20;
static const int spaceFild = 5;
static const int heightFild = 14;

static const CGSize descriptionSize = {482, heightFild};
static const CGSize quantitySize = {30, heightFild};
static const CGSize priceSize = {60, heightFild};

//Ricava la descrizione dell'order
- (NSString *)descriptionOfOrder:(NSManagedObject *)order
{
    //return [[[order valueForKey:@"subproduct"] valueForKey:@"product"] valueForKey:@"product"];
    
    //Sistemo la descrizione del prodotto
    NSMutableString *product = [[[[order valueForKey: @"subproduct"] valueForKey:@"product"] valueForKey:@"product"] mutableCopy];
    
    NSString *subproduct = [[order valueForKey:@"subproduct"] valueForKey:@"subproduct"];
    NSString *note = [order valueForKey:@"note"];
    NSString *xSubproduct = [order valueForKey: @"xSubproduct"];
    NSString *xColor = [order valueForKey: @"xColor"];
    NSString *xType = [order valueForKey: @"xType"];
    NSString *xPackage = [order valueForKey: @"xPackage"];
    NSString *xCartoon = [order valueForKey: @"xCartoon"];
    

    [product appendString:subproduct];
    
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

//Ritorna un CGRect con le dimensioni adatte a centrare la stringa verticalmente all'interno del rect passato
- (CGRect)rectStringVerticalCenter:(NSString *)string initialRect:(CGRect)rect withSizeFont:(CGFloat)sizeFont
{
    return CGRectInset(rect, 0, (rect.size.height - sizeFont)/2 -1);
}

//Ritorna un CGRect con le dimensioni adatte a giustificare la stringa a destra all'interno del rect passato
- (CGRect)rectStringHorizontalLeft:(NSString *)string initialRect:(CGRect)rect withSizeFont:(CGFloat)sizeFont
{
    CGRect rectString = [self rectStringVerticalCenter:string initialRect:rect withSizeFont:sizeFont];
    return CGRectInset(rectString, spaceFild, 0);
}

//Ritorna un CGRect con le dimensioni adatte a centrare la stringa orizontalmente all'interno del rect passato
- (CGRect)rectStringHorizontalCenter:(NSString *)string initialRect:(CGRect)rect withSizeFont:(CGFloat)sizeFont
{
    CGSize sizeString = [self sizeOfString:string withSizeFont:sizeFont];
    CGRect rectString = [self rectStringVerticalCenter:string initialRect:rect withSizeFont:sizeFont];
    return CGRectInset(rectString, (rectString.size.width - sizeString.width)/2, 0);
}

//Ritorna un CGRect con le dimensioni adatte a giustificare la stringa a destra all'interno del rect passato
- (CGRect)rectStringHorizontalRight:(NSString *)string initialRect:(CGRect)rect withSizeFont:(CGFloat)sizeFont
{
    CGSize sizeString = [self sizeOfString:string withSizeFont:sizeFont];
    CGRect rectString = [self rectStringVerticalCenter:string initialRect:rect withSizeFont:sizeFont];
    float x = (rectString.origin.x + rectString.size.width) - (sizeString.width + spaceFild);
    return CGRectMake(x, rectString.origin.y, sizeString.width, rectString.size.height);
}

//Aggiunge la stringa al pdf
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

- (void)drawLineOrderWithDescription:(NSString *)description quantity:(NSString *)quantity price:(NSString *)price withSizeFont:(CGFloat)sizeFont
{
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    
    
    int x = padding;
    line += heightFild;
    
    CGRect originalDescriptionRect = CGRectMake(x, line, descriptionSize.width, descriptionSize.height);
    CGRect descriptionRect = [self rectStringHorizontalLeft:description initialRect:originalDescriptionRect withSizeFont:sizeFont];
    
    x += descriptionSize.width;
    CGRect originalQuantityRect = CGRectMake(x, line, quantitySize.width, quantitySize.height);
    CGRect quantityRect = [self rectStringHorizontalRight:quantity initialRect:originalQuantityRect withSizeFont:sizeFont];
    
    x += quantitySize.width;
    CGRect originalPriceRect = CGRectMake(x, line, priceSize.width, priceSize.height);
    CGRect priceRect = [self rectStringHorizontalRight:price initialRect:originalPriceRect withSizeFont:sizeFont];
    
    NSDictionary *attibutes = @{NSFontAttributeName:font};
    NSStringDrawingContext *stringContext = [NSStringDrawingContext new];
    [description drawWithRect:descriptionRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:stringContext];
    [quantity drawWithRect:quantityRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:stringContext];
    [price drawWithRect:priceRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:stringContext];

    
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(graphicsContext, 1.0);
    CGContextSetStrokeColorWithColor(graphicsContext, [UIColor blackColor].CGColor);

    CGContextAddRect(graphicsContext, originalDescriptionRect);
    CGContextAddRect(graphicsContext, originalQuantityRect);
    CGContextAddRect(graphicsContext, originalPriceRect);
    
    CGContextStrokePath(graphicsContext);
}

- (void)drawHeader
{
    NSString *header = @"Mediterranea Casalinghi di Ottimo Vincenzo\nVia Pirato Grande Quartarella s/n - 97915 - Modica (RG)\nTel.: 0932/453382 Cell.: 333/9717617";
    [self drawString:header withSizeFont:15];
}

- (void)drawClientName:(NSManagedObject *)client
{
    NSString *clientName = [NSString stringWithFormat:@"Cliente: %@", [client valueForKey:@"client"]];
    [self drawString:clientName withSizeFont:15];
}

- (void)drawOrderOfClient:(NSManagedObject *)client
{
    NSArray *orders = [[client valueForKey:@"orders"] allObjects];
    
    [self drawLineOrderWithDescription:@"Descrizione" quantity:@"Qt." price:@"Prezzo" withSizeFont:10];
    for(NSManagedObject *order in orders){
        [self drawLineOrderWithDescription:[self descriptionOfOrder:order] quantity:[self quantityOfOrder:order] price:[self priceOfOrder:order] withSizeFont:10];
    }
}

- (void)drawPage:(int)page withSizeFont:(CGFloat)sizeFont
{
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    NSString *string = [NSString stringWithFormat:@"Pagina %d", page];
    
    
    CGSize sizeString = [self sizeOfString:string withSizeFont:sizeFont];
    CGRect rectString = CGRectMake(612 -10 -sizeString.width, 792 -5 -sizeString.height, sizeString.width, sizeString.height);
    
    NSDictionary *attibutes = @{NSFontAttributeName:font};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    [string drawWithRect:rectString options:NSStringDrawingUsesLineFragmentOrigin attributes:attibutes context:context];
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
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subproduct.product.product" ascending:YES];
    [orders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //44 righe per ogni foglio
    
    BOOL done = false;
    int page = 1;
    int index = 0;
    
    while(!done){
        
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        
        [self drawHeader];
        [self drawClientName:client];
        
        [self drawLineOrderWithDescription:@"Descrizione" quantity:@"Qt." price:@"Prezzo" withSizeFont:10];
        
        for (int i = 0; i<45; i++){
            
            NSManagedObject *order = [orders objectAtIndex:index++];
            [self drawLineOrderWithDescription:[self descriptionOfOrder:order] quantity:[self quantityOfOrder:order] price:[self priceOfOrder:order] withSizeFont:10];
            
            if(index == [orders count])
                break;
        }
        
        [self drawPage:page withSizeFont:10];
        
        if(index == [orders count]){
            
            NSString *total = [NSString stringWithFormat:@"Totale previsto %@", [[AppDelegate sharedAppDelegate] getTotalOrderOf:client]];
            [self drawString:total withSizeFont:12];
            
            line = 792-35;
            
            [self drawString:@"Il totale della fattura potrebbe variare sensibilmente in base agli articoli in magazzino." withSizeFont:8];
            
            done = true;
        }
        
        line = 0;
        page++;
    }
    

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    return pdfFileName;
}


@end
