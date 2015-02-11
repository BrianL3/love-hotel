//
//  ReservationPickerViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/10/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "ReservationPickerViewController.h"
#import "Guest.h"

@interface ReservationPickerViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *stayLengthPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (strong, nonatomic) NSDate* startDate;

@end

@implementation ReservationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roomNumberLabel.text = [NSString stringWithFormat:@"Make Your Reservation for Room %@", self.room.number];
    
    //set delegate
    self.stayLengthPicker.delegate = self;
    self.stayLengthPicker.dataSource = self;
    
    //no reserving shit in the past
    self.startDatePicker.minimumDate = [[NSDate alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: RESERVE BUTTON PRESSED                 =============================================
- (IBAction)reservationButtonPressed:(id)sender {
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = [self.stayLengthPicker selectedRowInComponent:0] + 1;
    
    self.startDate = self.startDatePicker.date;

    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDate* endDate = [calender dateByAddingComponents:components toDate:self.startDate options:0];
    
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.room.managedObjectContext];
    reservation.startDate = self.startDate;
    reservation.endDate = endDate;
    reservation.room = self.room;
    
    //TODO: Replace this fake guest with a real guest
    Guest* guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.room.managedObjectContext];
    guest.firstName = @"Candy";
    guest.lastName = @"McStripperson";
    reservation.guest = guest;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss aaa"];
    NSString* startDateString = [formatter stringFromDate:self.startDate];
    NSString *endDateString = [formatter stringFromDate:endDate];
    
    NSLog(@"A reservation was generated for Room Number %@ starting at %@ and ending at %@", [NSString stringWithFormat:@"%@", self.room.number], startDateString, endDateString);
    
    //save
    NSError* saveError;
    [self.room.managedObjectContext save:&saveError];
    
    if (saveError){
        NSLog(@"Error occured in saving reservation: %@", saveError.localizedDescription);
    }
}

//MARK: PICKERVIEW DELEGATE AND DATASOURCE METHODS  =========================================

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
