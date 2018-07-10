//
//  CatalogListViewController.m
//  iCatalogo
//
//  Created by Albertomac on 01/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "CatalogListViewController.h"

@interface CatalogListViewController ()
@property (strong, nonatomic) UISegmentedControl *segmented;
@end

@implementation CatalogListViewController

@synthesize client;
@synthesize segmented;


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *product = (UILabel *)[cell viewWithTag:1];
    UILabel *category = (UILabel *)[cell viewWithTag:2];
    UILabel *supplier = (UILabel *)[cell viewWithTag:3];
    
    [product setText:[object valueForKey:@"product"]];
    [category setText:[object valueForKey:@"category"]];
    [supplier setText:[object valueForKey:@"supplier"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]  isEqualToString: @"catalogPage"] ){
        CatalogPageViewController *controller = [segue destinationViewController];
        controller.client = client;
        controller.list = self.list;
        
    } else if([[segue identifier] isEqualToString:@"product"]) {
        ProductViewController *controller = [segue destinationViewController];
        controller.client = client;
        controller.product = [self.list objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}


- (void)loadList
{
    if(self.entity != nil){
        
        self.list = [[AppDelegate sharedAppDelegate] searchEntity:self.entity withPredicate:self.predicate sortedByArray:@[self.sortedAttribute, @"product"]];
        [self.tableView reloadData];
    }
}

#pragma -mark Search

- (void)changeSort
{
    NSInteger selectedSort = [segmented selectedSegmentIndex];
    switch (selectedSort) {
        case 0:
            [self setSortedAttribute:@"product"];
            break;
            
        case 1:
            [self setSortedAttribute:@"category"];
            break;
            
        case 2:
            [self setSortedAttribute:@"supplier"];
            break;
    }
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    [options setInteger:selectedSort forKey:searchSortAttribute];
    
    [self loadList];
}

- (void)searchList
{
    NSString *text = [self.search text];
    NSString *attribute;
    NSInteger selectedColumn = [self.search selectedScopeButtonIndex];
    
    switch (selectedColumn) {
        case 0:
            attribute = @"product";
            break;
            
        case 1:
            attribute = @"category";
            break;
            
        case 2:
            attribute = @"supplier";
    }
    
    if([text length] > 0)
        [self setPredicate:[NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", attribute, text]];
    else [self setPredicate:nil];
    
    
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    [options setObject:text forKey:searchText];
    [options setInteger:selectedColumn forKey:searchColumn];
    [options setBool:YES forKey:searchChanged];
    
    [self loadList];
}

- (void)restoreSearch
{
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    
    [self.search setText:[options stringForKey:searchText]];
    [self.search setSelectedScopeButtonIndex:[options integerForKey:searchColumn]];
    [self.segmented setSelectedSegmentIndex:[options integerForKey:searchSortAttribute]];
    
    switch ([segmented selectedSegmentIndex]) {
        case 0:
            [self setSortedAttribute:@"product"];
            break;
            
        case 1:
            [self setSortedAttribute:@"category"];
            break;
            
        case 2:
            [self setSortedAttribute:@"supplier"];
            break;
    }
    
    NSString *text = [self.search text];
    NSString *attribute;
    NSInteger selectedColumn = [self.search selectedScopeButtonIndex];
    
    switch (selectedColumn) {
        case 0:
            attribute = @"product";
            break;
            
        case 1:
            attribute = @"category";
            break;
            
        case 2:
            attribute = @"supplier";
    }
    
    if([text length] > 0)
        [self setPredicate:[NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", attribute, text]];
    else [self setPredicate:nil];
}

#pragma -mark Application

- (void)configureView
{
    [self setTitle:@"Catalogo"];
    [self setEntity:@"Products"];
    
    UIBarButtonItem *flexyLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexyRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Crea la segmented per la modifica dell'ordinamento della lista
    segmented = [[UISegmentedControl alloc] initWithItems:@[@"Descrizione", @"Categoria", @"Fornitore"]];
    [segmented setSelectedSegmentIndex:0];
    [segmented addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:segmented];
    
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:@[flexyLeft, item, flexyRight]];

    [self restoreSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setDelegate:self];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.search setShowsScopeBar:YES];
    [self.search sizeToFit];
}

@end