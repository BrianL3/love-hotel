//
//  ReservationPickerViewController.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/10/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "Reservation.h"

@interface ReservationPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong,nonatomic) Room *room;
@end
