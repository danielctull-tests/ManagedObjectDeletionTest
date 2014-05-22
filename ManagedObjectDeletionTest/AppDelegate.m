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

	// Make a group
	Group *group = [Group insertInManagedObjectContext:managedObjectContext];
	group.name = @"Test";

	Event *event = [Event insertInManagedObjectContext:managedObjectContext];
	event.date = [NSDate new];
	event.group = group;

	BOOL didSave = [managedObjectContext save:&error];
	NSAssert(didSave, @"Received error: %@", error);

	[managedObjectContext deleteObject:group];

	BOOL didSave2 = [managedObjectContext save:&error];
	NSAssert(didSave2, @"Received error: %@", error);

	NSLog(@"group: %@", group);
	NSLog(@"event: %@", event);

	// Try to access properties
	NSLog(@"group.name: %@", group.name);
	NSLog(@"group.events: %@", group.events);
	NSLog(@"event.date: %@", event.date);
	NSLog(@"event.group: %@", event.group);

	return YES;
}

- (void)merge:(NSNotification *)notification {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	[managedObjectContext performBlock:^{
		[managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

@end
