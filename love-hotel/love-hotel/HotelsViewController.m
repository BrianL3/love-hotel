//
//  HotelsViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "HotelsViewController.h"
#import "RoomsViewController.h"

@interface HotelsViewController ()

@property (strong, nonatomic) NSArray* hotels;
@property Hotel* selectedHotel;
@end

@implementation HotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set the tableview's delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // get the Core Data context
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    // do the fetch request for all hotels
    NSFetchRequest* fetchHotels = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
    NSError* fetchError;
    
    NSArray* results = [context executeFetchRequest:fetchHotels error:&fetchError];
    if (!fetchError){
        self.hotels = results;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.hotels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//make the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
    Hotel* hotel = self.hotels[indexPath.row];
    cell.textLabel.text = hotel.name;
    cell.detailTextLabel.text = hotel.address;
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SHOW_ROOM"]) {
        RoomsViewController* destinationVC = segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedHotel = self.hotels[indexPath.row];
        destinationVC.selectedHotel = self.selectedHotel;
    }
}


@end
