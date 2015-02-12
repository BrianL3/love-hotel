//
//  CoreDataStack.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/11/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "CoreDataStack.h"
#import "Room.h"
#import "Hotel.h"

@interface CoreDataStack()

@property (nonatomic) BOOL isTesting;

@end


@implementation CoreDataStack

-(instancetype)init{
    self = [super init];
    if (self){
        [self seedDataBaseIfNeeded];
    }//eo if Self == nil check
    return self;
}//eo init


// init for testing
-(instancetype)initForTesting{
    self = [super init];
    if (self){
        if (self.isTesting){
            [self seedDataBaseIfNeeded];
        }//eo If Testing check
    }//eo if Self == nil check
    return self;
}//eo init for testing


-(void) seedDataBaseIfNeeded{
    // create an NSFetchRequest (retrieves from Core Data)
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
    NSError* error;
    
    // check the number of results from a fetch-all query.
    NSInteger results = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    //if no records are in the database, populate the database with some info
    if (results == 0){
        //NSLog(@"Retrieved no results from Core Data.");
        // make local URL for the json seed data
        NSURL* seedURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
        // grab json blob
        NSData* seedData = [[NSData alloc] initWithContentsOfURL:seedURL];
        //serial the JSON blob
        NSError* jsonError;
        NSDictionary* rootDictionary = [NSJSONSerialization JSONObjectWithData:seedData options:0 error:&jsonError];
        if (!jsonError){
            NSArray* hotelArray = rootDictionary[@"Hotels"];
            for (NSDictionary* hotelDictionary in hotelArray){
                Hotel* hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
                hotel.name = hotelDictionary[@"name"];
                hotel.address = hotelDictionary[@"location"];
                hotel.stars = hotelDictionary[@"stars"];
                NSArray* roomArray = hotelDictionary[@"rooms"];
                for (NSDictionary* roomDictionary in roomArray){
                    Room* room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
                    room.number = roomDictionary[@"number"];
                    room.beds = roomDictionary[@"beds"];
                    room.rate = roomDictionary[@"rate"];
                    room.hotel = hotel;
                }
            }
        }
        NSError* saveError;
        [self.managedObjectContext save:&saveError];
        if (saveError){
            NSLog(@"something is screwwed up.");
            NSLog(@"%@", saveError.localizedDescription);
        }
    }
    
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ledbetter.brian.love_hotel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"love_hotel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"love_hotel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end

