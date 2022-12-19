//
//  AppDelegate.m
//  iCatalogo
//
//  Created by Albertomac on 30/09/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSString * notFoundPath = [documentsURL URLByAppendingPathComponent:@"imageNotFound.png"].path;
    
    if (![fileManager fileExistsAtPath:notFoundPath]) {
        NSString * resourcePath = [[NSBundle mainBundle].resourceURL URLByAppendingPathComponent:@"imageNotFound.png"].path;
        [fileManager copyItemAtPath:resourcePath toPath:notFoundPath error:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if (managedObjectContext.hasChanges && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iCatalogo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iCatalogo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
//        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

+ (NSURL *)absoluteURLWithFilePath:(NSString *)filePath;
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    return [documentsURL URLByAppendingPathComponent:filePath];
}

- (NSString *)absolutePathWithFilePath:(NSString *)filePath;
{
    return [AppDelegate absoluteURLWithFilePath:filePath].path;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSMutableArray *)searchEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate sortedBy:(NSString *)attribute
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    
    fetchRequest.entity = entityDescription;
    
    if(predicate != nil)
        fetchRequest.predicate = predicate;
    
    if(attribute != nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
    }
    
    return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];
}

- (NSMutableArray *)searchEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate sortedByArray:(NSArray *)attributes
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    
    fetchRequest.entity = entityDescription;
    
    if(predicate != nil)
        fetchRequest.predicate = predicate;
    
    if(attributes.count > 0){
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
        
        for(NSString *attribute in attributes){
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
            [sortDescriptors addObject:descriptor];
        }
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    
    return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];
}

- (NSArray *)searchEntity:(NSString *)entity withDistinctSelectedAttribute:(NSString *)attribute
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    
    fetchRequest.entity = entityDescription;
	fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = @[entityDescription.propertiesByName[attribute]];
    [fetchRequest setReturnsDistinctResults:YES];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
	fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

- (BOOL)deleteObject:(NSManagedObject *)object error:(NSError **)error
{
    __block NSError *_error = nil;
    __block BOOL isError = false;
    NSManagedObjectContext *context = self.managedObjectContext;
    [context performBlockAndWait:^{
        [context deleteObject:object];
        isError = [context save:&_error];
    }];
        
    *error = _error;
    return isError;
}

- (BOOL)deleteObjects:(NSArray *)objects error:(NSError **)error
{
    __block NSError *_error = nil;
    __block BOOL isError = false;
    NSManagedObjectContext *context = self.managedObjectContext;
    [context performBlockAndWait:^{
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        isError = [context save:&_error];
    }];
    
    *error = _error;
    return isError;
}

- (BOOL)deleteDatabase:(NSError **)error
{
    NSManagedObjectContext *context = self.managedObjectContext;
    __block NSError *_error = nil;
    __block BOOL isError = false;
    [context performBlockAndWait:^{
        NSArray *entities = [_managedObjectModel.entities valueForKey:@"name"];
        for(NSString *entity in entities){
            NSArray *list = [self searchEntity:entity withPredicate:nil sortedBy:nil];
                    
            for(NSManagedObject *object in list)
                [context deleteObject:object];
        }

        isError = [context save:&_error];
    }];
    
    *error = _error;
    return isError;
}



//- (BOOL)deleteObject:(NSManagedObject *)object error:(NSError **)error
//{
//    NSManagedObjectContext *context = self.managedObjectContext;
//    [context lock];
//
//    //Cancella l'oggetto dal database
//    [context deleteObject:object];
//
//    //Salva i cambiamenti
//    BOOL isError = [context save:error];
//    [context unlock];
//    return isError;
//}

//- (BOOL)deleteObjects:(NSArray *)objects error:(NSError **)error
//{
//     NSManagedObjectContext *context = self.managedObjectContext;
//    [context lock];
//
//    //Cancella gli objects dal database
//    for(NSManagedObject *object in objects)
//        [context deleteObject:object];
//
//    //Salva i cambiamenti
//    BOOL isError = [context save:error];
//    [context unlock];
//    return isError;
//}


//- (BOOL)deleteDatabase:(NSError **)error
//{
//    NSManagedObjectContext *context = self.managedObjectContext;
//    [context lock];
//
//    //Trova le entities del database
//	NSArray *entities = [_managedObjectModel.entities valueForKey:@"name"];
//
//	for(NSString *entity in entities){
//        //Trova gli oggetti della entity
//        NSArray *list = [self searchEntity:entity withPredicate:nil sortedBy:nil];
//
//        //Cancella gli oggetti della entity dal database
//        for(NSManagedObject *object in list)
//            [context deleteObject:object];
//    }
//
//    //Salva i cambiamenti
//    BOOL isError = [context save:error];
//    [context unlock];
//    return isError;
//}

- (NSString *)getTotalOrderOf:(NSManagedObject *)client
{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.decimalSeparator = @",";
    
    float total = 0.0f;
    const NSArray *orders = [[client valueForKey:@"orders"] allObjects];
 
    for(NSManagedObject *order in orders){
        
        NSManagedObject *subproduct = [order valueForKey:@"subproduct"];
        
        //Informazioni su subproduct
        const float price = [numberFormatter numberFromString:[subproduct valueForKey:@"price"]].floatValue;
        const int quantityPackage = [[subproduct valueForKey:@"quantityPackage"] intValue];
        const int quantityCartoon = [[subproduct valueForKey:@"quantityCartoon"] intValue];
        //int quantityColor = [[subproduct valueForKey:@"quantityColor"] intValue];
        
        //Informazioni sull'order
        const int quantity = [[order valueForKey:@"quantity"] intValue];
        const int xSubproduct = [[order valueForKey:@"xSubproduct"] intValue];
        const int xType = [[order valueForKey:@"xType"] intValue];
        //int xColor = [[order valueForKey:@"xColor"] intValue];
        const int xPackage = [[order valueForKey:@"xPackage"] intValue];
        const int xCartoon = [[order valueForKey:@"xCartoon"] intValue];
        
        //quantità * prezzo
        total += quantity * price;
        total += xPackage * quantityPackage * price;
        total += xCartoon * quantityCartoon * price;
        //total += xColor * quantityColor * price;

        NSArray *subproducts = [[[subproduct valueForKey:@"product"] valueForKey:@"subproducts"] allObjects];
        for(NSManagedObject *sub in subproducts){
            total += xSubproduct * [[sub valueForKey:@"price"] floatValue];
            total += xType * [[sub valueForKey:@"price"] floatValue];
        }
    }
    
    return [NSString stringWithFormat:@"€ %.2f", total];
}

@end
