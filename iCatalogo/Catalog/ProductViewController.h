//
//  ProductViewController.h
//  iCatalogo
//
//  Created by Albertomac on 05/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "AMessage.h"
#import "APhoto.h"

@interface ProductViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *productLabel;
@property (strong, nonatomic) IBOutlet UILabel *supplierLabel;
@property (strong, nonatomic) IBOutlet UITextField *xSubproduct;
@property (strong, nonatomic) IBOutlet UITextField *xColor;
@property (strong, nonatomic) IBOutlet UITextField *xType;
@property (strong, nonatomic) IBOutlet UITextField *xPackage;
@property (strong, nonatomic) IBOutlet UITextField *xCartoon;
@property (strong, nonatomic) IBOutlet UITextField *note;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UIButton *add;
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) NSManagedObject *client;
@property (strong, nonatomic) NSManagedObject *order;
@property (strong, nonatomic) NSManagedObject *product;

@property (strong, nonatomic) NSString *barcodeText;

@end
