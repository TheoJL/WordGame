//
//  DTSRecap.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-30.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSRecap : NSObject

+(id)recapWithFieldPosition:(CGPoint)origin margin:(NSInteger)margin;

@property (nonatomic, readonly) BOOL isNotEmpty;

@property (nonatomic, readonly) NSRange affectedVerticalSections;
@property (nonatomic, readonly) NSRange affectedHorizontalSections;




-(void)movedFromPosition:(CGRect)from toPosition:(CGRect)to;



@end
