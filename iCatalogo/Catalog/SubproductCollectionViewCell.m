//
//  SubproductCollectionViewCell.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 04/10/15.
//  Copyright © 2015 Albertomac. All rights reserved.
//

#import "SubproductCollectionViewCell.h"

@implementation SubproductCollectionViewCell

- (void)setupWithSubproduct:(NSManagedObject *)subproduct
{
    [_subproductLabel setText:[subproduct valueForKey:@"subproduct"]];
    [_priceLabel setText:[subproduct valueForKey:@"price"]];
}

@end
