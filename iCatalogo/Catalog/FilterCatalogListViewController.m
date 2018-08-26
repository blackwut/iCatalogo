//
//  FilterViewController.m
//  iCatalogo
//
//  Created by Alberto Ottimo on 13/08/2018.
//  Copyright © 2018 Albertomac. All rights reserved.
//

#import "FilterCatalogListViewController.h"
#import "AppDelegate.h"


@interface FilterCatalogListViewController ()

@property (nonatomic, strong) UISegmentedControl * filterControl;
@property (nonatomic, strong) NSArray * filterResult;
@property (nonatomic, strong) NSString * filterType;

@end

@implementation FilterCatalogListViewController

@synthesize tableView, catalogListViewController;
@synthesize filterControl, filterResult, filterType;

- (void)closeButtonTouched:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
	}];
}

- (IBAction)filterControlChangeValue:(id)sender
{
	switch ([filterControl selectedSegmentIndex]) {
		case categoryButtonIndex:
			filterType = filterCategory;
			break;
		case supplierButtonIndex:
			filterType = filterSupplier;
			break;
			
		default:
			break;
	}
	
	filterResult = [[AppDelegate sharedAppDelegate] searchEntity:@"Products" withDistinctSelectedAttribute:filterType];
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTouched:)];
	self.navigationItem.rightBarButtonItem = closeButton;
	
	filterControl = [[UISegmentedControl alloc] initWithItems:@[@"Categorie", @"Fornitori"]];
	[filterControl addTarget:self action:@selector(filterControlChangeValue:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = filterControl;
	[filterControl setSelectedSegmentIndex:categoryButtonIndex];
	[self filterControlChangeValue:filterControl];
	
	[self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [filterResult count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIColor * selectedColor = (indexPath.row % 2 == 0 ? lightBlue : [UIColor clearColor]);
	[cell setBackgroundColor:selectedColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"categorySupplierCell";
	
	NSString * text = [[filterResult objectAtIndex:indexPath.row] valueForKey:filterType];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

	[[cell viewWithTag:1] setText:text];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString * selectedText = [[filterResult objectAtIndex:indexPath.row] valueForKey:filterType];
	[catalogListViewController setSearchText:selectedText forFilterType:[filterControl selectedSegmentIndex]];
	[self dismissViewControllerAnimated:YES completion:^{
	}];
}

@end
