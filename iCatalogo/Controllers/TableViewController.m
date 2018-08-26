//
//  TableViewController.m
//  iCatalogo
//
//  Created by Albertomac on 06/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@end

@implementation TableViewController

@synthesize delegate, search, entity, sortedAttribute, predicate, list, canEdit, coloredTable;

- (void)loadList
{
    if(entity != nil){
        self.list = [[AppDelegate sharedAppDelegate] searchEntity:entity withPredicate:predicate sortedBy:sortedAttribute];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(coloredTable){
		UIColor * selectedColor = (indexPath.row % 2 == 0 ? lightBlue : [UIColor clearColor]);
		[cell setBackgroundColor:selectedColor];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSManagedObject *object = [list objectAtIndex:[indexPath row]];
    
    [self.delegate configureCell:cell withObject:object];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){        
        
        if([self.delegate respondsToSelector:@selector(deleteObjectWithIndexPath:)]){
            
            [self.delegate deleteObjectWithIndexPath:indexPath];
        
        } else {
            
            NSManagedObject *object = [self.list objectAtIndex:[indexPath row]];
            [[AppDelegate sharedAppDelegate] deleteObject:object error:nil];
            [self.list removeObject:object];
        }
        
        [tableView reloadData];
    }
}

#pragma SearchBar

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if([self.delegate respondsToSelector:@selector(searchList)])
        [self.delegate searchList];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self.delegate searchList];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [search setText:@""];
	
    if([self.delegate respondsToSelector:@selector(searchList)])
        [self.delegate searchList];

    [search resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
}

#pragma mark Application

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[self.tableView setSeparatorInset:UIEdgeInsetsZero];

    [self.search setDelegate:self];
    
    [self.navigationController setToolbarHidden:YES];
    [self setCanEdit:NO];
    [self setColoredTable:YES];
    
    [self.delegate configureView];
    [self loadList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
