//
//  Hotel.h
//  love-hotel
//
//  Created by Brian Ledbetter on 2/9/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;

@interface Hotel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stars;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *room;
@end

@interface Hotel (CoreDataGeneratedAccessors)

- (void)addRoomObject:(Room *)value;
- (void)removeRoomObject:(Room *)value;
- (void)addRoom:(NSSet *)values;
- (void)removeRoom:(NSSet *)values;

@end
