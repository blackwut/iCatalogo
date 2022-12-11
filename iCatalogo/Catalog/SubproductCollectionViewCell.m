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
    _subproductLabel.text = [subproduct valueForKey:@"subproduct"];
    _priceLabel.text = [subproduct valueForKey:@"price"];
}

@end
