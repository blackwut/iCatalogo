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

@interface CatalogListViewController : TableViewController <TableViewDelegate>

@property (strong, nonatomic) NSManagedObject *client;

@end
