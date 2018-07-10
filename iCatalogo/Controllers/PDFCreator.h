//
//  PDFCreator.h
//  iCatalogo
//
//  Created by Albertomac on 08/01/14.
//  Copyright (c) 2014 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PDFCreator : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UILabel *clientLabel;
@property (nonatomic, weak) IBOutlet UILabel *footerLabel;
@property (nonatomic, weak) IBOutlet UILabel *pageLabel;

@property (nonatomic, weak) IBOutlet UILabel *barcodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *subproductLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, assign) int line;

- (NSString *)createPdfOfClient:(NSManagedObject *)client;

@end
