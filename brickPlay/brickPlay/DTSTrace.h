//
//  DTSTrace.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-30.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DTSTraceView;
@interface DTSTrace : NSObject

+(id)traceWithWord:(NSString*)word pieces:(NSArray*)pieces;


@property (nonatomic, weak) DTSTraceView *traceView;
@property (nonatomic, copy, readonly) NSString *word;
@property (nonatomic, copy, readonly) NSArray *pieces;

@property (nonatomic, readonly) CGRect position;
@property (nonatomic, readonly) BOOL isVertical;

@property (nonatomic, readonly) NSNumber *wordLength;
@property (nonatomic, readonly) NSNumber *wordValue;

@end
