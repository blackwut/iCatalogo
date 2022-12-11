//
//  Clients+CoreDataProperties.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Clients+CoreDataProperties.h"

@implementation Clients (CoreDataProperties)

+ (NSFetchRequest<Clients *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Clients"];
}

@dynamic address;
@dynamic client;
@dynamic country;
@dynamic email;
@dynamic id;
@dynamic telephone;
@dynamic orders;

@end
