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
    
    NSManagedObject *client = (self.list)[index.row];
    NSArray *orders = [[client valueForKey:@"orders"] allObjects];
    
    //Elimina gli ordini del cliente dall'entity Orders
    [[AppDelegate sharedAppDelegate] deleteObjects:orders error:nil];
    
    [self.list removeObject:client];
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *client = (UILabel *)[cell viewWithTag:1];
    UILabel *total = (UILabel *)[cell viewWithTag:2];
    
    client.text = [object valueForKey:@"client"];
    total.text = [[AppDelegate sharedAppDelegate] getTotalOrderOf:object];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"order"]){
        OrderViewController *controller = segue.destinationViewController;
        controller.client =  (self.list)[(self.tableView).indexPathForSelectedRow.row];
    }
}

#pragma mark Application

- (void)configureView
{
    self.title = @"Ordini";
    self.entity = @"Clients";
    self.sortedAttribute = @"client";
    self.predicate = [NSPredicate predicateWithFormat:@"ANY orders != nil"];
    
    [self setCanEdit:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.delegate = self;
    [super viewWillAppear:animated];
}

@end
