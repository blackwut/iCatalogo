//
//  Products+CoreDataProperties.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Products+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Products (CoreDataProperties)

+ (NSFetchRequest<Products *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *photo;
@property (nullable, nonatomic, copy) NSString *photo_hash;
@property (nullable, nonatomic, copy) NSString *product;
@property (nullable, nonatomic, copy) NSString *supplier;
@property (nullable, nonatomic, retain) NSSet<Subproducts *> *subproducts;

@end

@interface Products (CoreDataGeneratedAccessors)

- (void)addSubproductsObject:(Subproducts *)value;
- (void)removeSubproductsObject:(Subproducts *)value;
- (void)addSubproducts:(NSSet<Subproducts *> *)values;
- (void)removeSubproducts:(NSSet<Subproducts *> *)values;

@end

NS_ASSUME_NONNULL_END
