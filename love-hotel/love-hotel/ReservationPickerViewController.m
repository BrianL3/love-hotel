//
//  ReservationPickerViewController.m
//  love-hotel
//
//  Created by Brian Ledbetter on 2/10/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "ReservationPickerViewController.h"
#import "Guest.h"
#import "HotelService.h"
#import "Hotel.h"


@interface ReservationPickerViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *stayLengthPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (strong, nonatomic) NSDate* startDate;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

@end

@implementation ReservationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roomNumberLabel.text = [NSString stringWithFormat:@"Make Your Reservation for Room %@", self.room.number];
    
    //set delegate
    self.stayLengthPicker.delegate = self;
    self.stayLengthPicker.dataSource = self;
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    
    //no reserving shit in the past
    self.startDatePicker.minimumDate = [[NSDate alloc] init];
    //no reserving shit without a guest
    self.reservationButton.enabled = false;
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
    
    //Creates a guest with names from the text fields
    Guest* guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.room.managedObjectContext];
    guest.firstName = self.firstNameTextField.text;
    guest.lastName = self.lastNameTextField.text;

    //ask HotelService to create and save the reservation
    
    // inquire with hotelservice about room availability
    NSArray* availableRooms = [[HotelService sharedService] availableRoomsForHotel:[self.room.hotel name] withStartDate:self.startDate withEndDate:endDate];
    BOOL canMakeReservation = true;
    NSLog([NSString stringWithFormat:@"The number of available rooms at %@ is %lu", [self.room.hotel name], (unsigned long) availableRooms.count]);
    for (Room* room in availableRooms){
        NSLog([NSString stringWithFormat:@"%@ is reported as available", room.number]);
        if  (room == self.room){
            canMakeReservation = false;
        }
    }
    if (canMakeReservation){
        [[HotelService sharedService] bookReservationForGuest:guest ForRoom:self.room startDate:self.startDate endDate:endDate];
    }
}//eo reservationButtonPressed func

//MARK: TEXTFIELD DELEGATE

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* oldText = textField.text;
    NSString* newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    self.reservationButton.enabled = (newText.length > 0 );
    
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
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
