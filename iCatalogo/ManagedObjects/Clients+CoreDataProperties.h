//
//  Clients+CoreDataProperties.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Clients+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Clients (CoreDataProperties)

+ (NSFetchRequest<Clients *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *client;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *telephone;
@property (nullable, nonatomic, retain) NSSet<Orders *> *orders;

@end

@interface Clients (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Orders *)value;
- (void)removeOrdersObject:(Orders *)value;
- (void)addOrders:(NSSet<Orders *> *)values;
- (void)removeOrders:(NSSet<Orders *> *)values;

@end

NS_ASSUME_NONNULL_END
