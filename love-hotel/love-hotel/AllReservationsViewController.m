//
//  AllReservationsViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/11/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "AllReservationsViewController.h"
#import "HotelService.h"

@interface AllReservationsViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AllReservationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set delegates
    self.tableView.dataSource = self;
    self.fetchedResultsController.delegate = self;
    NSManagedObjectContext *context = [[HotelService sharedService] coreDataStack].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Room"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true];
    //fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDescriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    //perform the fetch
    NSError *fetchError;
    [self.fetchedResultsController performFetch:&fetchError];
    if (fetchError) {
        NSLog(@" %@",fetchError);
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
    
    
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    
    Reservation *reservation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss aaa"];

    NSString* startDateString = [formatter stringFromDate:reservation.startDate];
    NSString *endDateString = [formatter stringFromDate:reservation.endDate];

    cell.textLabel.text = [NSString stringWithFormat:@"Room Number: %@ is reserved by %@ %@",reservation.room.number, reservation.guest.firstName, reservation.guest.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"is reserved from %@ until %@", startDateString, endDateString];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return  [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESERVATION_CELL" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}



@end
