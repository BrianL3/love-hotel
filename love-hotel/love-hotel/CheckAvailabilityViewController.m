//
//  CheckAvailabilityViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/10/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "CheckAvailabilityViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"

@interface CheckAvailabilityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *stayLengthPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hotelPicker;
@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSManagedObjectContext* context;

@end

@implementation CheckAvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set delegate
    self.stayLengthPicker.delegate = self;
    self.stayLengthPicker.dataSource = self;
    
    //no reserving shit in the past
    self.startDatePicker.minimumDate = [[NSDate alloc] init];
    
    //set our context
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkAvailabilityButtonPressed:(id)sender {
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = [self.stayLengthPicker selectedRowInComponent:0] + 1;
    
    self.startDate = self.startDatePicker.date;
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDate* endDate = [calender dateByAddingComponents:components toDate:self.startDate options:0];
    
    // get the rooms
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
    // set our hotel
    NSString *selectedHotel = [self.hotelPicker titleForSegmentAtIndex: self.hotelPicker.selectedSegmentIndex];
    /*
     Create a Predicate to do the following:
        -Fetch all rooms from the selected hotel WHERE
            -the room does NOT have any reservations WHERE:
                -a start date that falls between the user-selected start date and end dates AND
                -an end date that falls between the user-selected start date and end date
    */
    // get the matching hotel
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@", selectedHotel];
    fetchRequest.predicate = predicate;
    // get the reservations
    NSFetchRequest* reservationFetch = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    //set a filter that says we want only reservations for this hotel with startDates
    NSPredicate* reservationPredicate = [NSPredicate predicateWithFormat:@"room.hotel.name MATCHES %@ AND (startDate >= %@ AND startDate <= %@) OR (endDate <= %@ AND endDate >= %@)", selectedHotel, self.startDate, endDate, endDate, self.startDate];
    reservationFetch.predicate = reservationPredicate;
    
    //fire off the fetch
    NSError* fetchError;
    // this returns all reservations that are bad and interfere with our current attempted reservation
    NSArray* results = [self.context executeFetchRequest:reservationFetch error:&fetchError];
    if (fetchError){
        NSLog(@"Error occured in saving reservation: %@", fetchError.localizedDescription);
    }
    
    NSMutableArray* rooms = [NSMutableArray new];
    
    // scan through the "bad" reservations and grab their rooms
    for (Reservation* reservation in results) {
        [rooms addObject: reservation];
    }
    
    //create a fetch request to grab the rooms that are not on the rooms list
    NSPredicate *roomsPredicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@ AND NOT (self in %@)", selectedHotel, rooms];
    NSFetchRequest *roomsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    roomsFetch.predicate = roomsPredicate;
    
    //execute the fetch
    NSError* roomsError;
    NSArray* finalResults = [self.context executeFetchRequest:roomsFetch error:&roomsError];
    // this returns all reservations that are bad and interfere with our current attempted reservation
    if (fetchError){
        NSLog(@"Error occured in saving reservation: %@", roomsError.localizedDescription);
    }
   // NSLog(@"The number of available rooms in %@ is : %lu",selectedHotel, (unsigned long)finalResults.count);

    
    /*
    //uniqueify the result set
    NSSet* uniqueResults = [NSMutableSet new];
    [uniqueResults setByAddingObjectsFromArray:results];
    
    NSArray* rooms = uniqueResults.allObjects;
    */
    //NSLog(@"The number of available rooms in %@ is : %lu",selectedHotel, (unsigned long)rooms.count);
}

//MARK: PICKERVIEW DELEGATE AND DATASOURCE METHODS

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger dayCount = row + 1;
    return [NSString stringWithFormat:@"%lu days", dayCount];
}

@end
