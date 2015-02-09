//
//  Reservation.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;
@class Guest;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) Guest *guest;

@end
