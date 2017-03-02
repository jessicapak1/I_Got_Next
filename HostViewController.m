//
//  HostViewController.m
//  FinalProject
//
//  Created by Jessica Pak on 4/29/16.
//  Copyright © 2016 Jessica Pak. All rights reserved.
//

#import "HostViewController.h"
#import "ProfileViewController.h"
#import "JoinTableViewController.h"
#import "GameModel.h"
#import <Parse/Parse.h>

@interface HostViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *placePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSArray *pickerData;
@property NSDate *selectedDate;
@property (strong, nonatomic) NSString *chosenSport;
@property (strong, nonatomic) NSString *chosenDate;

@property (strong, nonatomic) NSString *chosenPeople;
@property (weak, nonatomic) IBOutlet UILabel *stepperLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) GameModel *model;
@property (strong, nonatomic) JoinTableViewController *join;


@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [GameModel sharedModel];
       // Initialize Data
     _pickerData = @[@"baseball", @"soccer", @"basketball", @"football", @"tennis"];
    _stepperLabel.text = @"0";
    // Connect data
//    self.placePicker.dataSource = _pickerData;
    self.placePicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    return [_pickerData objectAtIndex: row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    _chosenSport = [_pickerData objectAtIndex:row];
}

- (IBAction)datePickerValueChanged:(id)sender {
    _selectedDate = [sender date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyy HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate: _selectedDate];
    
    _chosenDate = stringFromDate;
}

- (IBAction)stepper:(id)sender {
    UIStepper *mStepper = (UIStepper *) sender;
    int num = [mStepper value];
    
    NSString *str = [NSString stringWithFormat:@"%d", num];
    _chosenPeople = str;
    
    self.stepperLabel.text = str;
}

- (IBAction)hostButtonClicked:(id)sender {
    NSLog(@"chosen venue %@", _chosenVenue);
    
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    if(_chosenSport == NULL || _chosenDate == NULL || _chosenVenue == NULL || _chosenPeople == NULL) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error!"
                                              message:@"Not all fields have been completed."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        game[@"Sport"] = _chosenSport;
        game[@"Venue"] = _chosenVenue;
        game[@"Date"] = _chosenDate;
        game[@"People"] = _chosenPeople;
        [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                // error could not sign in, display error message
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Success!"
                                                      message:@"Congratulations, your game has been hosted!"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                [self.model clearAllGames];
                [self.model reloadDataFromDatabase];
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"profile"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion:NULL];

            } else {
                // There was a problem, check error.description
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                      message:error.description
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];

    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProfileViewController *vc = [segue destinationViewController];
 
    
}


@end
