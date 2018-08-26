//
//  FilterCatalogViewController.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 17/08/2018.
//  Copyright © 2018 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CatalogPageViewController;

@interface FilterCatalogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView * subproductsTable;
@property (strong, nonatomic) IBOutlet UITableView * categoriesTable;
@property (strong, nonatomic) IBOutlet UITableView * suppliersTable;

@property (strong, nonatomic) CatalogPageViewController * catalogPageViewController;

@end
