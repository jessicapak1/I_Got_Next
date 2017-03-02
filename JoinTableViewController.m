//
//  JoinTableViewController.m
//  FinalProject
//
//  Created by Jessica Pak on 4/29/16.
//  Copyright © 2016 Jessica Pak. All rights reserved.
//

#import "JoinTableViewController.h"
#import <Parse/Parse.h>
#import "GameModel.h"
#import "TableViewCell.h"

@interface JoinTableViewController ()
@property (strong, nonatomic) GameModel *model;
@property NSString *input;
@property NSDictionary *game;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger currentIndex;

@end

@implementation JoinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [GameModel sharedModel];
//    [self.model clearAllGames];
//    [self.model reloadDataFromDatabase];
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    // Returns the number of sections
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Returns the number of rows in the section
    return [self.model numberOfGames];
}

- (UITableViewCell*) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"tableCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *game = [self.model gameAtIndex:indexPath.row];
    [cell  setViewCell:game];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Do whatever you like with indexpath.row
    _game = [self.model gameAtIndex:indexPath.row];
    _currentIndex = indexPath.row;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Input"
                                          message:@"How many people would like to join?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = NSLocalizedString(@"Number of People", @"Login");
//         [textField addTarget:self
//                       action:@selector(alertFunction)
//             forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *login = alertController.textFields.firstObject;
                                   self.input = login.text;
                                   if(_game[kPeopleKey] == _input) {
                                       // delete
                                       PFObject *object = [PFObject objectWithoutDataWithClassName:@"Game"
                                                                                          objectId:_game[kObjectKey]];
                                       [object deleteEventually];
                                       [self.model removeGameAtIndex:_currentIndex];
                                       
                                       [self.tableView reloadData];
                                   } else {
                                       PFQuery *query = [PFQuery queryWithClassName:@"Game"];
                                       // Retrieve the object by id
                                       NSString *num = _game[kPeopleKey];
                                       
                                       NSInteger peopleNum = [num integerValue];
                                       
                                       NSInteger inputNum = [_input integerValue];
                                    
                                       peopleNum = peopleNum - inputNum;
                                       NSString *newPeople = [NSString stringWithFormat:@"%li", (long)peopleNum];
                                       
                                       [query getObjectInBackgroundWithId:_game[kObjectKey]
                                                                    block:^(PFObject *game, NSError *error) {
                                                                        game[@"People"] = newPeople;
                                                                        [game saveInBackground];
                                                                    }];
                                       
                                       NSDictionary *newGame = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                _game[kSportKey], kSportKey,
                                                                _game[kTimeKey], kTimeKey,
                                                                _game[kVenueKey], kVenueKey,
                                                                newPeople, kPeopleKey,
                                                                _game[kObjectKey], kObjectKey, nil];
                                       
                                       [self.model removeGameAtIndex:_currentIndex];
                                       [self.model insertGame:newGame atIndex:_currentIndex];
                                       
                                       [self.tableView reloadData];
                                   }

                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete from the model
        [self.model removeGameAtIndex:indexPath.row];
        
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

//- (void) alertFunction {
//    if(_game[kPeopleKey] == _input) {
//        NSLog(@"DELETE");
//        // delete
//        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Game"
//                                                           objectId:_game[kObjectKey]];
//        [object deleteEventually];
//        [self.model removeGameAtIndex:_currentIndex];
//    } else {
//        NSLog(@"UPDATE");
//        PFQuery *query = [PFQuery queryWithClassName:@"Game"];
//        // Retrieve the object by id
//        NSString *num = _game[kPeopleKey];
//        
//        NSInteger peopleNum = [num integerValue];
//        
//        NSInteger inputNum = [_input integerValue];
//        NSLog(@"Original PEOPLE %ld", (long)peopleNum);
//        NSLog(@"Input PEOPLE %ld", inputNum);
//        
//        peopleNum = peopleNum - inputNum;
//        NSLog(@"NEW PEOPLE %ld", peopleNum);
//        NSString *newPeople = [NSString stringWithFormat:@"%li", (long)peopleNum];
//        NSLog(@"OBJECT KEY %@", _game[kObjectKey]);
//        NSLog(@"NEW PEOPLE %@", newPeople);
//        
//        [query getObjectInBackgroundWithId:_game[kObjectKey]
//                                     block:^(PFObject *game, NSError *error) {
//                                         game[@"People"] = newPeople;
//                                         [game saveInBackground];
//                                     }];
//        
//        NSDictionary *newGame = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 _game[kSportKey], kSportKey,
//                                 _game[kTimeKey], kTimeKey,
//                                 _game[kVenueKey], kVenueKey,
//                                 newPeople, kPeopleKey,
//                                 _game[kObjectKey], kObjectKey, nil];
//        
//        [self.model removeGameAtIndex:_currentIndex];
//        [self.model insertGame:newGame atIndex:_currentIndex];
//        
//        [self.tableView reloadData];
//    }
//
//}

 
@end
