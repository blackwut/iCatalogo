//
//  Orders+CoreDataProperties.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 21/08/2022.
//  Copyright © 2022 Albertomac. All rights reserved.
//
//

#import "Orders+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Orders (CoreDataProperties)

+ (NSFetchRequest<Orders *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *xCartoon;
@property (nullable, nonatomic, copy) NSString *xColor;
@property (nullable, nonatomic, copy) NSString *xPackage;
@property (nullable, nonatomic, copy) NSString *xSubproduct;
@property (nullable, nonatomic, copy) NSString *xType;
@property (nullable, nonatomic, retain) Clients *client;
@property (nullable, nonatomic, retain) Subproducts *subproduct;

@end

NS_ASSUME_NONNULL_END
