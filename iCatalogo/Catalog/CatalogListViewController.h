//
//  CatalogListViewController.h
//  iCatalogo
//
//  Created by Albertomac on 01/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "TableViewController.h"
#import "CatalogPageViewController.h"
#import "ProductViewController.h"

#define categoryButtonIndex 0
#define supplierButtonIndex 1
#define filterSupplier @"supplier"
#define filterCategory @"category"

@interface CatalogListViewController : TableViewController <TableViewDelegate>

@property (strong, nonatomic) NSManagedObject *client;

- (void)setSearchText:(NSString *)searchText forFilterType:(NSInteger)type;

@end
