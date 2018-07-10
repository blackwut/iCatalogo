//
//  TableViewController.h
//  iCatalogo
//
//  Created by Albertomac on 06/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@protocol TableViewDelegate <NSObject>

@required

- (void)configureView;

//Metodo necessario per configurare le celle nella tabella
- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;

@optional
//Metodo facoltativo per modificare la cancellazione di un record dalla lista
- (void)deleteObjectWithIndexPath:(NSIndexPath *)index;

//Metodo facoltativo per la ricerca nella tabella
- (void)searchList;

@end


@interface TableViewController : UITableViewController <UISearchBarDelegate>

//Delegato della classe
@property (weak) id <TableViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISearchBar *search;

@property (strong, nonatomic) NSString *entity;

@property (strong, nonatomic) NSString *sortedAttribute;

//Predicate da usare per la ricerca nelle tabelle
@property (strong, nonatomic) NSPredicate *predicate;

//Dataset ricavato dal database
@property (strong, nonatomic) NSMutableArray *list;

//Se YES permette di cancellare le righe della tabella
@property BOOL canEdit;

//Se YES permette di colorare la tabella alternando azzurro al bianco
@property BOOL coloredTable;


- (void)loadList;

@end



