//
//  CatalogViewController.m
//  iCatalogo
//
//  Created by Albertomac on 03/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "CatalogViewController.h"
#import "ProductViewController.h"

@interface CatalogViewController ()
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * labels;
@property (nonatomic, strong) NSArray * suppliers;
@property (nonatomic, strong) NSArray * subproductsViews;
@end

@implementation CatalogViewController

//@synthesize imageOne, imageTwo, imageThree, imageFour, imageFive, imageSix;
//@synthesize labelOne, labelTwo, labelThree, labelFour, labelFive, labelSix;
//@synthesize supplierOne, supplierTwo, supplierThree, supplierFour, supplierFive, supplierSix;
@synthesize client, list, page;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"product"]){
        int indexProduct = (int)(6*(page-1) + [sender tag]);
        
        ProductViewController *controller = segue.destinationViewController;
        controller.client = client;
        controller.product = list[indexProduct];
    }
}

- (void)customizeImageButton:(UIButton *)button
{
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 10.0f;
    [button.layer setMasksToBounds:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES];
    
    _images = @[_imageOne, _imageTwo, _imageThree, _imageFour, _imageFive, _imageSix];
    _labels = @[_labelOne, _labelTwo, _labelThree, _labelFour, _labelFive, _labelSix];
    _suppliers = @[_supplierOne, _supplierTwo, _supplierThree, _supplierFour, _supplierFive, _supplierSix];
    _subproductsViews = @[_subproductsOne, _subproductsTwo, _subproductsThree, _subproductsFour, _subproductsFive, _subproductsSix];
    
    for (UIButton * b in _images) {
        [self customizeImageButton:b];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
	BOOL showSubproductsCollectionView = [options boolForKey:showSubproductsOption];
    
    for (int i = 0; i < 6; ++i) {
        
        int indexProduct = (6 * (page - 1) + i);

        UIButton * image = _images[i];
        UILabel * label = _labels[i];
		UILabel * supplierLabel = _suppliers[i];
        SubproductsCollectionView * subproductsView = _subproductsViews[i];

        if (indexProduct < list.count) {
            NSManagedObject * object = list[indexProduct];
			NSURL *photoURL = [AppDelegate absoluteURLWithFilePath:[object valueForKey:@"photo"]];
			UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
			
            [image setBackgroundImage:photo forState:UIControlStateNormal];
            label.text = [object valueForKey:@"product"];
			supplierLabel.text = [object valueForKey:@"supplier"];
            
			if (showSubproductsCollectionView) {
            	[subproductsView setupWithProduct:object];
			} else {
				[subproductsView setHidden:YES];
			}

        } else {
            [image setEnabled:NO];
            [image setHidden:YES];
            label.text = @"";
            supplierLabel.text = @"";
            [subproductsView setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
