//
//  GameModel.h
//  FinalProject
//
//  Created by Jessica Pak on 4/6/16.
//  Copyright © 2016 Jessica Pak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"

// constants
static NSString * const kSportKey = @"sport";
static NSString * const kTimeKey = @"date";
static NSString * const kVenueKey = @"venue";
static NSString * const kPeopleKey = @"people";
static NSString * const kObjectKey = @"object";

@interface GameModel : NSObject

+ (instancetype) sharedModel;
- (NSUInteger) numberOfGames;
- (NSDictionary *) gameAtIndex: (NSUInteger) index;
- (void) removeGameAtIndex: (NSUInteger) index;
- (void) insertGame: (NSDictionary *) game;
- (void) reloadDataFromDatabase;
- (void) clearAllGames;
- (void) insertGame: (NSString *) sport
               time: (NSString *) time
              venue: (NSString *) venue
             people: (NSString *) people
             object: (NSString *) object;
- (void) insertGame: (NSDictionary *) game atIndex: (NSUInteger) index;

@end
