//
//  Subproducts+CoreDataProperties.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Subproducts+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Subproducts (CoreDataProperties)

+ (NSFetchRequest<Subproducts *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *barcode;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSString *profit;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *quantityCartoon;
@property (nullable, nonatomic, copy) NSString *quantityColor;
@property (nullable, nonatomic, copy) NSString *quantityPackage;
@property (nullable, nonatomic, copy) NSString *subproduct;
@property (nullable, nonatomic, retain) NSSet<Orders *> *orders;
@property (nullable, nonatomic, retain) Products *product;

@end

@interface Subproducts (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Orders *)value;
- (void)removeOrdersObject:(Orders *)value;
- (void)addOrders:(NSSet<Orders *> *)values;
- (void)removeOrders:(NSSet<Orders *> *)values;

@end

NS_ASSUME_NONNULL_END
