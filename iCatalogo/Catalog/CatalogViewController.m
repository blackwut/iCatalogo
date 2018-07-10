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
    
    [self.navigationController setToolbarHidden:YES];
    
    NSArray *images = [NSArray arrayWithObjects:imageOne, imageTwo, imageThree, imageFour, imageFive, imageSix, nil];
    NSArray *subproducts = @[_subproductsOne, _subproductsTwo, _subproductsThree, _subproductsFour, _subproductsFive, _subproductsSix];
    NSArray *labels = [NSArray arrayWithObjects:labelOne, labelTwo, labelThree, labelFour, labelFive, labelSix, nil];
    
    for(int i = 0; i<6; i++){
        
        UIButton *image = [images objectAtIndex:i];
        SubproductsCollectionView *subproductsView = [subproducts objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        
        int indexProduct = (6*(page-1) +i);
        
        if(indexProduct < [list count]){
            NSManagedObject *object = [list objectAtIndex:indexProduct];
            UIImage *img = [UIImage imageWithContentsOfFile:[object valueForKey:@"photo"]];
            
            [image setBackgroundImage:img forState:UIControlStateNormal];
            [label setText:[object valueForKey:@"product"]];
            
            
            [[image layer] setBorderWidth:1.0f];
            [[image layer] setBorderColor:[UIColor blackColor].CGColor];
            [[image layer] setCornerRadius:10.0f];
            [[image layer] setMasksToBounds:YES];
            
            
            [subproductsView setupWithProduct:object];

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
