//
//  AppDelegate.m
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import "Group.h"
#import "Event.h"

@interface AppDelegate ()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

	NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [documentsURL URLByAppendingPathComponent:[[NSUUID UUID] UUIDString]];

	NSError *error;
	NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																		configuration:nil
																				  URL:storeURL
																			  options:nil
																				error:&error];
	NSAssert(store, @"Received error: %@", error);

	NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

	self.managedObjectContext = managedObjectContext;

    // Make a group
    Group *group = [Group insertInManagedObjectContext:managedObjectContext];
    group.name = @"Test";

	Event *event = [Event insertInManagedObjectContext:managedObjectContext];
	event.date = [NSDate new];
	event.group = group;

    [managedObjectContext obtainPermanentIDsForObjects:@[group, event] error:NULL];

    GroupID *groupID = group.objectID;

	BOOL didSave = [managedObjectContext save:&error];
	NSAssert(didSave, @"Received error: %@", error);

    // Turn the group into a fault
	[managedObjectContext reset];

    // Delete the group on different context
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator;

	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(merge:) name:NSManagedObjectContextDidSaveNotification object:backgroundContext];


    [backgroundContext performBlock:^{

        NSError *error;
        NSManagedObject *groupToDelete = [backgroundContext existingObjectWithID:groupID error:&error];
		NSAssert(groupToDelete, @"Received error: %@", error);

		[backgroundContext deleteObject:groupToDelete];

		BOOL didSave = [backgroundContext save:&error];
		NSAssert(didSave, @"Received error: %@", error);

		[managedObjectContext performBlock:^{

			NSLog(@"%@", group);
			NSLog(@"%@", event);

			// Try to access properties
			NSLog(@"%@", event.date);
			NSLog(@"%@", event.group);
		}];
    }];

    return YES;
}

- (void)merge:(NSNotification *)notification {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	[managedObjectContext performBlock:^{
		[managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

@end
