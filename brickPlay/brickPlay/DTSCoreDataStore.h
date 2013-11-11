//
//  DTSCoreDataStore.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-08.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSCoreDataStore : NSObject


+(id)shared;


@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;


-(id)insertNewObjectWithEnityName:(NSString*)entityName;

-(void)fetchAvailableWords:(NSArray*)words completion:(void (^)(NSArray* availableWords))completion;

-(void)saveContext;

@end
