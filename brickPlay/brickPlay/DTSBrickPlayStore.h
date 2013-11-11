//
//  DTSBrickPlayStore.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DTSBrickPlayStore : NSObject

+(id)sharedStore;


@property (nonatomic, strong) NSManagedObjectContext *context;

@end
