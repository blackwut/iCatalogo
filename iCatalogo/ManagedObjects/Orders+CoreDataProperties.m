//
//  Orders+CoreDataProperties.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Orders+CoreDataProperties.h"

@implementation Orders (CoreDataProperties)

+ (NSFetchRequest<Orders *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Orders"];
}

@dynamic note;
@dynamic quantity;
@dynamic xCartoon;
@dynamic xColor;
@dynamic xPackage;
@dynamic xSubproduct;
@dynamic xType;
@dynamic client;
@dynamic subproduct;

@end
