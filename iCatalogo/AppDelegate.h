//
//  AppDelegate.h
//  iCatalogo
//
//  Created by Albertomac on 30/09/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (NSURL *)absoluteURLWithFilePath:(NSString *)filePath;
- (NSString *)absolutePathWithFilePath:(NSString *)filePath;

//Ritorna l'istanza di AppDelegate
+ (AppDelegate *)sharedAppDelegate;
//Ritorna un NSMutableArray contenente il risultato della ricerca
- (NSMutableArray *)searchEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate sortedBy:(NSString *)attribute;

- (NSMutableArray *)searchEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate sortedByArray:(NSArray *)attributes;

//Ritorna un NSArray contenente i valori distinti dell'attribute (in SQL equivale: "SELECT DISTINCT attribute FROM entity")
- (NSArray *)searchEntity:(NSString *)entity withDistinctSelectedAttribute:(NSString *)attribute;
//Elimina dal database l'object passato
- (BOOL)deleteObject:(NSManagedObject *)object error:(NSError **)error;
//Elimina dal database gli objects passati
- (BOOL)deleteObjects:(NSArray *)objects error:(NSError **)error;
//Elimina tutti gli oggetti dal database
- (BOOL)deleteDatabase:(NSError **)error;
//Ritorna il totale dell'ordine di un determinato cliente
- (NSString *)getTotalOrderOf:(NSManagedObject *)client;

@end
