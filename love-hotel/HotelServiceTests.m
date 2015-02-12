//
//  HotelServiceTests.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/11/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"


@interface HotelServiceTests : XCTestCase
@property (strong,nonatomic) HotelService *hotelService;
@property (strong,nonatomic) Room *room;
@property (strong,nonatomic) Guest *guest;
@property (strong,nonatomic) Hotel *hotel;

@end

@implementation HotelServiceTests

- (void)setUp {
    [super setUp];
    
    self.hotelService = [[HotelService alloc] initForTesting];
    self.hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
    self.hotel.name = @"TestHotel";
    self.hotel.address = @"FakeHotelLocation";
    self.hotel.stars = @1;
    
    self.room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
    self.room.number = @101;
    self.room.rate = @1;
    self.room.hotel = self.hotel;
    self.room.beds = @2;
    
    self.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
    self.guest.firstName = @"TestFirstName";
    self.guest.lastName = @"TestLastName";

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    // It should nil out all the test objects we made above
    self.hotelService = nil;
    self.hotel = nil;
    self.guest = nil;
    self.room = nil;

    [super tearDown];
}

- (void)testBookReservation {
    NSDate *startDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 2;
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    
    Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room startDate:startDate endDate:endDate];
    XCTAssertNotNil(reservation,@"UI prevents user from putting in start dates that occur after end dates but w/e");
}

-(void)testCheckAvailability{
    NSDate *startDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 2;
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];

    NSArray* availableRooms = [self.hotelService availableRoomsForHotel:self.hotel.name withStartDate:startDate withEndDate:endDate];
    
    XCTAssertEqual(availableRooms.count, 1);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
