//
//  Products+CoreDataProperties.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Products+CoreDataProperties.h"

@implementation Products (CoreDataProperties)

+ (NSFetchRequest<Products *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Products"];
}

@dynamic category;
@dynamic id;
@dynamic photo;
@dynamic photo_hash;
@dynamic product;
@dynamic supplier;
@dynamic subproducts;

@end
