//
//  FilterViewController.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 13/08/2018.
//  Copyright © 2018 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogListViewController.h"



@interface FilterCatalogListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) CatalogListViewController * catalogListViewController;

@end
