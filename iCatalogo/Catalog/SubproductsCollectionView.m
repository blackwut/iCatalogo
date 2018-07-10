//
//  SubproductsCollectionView.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 04/10/15.
//  Copyright © 2015 Albertomac. All rights reserved.
//

#import "SubproductsCollectionView.h"
#import "SubproductCollectionViewCell.h"

@interface SubproductsCollectionView()

@property (strong, nonatomic) NSArray *subproductsArray;

@end

@implementation SubproductsCollectionView


- (void)configure
{
    [self setDataSource:self];
    [self setDelegate:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)setupWithProduct:(NSManagedObject *)product
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subproduct" ascending:YES];
    _subproductsArray = [[[product valueForKey:@"subproducts"] allObjects] sortedArrayUsingDescriptors:@[sort]];
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_subproductsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubproductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubproductCollectionViewCell" forIndexPath:indexPath];
    [cell setupWithSubproduct:[_subproductsArray objectAtIndex:indexPath.row]];
    return cell;
}

@end
