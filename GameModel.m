//
//  GameModel.m
//  FinalProject
//
//  Created by Jessica Pak on 4/6/16.
//  Copyright © 2016 Jessica Pak. All rights reserved.
//

#import "GameModel.h"
#import <Parse/Parse.h>

@interface GameModel ()

// private properties
@property (strong, nonatomic) NSMutableArray *games;
@property (nonatomic) NSUInteger currentIndex;

@end


@implementation GameModel: NSObject

+ (instancetype) sharedModel {
    static GameModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (id) init {
    self = [super init];
    if (self) {
        _games = [[NSMutableArray alloc] init];
                
        self.currentIndex = 0;
    }
    return self;
}

// returns the total number of games
- (NSUInteger) numberOfGames {
    return [self.games count];
}

// returns a game at a given index
- (NSDictionary *) gameAtIndex: (NSUInteger) index {
    // check index
    NSUInteger numOfCards = [self numberOfGames];
    if(index <= numOfCards)
        return self.games[index];
    else {
        NSLog(@"Index is out of range.");
        return 0;
    }
}

// removes a favorite at a given index
- (void) removeGameAtIndex: (NSUInteger) index {
    // check index
    NSUInteger numOfCards = [self numberOfGames];
    if(index <= numOfCards){
        [self.games removeObjectAtIndex: index];
//        [self save];
    }
    else {
        NSLog(@"Index is out of range, cannot remove.");
    }
}

- (void) clearAllGames {
    [_games removeAllObjects];
}

- (void) reloadDataFromDatabase {
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            for(int i = 0; i < objects.count; i++) {
                PFObject *myArrayElement = [objects objectAtIndex:i];
                NSDictionary *game = [[NSDictionary alloc] initWithObjectsAndKeys: myArrayElement[@"Sport"], kSportKey, myArrayElement[@"Date"], kTimeKey, myArrayElement[@"Venue"], kVenueKey, myArrayElement[@"People"], kPeopleKey,
                                      myArrayElement.objectId, kObjectKey, nil];
                [self insertGame: game];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            NSLog(@"Couldn't init game array");
        }
    }];
}

// inserts a game at the end of the array
- (void) insertGame: (NSDictionary *) game {
    [self.games addObject: game];
//    [self save];
}

// inserts a Game with a question and answer
- (void) insertGame: (NSString *) sport
            time: (NSString *) time
            venue: (NSString *) venue
             people: (NSString *) people
             object: (NSString *) object{
    
    NSDictionary *gameEntry = [NSDictionary dictionaryWithObjectsAndKeys:
                               sport, kSportKey, time, kTimeKey, venue, kVenueKey,
                               people, kPeopleKey, object, kObjectKey, nil];
    
    [self insertGame: gameEntry ];
//    [self save];
}


// inserts a game with a question, answer, and index
- (void) insertGame: (NSString *) sport
                  time: (NSString *) time
                  venue: (NSString *) venue
                  atIndex: (NSUInteger) index {
    
    NSDictionary *gameEntry = [NSDictionary dictionaryWithObjectsAndKeys:
                               sport, kSportKey, time, kTimeKey, venue, kVenueKey, nil];
    
    NSUInteger num = [self numberOfGames];
    if(index <= num) {
        [self insertGame: gameEntry atIndex:index];
//        [self save];
    }
}

// inserts a game with a card and index
- (void) insertGame: (NSDictionary *) game
                 atIndex: (NSUInteger) index {
    NSUInteger numOfCards = [self numberOfGames];
    if(index <= numOfCards) {
        [self.games insertObject: game atIndex: index];
//        [self save];
    }
    else {
        NSLog(@"Index is out of range, so added card to the end");
        [self insertGame: game ];
    }
}



@end
