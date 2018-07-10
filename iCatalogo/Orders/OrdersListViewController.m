//
//  OrdersViewController.m
//  iCatalogo
//
//  Created by Albertomac on 01/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "OrdersListViewController.h"

@interface OrdersListViewController ()
@end

@implementation OrdersListViewController


#pragma mark - TableView
- (void)deleteObjectWithIndexPath:(NSIndexPath *)index
{
    
    NSManagedObject *client = [self.list objectAtIndex:[index row]];
    NSArray *orders = [[client valueForKey:@"orders"] allObjects];
    
    //Elimina gli ordini del cliente dall'entity Orders
    [[AppDelegate sharedAppDelegate] deleteObjects:orders error:nil];
    
    [self.list removeObject:client];
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *client = (UILabel *)[cell viewWithTag:1];
    UILabel *total = (UILabel *)[cell viewWithTag:2];
    
    [client setText:[object valueForKey:@"client"]];
    [total setText:[[AppDelegate sharedAppDelegate] getTotalOrderOf:object]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"order"]){
        OrderViewController *controller = [segue destinationViewController];
        controller.client =  [self.list objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}

#pragma mark Application

- (void)configureView
{
    [self setTitle:@"Ordini"];
    [self setEntity:@"Clients"];
    [self setSortedAttribute:@"client"];
    [self setPredicate:[NSPredicate predicateWithFormat:@"ANY orders != nil"]];
    
    [self setCanEdit:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setDelegate:self];
    [super viewWillAppear:animated];
}

@end