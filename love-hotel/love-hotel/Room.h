//
//  Room.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Reservation;
@class Hotel;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * beds;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) Hotel *hotel;
@property (nonatomic, retain) NSSet *reservation;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addReservationObject:(Reservation *)value;
- (void)removeReservationObject:(Reservation *)value;
- (void)addReservation:(NSSet *)values;
- (void)removeReservation:(NSSet *)values;

@end
