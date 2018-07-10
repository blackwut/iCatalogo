//
//  ClientsViewController.m
//  iCatalogo
//
//  Created by Albertomac on 30/09/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "ClientsViewController.h"
#import "AppDelegate.h"
#import "OrderViewController.h"

@interface ClientsViewController ()
@property (strong, nonatomic) NSMutableArray *list;
@end


@implementation ClientsViewController

@synthesize list;

- (void)showListWith:(NSPredicate *)predicate
{
    list = [[AppDelegate sharedAppDelegate] searchEntity:@"Clients" withPredicate:predicate sortedBy:@"client"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]%2 == 0)
        [cell setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(122/255.0) blue:(255/255.0) alpha:0.25]];
    else [cell setBackgroundColor:[UIColor clearColor]];
    
    NSManagedObject *object = [list objectAtIndex:[indexPath row]];
    UILabel *client = (UILabel *)[cell viewWithTag:1];
    UILabel *country = (UILabel *)[cell viewWithTag:2];
    UILabel *address = (UILabel *)[cell viewWithTag:3];
    UILabel *telephone = (UILabel *)[cell viewWithTag:4];
    
    [client setText:[object valueForKey:@"client"]];
    [country setText:[object valueForKey:@"country"]];
    [address setText:[object valueForKey:@"address"]];
    [telephone setText:[object valueForKey:@"telephone"]];
}

#pragma mark SearchBar

- (void)search:(UISearchBar *)searchBar
{
    NSString *column;
    switch (searchBar.selectedScopeButtonIndex) {
        case 0:
            column = @"client";
            break;
            
        case 1:
            column = @"country";
            break;
    }
    
    if([searchBar.text isEqualToString:@""]){
        [self showListWith:nil];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", column, searchBar.text];
        [self showListWith:predicate];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self search:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self search:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:nil];
	[self showListWith:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OrderViewController *orderViewController = [segue destinationViewController];
    orderViewController.client = [list objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
}

#pragma mark Application

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showListWith:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Clienti"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end