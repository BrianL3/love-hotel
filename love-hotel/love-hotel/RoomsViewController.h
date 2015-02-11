//
//  RoomsViewController.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel.h"
#import "ReservationPickerViewController.h"

@interface RoomsViewController : UITableViewController <UITableViewDataSource>
@property (strong, nonatomic) Hotel* selectedHotel;
@end
