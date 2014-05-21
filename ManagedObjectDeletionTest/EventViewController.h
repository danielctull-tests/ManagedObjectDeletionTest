//
//  EventViewController.h
//  ManagedObjectDeletionTest
//
//  Created by Daniel Tull on 21.05.2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@import CoreData;
@class Event;

@interface EventViewController : UIViewController
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Event *event;
@end
