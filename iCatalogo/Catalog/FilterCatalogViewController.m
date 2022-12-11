//
//  FilterCatalogViewController.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 17/08/2018.
//  Copyright © 2018 Albertomac. All rights reserved.
//

#import "FilterCatalogViewController.h"
#import "CatalogPageViewController.h"
#import "Constants.h"

@interface FilterCatalogViewController ()

@property (strong, nonatomic) NSArray * subproductsList;
@property (strong, nonatomic) NSArray * categoriesList;
@property (strong, nonatomic) NSArray * suppliersList;

@property (strong, nonatomic) NSMutableArray * subproductsFilter;
@property (strong, nonatomic) NSMutableArray * categoriesFilter;
@property (strong, nonatomic) NSMutableArray * suppliersFilter;

@end

@implementation FilterCatalogViewController

@synthesize subproductsTable, categoriesTable, suppliersTable;
@synthesize catalogPageViewController;
@synthesize subproductsList, categoriesList, suppliersList;
@synthesize subproductsFilter, categoriesFilter, suppliersFilter;

- (void)closeButtonTouched:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
	}];
}

- (void)resetButtonTouched:(id)sender
{
	catalogPageViewController.list = catalogPageViewController.originalList;
	[subproductsFilter removeAllObjects];
	[categoriesFilter removeAllObjects];
	[suppliersFilter removeAllObjects];
	[self reloadFilterLists];
	[catalogPageViewController reloadPageViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTouched:)];
	self.navigationItem.rightBarButtonItem = closeButton;
	
	UIBarButtonItem * resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonTouched:)];
	self.navigationItem.leftBarButtonItem = resetButton;
	
	(self.subproductsTable).separatorInset = UIEdgeInsetsZero;
	(self.categoriesTable).separatorInset = UIEdgeInsetsZero;
	(self.suppliersTable).separatorInset = UIEdgeInsetsZero;
	
}

- (void)reloadFilterLists
{
	
	NSArray * list = catalogPageViewController.list;
	
	NSArray * subArray = [list valueForKeyPath:@"subproducts.subproduct"];
	NSMutableArray * subSet = [[NSMutableArray alloc] init];
	for (NSSet * s in subArray) {
		[subSet addObjectsFromArray:s.allObjects];
	}
	subproductsList = [[subSet valueForKeyPath:@"@distinctUnionOfObjects.self"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	categoriesList = [[list valueForKeyPath:@"@distinctUnionOfObjects.category"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	suppliersList = [[list valueForKeyPath:@"@distinctUnionOfObjects.supplier"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	[self.subproductsTable reloadData];
	[self.categoriesTable reloadData];
	[self.suppliersTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	subproductsFilter = [[NSMutableArray alloc] init];
	categoriesFilter = [[NSMutableArray alloc] init];
	suppliersFilter = [[NSMutableArray alloc] init];
	
	[self reloadFilterLists];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == subproductsTable) return subproductsList.count;
	if (tableView == categoriesTable) return categoriesList.count;
	return suppliersList.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIColor * selectedColor = (indexPath.row % 2 == 0 ? lightBlue : [UIColor clearColor]);
	cell.backgroundColor = selectedColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *subproductCellIdentifier = @"subproductCell";
    static NSString *categoryCellIdentifier = @"categoryCell";
    static NSString *supplierCellIdentifier = @"supplierCell";
    
    NSString * cellIdentifier = @"";
    NSString * text = @"";
    
    if (tableView == subproductsTable) {
        cellIdentifier = subproductCellIdentifier;
        text = subproductsList[indexPath.row];
        
    } else if (tableView == categoriesTable) {
        cellIdentifier = categoryCellIdentifier;
        text = categoriesList[indexPath.row];
        
    } else {
        cellIdentifier = supplierCellIdentifier;
        text = suppliersList[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([subproductsFilter containsObject:text] || [categoriesFilter containsObject:text] || [suppliersFilter containsObject:text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [(UILabel *)[cell viewWithTag:1] setText:text];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		if (tableView == subproductsTable) {
			[subproductsFilter addObject:subproductsList[indexPath.row]];
		} else if (tableView == categoriesTable) {
			[categoriesFilter addObject:categoriesList[indexPath.row]];
		} else {
			[suppliersFilter addObject:suppliersList[indexPath.row]];
		}
	} else {
		if (tableView == subproductsTable) {
			[subproductsFilter removeObject:subproductsList[indexPath.row]];
		} else if (tableView == categoriesTable) {
			[categoriesFilter removeObject:categoriesList[indexPath.row]];
		} else {
			[suppliersFilter removeObject:suppliersList[indexPath.row]];
		}
	}

	[self applyFilters];
}


- (void)applyFilters
{
	NSPredicate * subproductsPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
		
		NSArray * subList = [evaluatedObject valueForKeyPath:@"subproducts.subproduct"];
		for (NSString * s in subList) {
			for (NSString * f in subproductsFilter) {
				if ([s compare:f] == NSOrderedSame)
					return YES;
			}
		}
		return NO;
	}];
	
	NSPredicate * categoriesPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
		
		NSString * s = [evaluatedObject valueForKeyPath:@"category"];
		for (NSString * f in categoriesFilter) {
			if ([s compare:f] == NSOrderedSame)
				return YES;
		}
		return NO;
	}];
	
	NSPredicate * suppliersPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
		
		NSString * s = [evaluatedObject valueForKeyPath:@"supplier"];
		for (NSString * f in suppliersFilter) {
			if ([s compare:f] == NSOrderedSame)
				return YES;
		}
		return NO;
	}];
	
	NSArray * values = catalogPageViewController.originalList;

	if (subproductsFilter.count > 0) values = [values filteredArrayUsingPredicate:subproductsPredicate];
	if (categoriesFilter.count > 0) values = [values filteredArrayUsingPredicate:categoriesPredicate];
	if (suppliersFilter.count > 0) values = [values filteredArrayUsingPredicate:suppliersPredicate];
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setBool:YES forKey:searchChanged];
	
	catalogPageViewController.list = values;
	[catalogPageViewController reloadPageViewController];
	
	[self reloadFilterLists];
}

@end
