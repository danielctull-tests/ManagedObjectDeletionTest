//
//  GroupsViewController.m
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <DCTDataSource/DCTDataSource.h>
#import "GroupsViewController.h"
#import "Group.h"
#import "EventsViewController.h"

@interface GroupsViewController ()
@property (nonatomic) DCTTableViewDataSource *tableViewDataSource;
@end

@implementation GroupsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	id viewController = segue.destinationViewController;

	NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
	Group *group = [self.tableViewDataSource objectAtIndexPath:indexPath];

	if ([viewController isKindOfClass:[EventsViewController class]]) {
		EventsViewController *eventsViewController = viewController;
		eventsViewController.group = group;
		eventsViewController.managedObjectContext = self.managedObjectContext;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	return;
	NSFetchRequest *fetchRequest =[[NSFetchRequest alloc] initWithEntityName:[Group entityName]];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:GroupAttributes.name ascending:YES]];

	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		  managedObjectContext:self.managedObjectContext
																			sectionNameKeyPath:nil
																					 cacheName:nil];

	DCTFetchedResultsDataSource *dataSource = [[DCTFetchedResultsDataSource alloc] initWithFetchedResultsController:frc];

	self.tableViewDataSource = [[DCTTableViewDataSource alloc] initWithTableView:self.tableView dataSource:dataSource];
	self.tableViewDataSource.cellReuseIdentifier = @"cell";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	Group *group = [self.tableViewDataSource objectAtIndexPath:indexPath];
	cell.textLabel.text = group.name;
}

- (IBAction)addGroup:(id)sender {

	NSInteger lastNameIndex = 0;
	NSInteger numberOfItems = [self.tableViewDataSource numberOfItemsInSection:0];
	if (numberOfItems > 0) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:numberOfItems-1 inSection:0];
		Group *lastGroup = [self.tableViewDataSource objectAtIndexPath:indexPath];
		lastNameIndex = [lastGroup.name integerValue];
	}

	Group *group = [Group insertInManagedObjectContext:self.managedObjectContext];
	group.name = [@(lastNameIndex+1) description];
	[self.managedObjectContext save:NULL];
}

@end
