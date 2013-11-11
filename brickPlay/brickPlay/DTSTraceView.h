//
//  DTSTraceView.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTSTrace;
@interface DTSTraceView : UIView

+(id)traceViewWithTrace:(DTSTrace*)trace;


@property (nonatomic, strong) DTSTrace *trace;


-(void)setPosition:(CGRect)frame;


@end
