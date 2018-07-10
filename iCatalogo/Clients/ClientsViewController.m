//
//  ClientsViewController.m
//  iCatalogo
//
//  Created by Albertomac on 30/09/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "ClientsViewController.h"

@interface ClientsViewController ()
@end

@implementation ClientsViewController


- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *client = (UILabel *)[cell viewWithTag:1];
    UILabel *country = (UILabel *)[cell viewWithTag:2];
    UILabel *address = (UILabel *)[cell viewWithTag:3];
    UILabel *telephone = (UILabel *)[cell viewWithTag:4];
    
    [client setText:[object valueForKey:@"client"]];
    [country setText:[object valueForKey:@"country"]];
    [address setText:[object valueForKey:@"address"]];
    [telephone setText:[object valueForKey:@"telephone"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"order"]){
        OrderViewController *orderViewController = [segue destinationViewController];
        orderViewController.client = [self.list objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}

#pragma -mark SearchBar

- (void)searchList;
{
    NSString *attribute;
    NSString *text = [self.search text];
    
    switch (self.search.selectedScopeButtonIndex) {
        case 0:
            attribute = @"client";
            break;
            
        case 1:
            attribute = @"country";
            break;
    }
    
    if([text length] > 0)
        [self setPredicate:[NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", attribute, text]];
    else [self setPredicate:nil];
    
    [self loadList];
}

#pragma mark Application

- (void)configureView
{
    [self setTitle:@"Clienti"];
    [self setEntity:@"Clients"];
    [self setSortedAttribute:@"client"];
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