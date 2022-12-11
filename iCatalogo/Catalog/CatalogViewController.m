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
    if([[segue identifier] isEqualToString:@"product"]){
        int indexProduct = (int)(6*(page-1) + [sender tag]);
        
        ProductViewController *controller = [segue destinationViewController];
        [controller setClient:client];
        [controller setProduct:[list objectAtIndex:indexProduct]];
    }
}

- (void)customizeImageButton:(UIButton *)button
{
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    [[button layer] setCornerRadius:10.0f];
    [[button layer] setMasksToBounds:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES];
    
    _images = [NSArray arrayWithObjects:_imageOne, _imageTwo, _imageThree, _imageFour, _imageFive, _imageSix, nil];
    _labels = [NSArray arrayWithObjects:_labelOne, _labelTwo, _labelThree, _labelFour, _labelFive, _labelSix, nil];
    _suppliers = [NSArray arrayWithObjects:_supplierOne, _supplierTwo, _supplierThree, _supplierFour, _supplierFive, _supplierSix, nil];
    _subproductsViews = [NSArray arrayWithObjects:_subproductsOne, _subproductsTwo, _subproductsThree, _subproductsFour, _subproductsFive, _subproductsSix, nil];
    
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

        UIButton * image = [_images objectAtIndex:i];
        UILabel * label = [_labels objectAtIndex:i];
		UILabel * supplierLabel = [_suppliers objectAtIndex:i];
        SubproductsCollectionView * subproductsView = [_subproductsViews objectAtIndex:i];

        if (indexProduct < [list count]) {
            NSManagedObject * object = [list objectAtIndex:indexProduct];
			NSURL *photoURL = [AppDelegate absoluteURLWithFilePath:[object valueForKey:@"photo"]];
			UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
			
            [image setBackgroundImage:photo forState:UIControlStateNormal];
            [label setText:[object valueForKey:@"product"]];
			[supplierLabel setText:[object valueForKey:@"supplier"]];
            
			if (showSubproductsCollectionView) {
            	[subproductsView setupWithProduct:object];
			} else {
				[subproductsView setHidden:YES];
			}

        } else {
            [image setEnabled:NO];
            [image setHidden:YES];
            [label setText:@""];
            [supplierLabel setText:@""];
            [subproductsView setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
