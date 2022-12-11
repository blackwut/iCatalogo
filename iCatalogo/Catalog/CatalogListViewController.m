//
//  CatalogListViewController.m
//  iCatalogo
//
//  Created by Albertomac on 01/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "CatalogListViewController.h"

#import "FilterCatalogListViewController.h"


@interface CatalogListViewController ()
@property (strong, nonatomic) UISegmentedControl *segmented;
@property (strong, nonatomic) UIBarButtonItem *filterButton;

@property (strong, nonatomic) NSString *barcodeText;
@end

@implementation CatalogListViewController

@synthesize client;
@synthesize segmented, filterButton;


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *product = (UILabel *)[cell viewWithTag:1];
    UILabel *category = (UILabel *)[cell viewWithTag:2];
    UILabel *supplier = (UILabel *)[cell viewWithTag:3];
    
    product.text = [object valueForKey:@"product"];
    category.text = [object valueForKey:@"category"];
    supplier.text = [object valueForKey:@"supplier"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier  isEqualToString: @"catalogPage"] ){
        CatalogPageViewController *controller = segue.destinationViewController;
        controller.client = client;
		controller.originalList = self.list;
        controller.list = self.list;
        
    } else if([segue.identifier isEqualToString:@"product"]) {
        ProductViewController *controller = segue.destinationViewController;
        controller.client = client;
        controller.product = (self.list)[(self.tableView).indexPathForSelectedRow.row];
        controller.barcodeText = self.barcodeText;
    }
}


- (void)loadList
{
    if (self.entity != nil) {
        self.list = [[AppDelegate sharedAppDelegate] searchEntity:self.entity withPredicate:self.predicate sortedByArray:@[self.sortedAttribute, @"product"]];
        [self.tableView reloadData];
    }
}

- (IBAction)filterButtonTouched:(id)sender
{
	
	FilterCatalogListViewController * filterViewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"filterCatalogListViewController"];
	filterViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	filterViewController.catalogListViewController = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filterViewController];
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentViewController:navigationController animated:YES completion:nil];
}

#pragma -mark Search

- (void)changeSort
{
    NSInteger selectedSort = segmented.selectedSegmentIndex;
    switch (selectedSort) {
        case 0:
            self.sortedAttribute = @"product";
            break;
            
        case 1:
            self.sortedAttribute = @"category";
            break;
            
        case 2:
            self.sortedAttribute = @"supplier";
            break;
    }
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    [options setInteger:selectedSort forKey:searchSortAttribute];
    
    [self loadList];
}

- (void)updatePredicateWith:(NSString *)text andAttributeID:(NSInteger)attributeID
{
    static NSArray *_attributes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _attributes = @[@"product", @"category", @"supplier", @"subproducts.barcode"]; });
    
    NSString * attribute = _attributes[attributeID];
    NSArray * argumentArray = @[attribute, text];
    
    self.predicate = nil;
    if (text.length > 0) {
        if (attributeID == 3) { // barcode = 3
            self.barcodeText = text;
            self.predicate = [NSPredicate predicateWithFormat:@"ANY %K ENDSWITH[cd] %@" argumentArray:argumentArray];
        } else {
            self.predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@" argumentArray:argumentArray];
        }
    }
}

- (void)searchList
{
    NSString *text = (self.search).text;
    NSInteger selectedColumn = (self.search).selectedScopeButtonIndex;
    [self updatePredicateWith:text andAttributeID:selectedColumn];
    
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    [options setObject:text forKey:searchText];
    [options setInteger:selectedColumn forKey:searchColumn];
    [options setBool:YES forKey:searchChanged];
    
    [self loadList];
}

- (void)restoreSearch
{
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    
    (self.search).text = [options stringForKey:searchText];
    (self.search).selectedScopeButtonIndex = [options integerForKey:searchColumn];
    (self.segmented).selectedSegmentIndex = [options integerForKey:searchSortAttribute];
    
    switch (segmented.selectedSegmentIndex) {
        case 0:
            self.sortedAttribute = @"product";
            break;
            
        case 1:
            self.sortedAttribute = @"category";
            break;
            
        case 2:
            self.sortedAttribute = @"supplier";
            break;
    }
    
    NSString *text = (self.search).text;
    NSInteger selectedColumn = (self.search).selectedScopeButtonIndex;
    [self updatePredicateWith:text andAttributeID:selectedColumn];
}

#pragma -mark Application

- (void)configureView
{
    self.title = @"Catalogo";
    self.entity = @"Products";
    
    UIBarButtonItem *flexyLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexyRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Crea la segmented per la modifica dell'ordinamento della lista
    segmented = [[UISegmentedControl alloc] initWithItems:@[@"Descrizione", @"Categoria", @"Fornitore"]];
    segmented.selectedSegmentIndex = 0;
    [segmented addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:segmented];
	
	filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Ricerca" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTouched:)];
    
    [self.navigationController setToolbarHidden:NO];
    self.toolbarItems = @[flexyLeft, item, flexyRight, filterButton];

    [self restoreSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.search setShowsScopeBar:YES];
    [self.search sizeToFit];
}

- (void)setSearchText:(NSString *)searchText forFilterType:(NSInteger)type
{
	(self.search).selectedScopeButtonIndex = type + 1; //+1 because the first index is the product description
	(self.search).text = searchText;
	[self searchList];
}

@end
