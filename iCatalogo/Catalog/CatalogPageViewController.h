//
//  CatalogPageViewController.h
//  iCatalogo
//
//  Created by Albertomac on 03/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *pageField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *totalButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * filterButton;

- (IBAction)filterButtonTouched:(id)sender;
- (void)reloadPageViewController;

@property (strong, nonatomic) NSManagedObject *client;
@property (strong, nonatomic) NSArray * originalList;
@property (strong, nonatomic) NSArray *list;
@property int page;
@property int maxPage;

@end
