//
//  HotelService.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/11/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "HotelService.h"

@implementation HotelService

// this method creates a singleton
+(id)sharedService {
    static HotelService *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mySharedService = [[self alloc] init];
    });
    return mySharedService;
}//eo sharedService func

// standard init
-(instancetype)init {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] init];
    }
    return self;
}

// testing init
-(instancetype)initForTesting {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] initForTesting];
    }
    return self;
}

// this method books a reservation for a single guest
-(Reservation *)bookReservationForGuest:(Guest *)guest ForRoom:(Room *)room startDate:(NSDate*)startDate endDate:(NSDate *)endDate {
    //create the reservation
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    reservation.startDate = startDate;
    reservation.endDate = endDate;
    reservation.room = room;
    reservation.guest = guest;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss aaa"];
    NSString* startDateString = [formatter stringFromDate:startDate];
    NSString *endDateString = [formatter stringFromDate:endDate];
    
    NSLog(@"HotelService generated a reservation for Room Number %@ starting at %@ and ending at %@", [NSString stringWithFormat:@"%@", room.number], startDateString, endDateString);

    //save the reservation from scratchpad to DB
    NSError *saveError;
    [self.coreDataStack.managedObjectContext save:&saveError];
    if (!saveError) {
        return reservation;
    } else {
        return nil;
    }
}//eo bookReservationForGuest func

-(NSArray*)availableRoomsForHotel:(NSString *)hotel withStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate {
    /*
     Create a Predicate to do the following:
     -Fetch all rooms from the selected hotel WHERE
     -the room does NOT have any reservations WHERE:
     -a start date that falls between the user-selected start date and end dates AND
     -an end date that falls between the user-selected start date and end date
     */
    // get the rooms
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];

    // get the matching hotel
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@", hotel];
    fetchRequest.predicate = predicate;
    // get the reservations
    NSFetchRequest* reservationFetch = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    //set a filter that says we want only reservations for this hotel with startDates
    NSPredicate* reservationPredicate = [NSPredicate predicateWithFormat:@"room.hotel.name MATCHES %@ AND (startDate >= %@ AND startDate <= %@) OR (endDate <= %@ AND endDate >= %@)", hotel, startDate, endDate, endDate, startDate];
    reservationFetch.predicate = reservationPredicate;
    
    //context
    NSManagedObjectContext* context = [[HotelService sharedService] coreDataStack].managedObjectContext;

    
    //fire off the fetch
    NSError* fetchError;
    // this returns all reservations that are bad and interfere with our current attempted reservation
    NSArray* results = [context executeFetchRequest:reservationFetch error:&fetchError];
    if (fetchError){
        NSLog(@"Error occured in saving reservation: %@", fetchError.localizedDescription);
    }
    
    NSMutableArray* rooms = [NSMutableArray new];
    
    // scan through the "bad" reservations and grab their rooms
    for (Reservation* reservation in results) {
        [rooms addObject: reservation];
    }
    
    //create a fetch request to grab the rooms that are not on the rooms list
    NSPredicate *roomsPredicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@ AND NOT (self in %@)", hotel, rooms];
    NSFetchRequest *roomsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    roomsFetch.predicate = roomsPredicate;
    
    //execute the fetch
    NSError* roomsError;
    NSArray* finalResults = [context executeFetchRequest:roomsFetch error:&roomsError];
    // this returns all reservations that are bad and interfere with our current attempted reservation
    if (fetchError){
        NSLog(@"Error occured in saving reservation: %@", roomsError.localizedDescription);
    }
    NSLog(@"HotelService reports that the number of available rooms in %@ is : %lu", hotel, (unsigned long)finalResults.count);
    return finalResults;
}


@end
