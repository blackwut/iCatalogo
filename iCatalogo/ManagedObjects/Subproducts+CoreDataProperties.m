//
//  Subproducts+CoreDataProperties.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Subproducts+CoreDataProperties.h"

@implementation Subproducts (CoreDataProperties)

+ (NSFetchRequest<Subproducts *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Subproducts"];
}

@dynamic barcode;
@dynamic id;
@dynamic note;
@dynamic price;
@dynamic profit;
@dynamic quantity;
@dynamic quantityCartoon;
@dynamic quantityColor;
@dynamic quantityPackage;
@dynamic subproduct;
@dynamic orders;
@dynamic product;

@end
