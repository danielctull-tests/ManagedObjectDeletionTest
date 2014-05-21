//
//  EventViewController.m
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import "Group.h"

@interface EventViewController ()
@property (nonatomic, weak) IBOutlet UILabel *timestampLabel;
@end

@implementation EventViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.timestampLabel.text = [self.event.date description];
}

- (IBAction)deleteEvent:(id)sender {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	[managedObjectContext deleteObject:self.event];
	[managedObjectContext save:NULL];
}

- (IBAction)deleteGroup:(id)sender {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	Group *group = self.event.group;
	[managedObjectContext deleteObject:group];
	[managedObjectContext save:NULL];
}

@end
