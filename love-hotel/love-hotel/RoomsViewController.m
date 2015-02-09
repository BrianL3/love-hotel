//
//  RoomsViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "RoomsViewController.h"
#import "Room.h"

@interface RoomsViewController ()

@property (strong, nonatomic) NSArray* rooms;

@end

@implementation RoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.rooms = self.selectedHotel.room.allObjects;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.selectedHotel.room.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];
    Room* room = self.rooms[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", room.number];


    return cell;
}

@end
