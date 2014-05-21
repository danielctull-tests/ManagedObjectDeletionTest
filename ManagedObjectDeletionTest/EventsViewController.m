//
//  EventsViewController.m
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <DCTDataSource/DCTDataSource.h>
#import "EventsViewController.h"
#import "Event.h"
#import "EventViewController.h"
#import "Group.h"

@interface EventsViewController ()
@property (nonatomic) DCTTableViewDataSource *tableViewDataSource;
@end

@implementation EventsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	id viewController = segue.destinationViewController;

	NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
	Event *event = [self.tableViewDataSource objectAtIndexPath:indexPath];

	if ([viewController isKindOfClass:[EventViewController class]]) {
		EventViewController *eventViewController = viewController;
		eventViewController.event = event;
		eventViewController.managedObjectContext = self.managedObjectContext;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = self.group.name;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	NSFetchRequest *fetchRequest =[[NSFetchRequest alloc] initWithEntityName:[Event entityName]];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:EventAttributes.date ascending:YES]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", EventRelationships.group, self.group];

	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		  managedObjectContext:self.group.managedObjectContext
																			sectionNameKeyPath:nil
																					 cacheName:nil];

	DCTFetchedResultsDataSource *dataSource = [[DCTFetchedResultsDataSource alloc] initWithFetchedResultsController:frc];

	self.tableViewDataSource = [[DCTTableViewDataSource alloc] initWithTableView:self.tableView dataSource:dataSource];
	self.tableViewDataSource.cellReuseIdentifier = @"cell";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	Event *event = [self.tableViewDataSource objectAtIndexPath:indexPath];
	cell.textLabel.text = [event.date description];
}

- (IBAction)addEvent:(id)sender {
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	Event *event = [Event insertInManagedObjectContext:managedObjectContext];
	event.date = [NSDate new];
	event.group = self.group;
	[managedObjectContext save:NULL];
}

@end
