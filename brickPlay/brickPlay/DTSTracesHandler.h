//
//  DTSTracesHandler.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSTracesHandler : NSObject

@property (nonatomic, strong, readonly) NSMutableSet *traces;


-(NSArray*)tracesNotAlreadyExistsFromAddingTraces:(NSArray *)traces;

-(NSArray*)tracesRemovedAfterCleaning;

-(NSArray*)tracesSortedByWordValues;


@end
