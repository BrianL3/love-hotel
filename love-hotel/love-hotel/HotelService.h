//
//  HotelService.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/11/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Reservation.h"
#import "Room.h"
#import "Guest.h"


@interface HotelService : NSObject

@property (strong,nonatomic) CoreDataStack *coreDataStack;

+(id)sharedService;
-(instancetype)initForTesting;

-(Reservation *)bookReservationForGuest:(Guest *)guest ForRoom:(Room *)room startDate:(NSDate*)startDate endDate:(NSDate *)endDate;
-(NSArray*)availableRoomsForHotel:(NSString *)hotel withStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate;

@end
