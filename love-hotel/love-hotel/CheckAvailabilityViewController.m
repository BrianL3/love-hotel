//
//  CheckAvailabilityViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/10/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "CheckAvailabilityViewController.h"
#import "HotelService.h"
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
    
    //set our context via the HotelService singleton
    self.context = [[HotelService sharedService] coreDataStack].managedObjectContext;
    
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
    
    // set our hotel
    NSString *selectedHotel = [self.hotelPicker titleForSegmentAtIndex: self.hotelPicker.selectedSegmentIndex];
    
    // inquire with hotelservice about room availability
    NSArray* availableRooms = [[HotelService sharedService] availableRoomsForHotel:selectedHotel withStartDate:self.startDate withEndDate:endDate];
   // [[HotelService sharedService] bookReservationForGuest:guest ForRoom:self.room startDate:self.startDate endDate:endDate];
    NSLog(@"CheckAvailableVC reports that the number of available rooms in %@ is : %lu", selectedHotel, (unsigned long)availableRooms.count);


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
