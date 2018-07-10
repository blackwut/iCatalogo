//
//  CatalogViewController.h
//  iCatalogo
//
//  Created by Albertomac on 03/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SubproductsCollectionView.h"

@interface CatalogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *imageOne;
@property (weak, nonatomic) IBOutlet UIButton *imageTwo;
@property (weak, nonatomic) IBOutlet UIButton *imageThree;
@property (weak, nonatomic) IBOutlet UIButton *imageFour;
@property (weak, nonatomic) IBOutlet UIButton *imageFive;
@property (weak, nonatomic) IBOutlet UIButton *imageSix;

@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsOne;
@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsTwo;
@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsThree;
@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsFour;
@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsFive;
@property (weak, nonatomic) IBOutlet SubproductsCollectionView *subproductsSix;

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;

@property (strong, nonatomic) NSManagedObject *client;
@property (strong, nonatomic) NSArray *list;
@property int page;

@end
