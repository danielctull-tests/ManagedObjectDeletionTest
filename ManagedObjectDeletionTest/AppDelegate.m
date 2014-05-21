//
//  AppDelegate.m
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <DCTCoreDataStack/DCTCoreDataStack.h>
#import "AppDelegate.h"
#import "GroupsViewController.h"

@interface AppDelegate ()
@property (nonatomic) DCTCoreDataStack *coreDataStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.coreDataStack = [[DCTCoreDataStack alloc] initWithStoreFilename:@"test"];

	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	GroupsViewController *groupsViewController = (GroupsViewController *)navigationController.topViewController;
	groupsViewController.managedObjectContext = self.coreDataStack.managedObjectContext;

    return YES;
}

@end
