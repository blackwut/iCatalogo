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
@end

@implementation CatalogViewController

@synthesize imageOne, imageTwo, imageThree, imageFour, imageFive, imageSix;
@synthesize labelOne, labelTwo, labelThree, labelFour, labelFive, labelSix;
@synthesize supplierOne, supplierTwo, supplierThree, supplierFour, supplierFive, supplierSix;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
	BOOL showSubproductsCollectionView = [options boolForKey:showSubproductsOption];
    
    [self.navigationController setToolbarHidden:YES];
    
    NSArray *images = [NSArray arrayWithObjects:imageOne, imageTwo, imageThree, imageFour, imageFive, imageSix, nil];
    NSArray *subproducts = [NSArray arrayWithObjects:_subproductsOne, _subproductsTwo, _subproductsThree, _subproductsFour, _subproductsFive, _subproductsSix, nil];
    NSArray *labels = [NSArray arrayWithObjects:labelOne, labelTwo, labelThree, labelFour, labelFive, labelSix, nil];
	NSArray *supplierLabels = [NSArray arrayWithObjects:supplierOne, supplierTwo, supplierThree, supplierFour, supplierFive, supplierSix, nil];
    
    for (int i = 0; i < 6; ++i){
        
        UIButton *image = [images objectAtIndex:i];
        SubproductsCollectionView *subproductsView = [subproducts objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
		UILabel *supplierLabel = [supplierLabels objectAtIndex:i];
        
        int indexProduct = (6 * (page - 1) + i);
        
        if(indexProduct < [list count]){
            NSManagedObject *object = [list objectAtIndex:indexProduct];
			NSString *imagePath = [object valueForKey:@"photo"];
            //UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
			UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
			
            [image setBackgroundImage:img forState:UIControlStateNormal];
            [label setText:[object valueForKey:@"product"]];
			[supplierLabel setText:[object valueForKey:@"supplier"]];
            
            [[image layer] setBorderWidth:1.0f];
            [[image layer] setBorderColor:[UIColor blackColor].CGColor];
            [[image layer] setCornerRadius:10.0f];
            [[image layer] setMasksToBounds:YES];
            
			if ( showSubproductsCollectionView ) {
            	[subproductsView setupWithProduct:object];
			} else {
				[subproductsView setHidden:YES];
			}

        } else {
            [image setEnabled:false];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
