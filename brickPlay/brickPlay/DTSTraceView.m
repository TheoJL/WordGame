//
//  DTSTraceView.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSTraceView.h"
#import "DTSTrace.h"
#import <QuartzCore/QuartzCore.h>
@implementation DTSTraceView

+(id)traceViewWithTrace:(DTSTrace*)trace
{
    DTSTraceView *traceView = [[DTSTraceView alloc]initWithTrace:trace];
    return traceView;
}

-(id)initWithTrace:(DTSTrace*)trace
{
    
    if(self = [super initWithFrame:CGRectZero]){
        _trace = trace;
        [self setLayerSettings];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"No, you don't.");
    return [self initWithTrace:nil];
}


-(void)setPosition:(CGRect)frame
{
    CALayer *layer = [self layer];
    layer.position = [self midPoint:frame];
    layer.bounds = CGRectMake(0, 0, frame.size.width-8, frame.size.height-8);;
}


-(void)setLayerSettings
{
    CALayer *layer = [self layer];
    layer.borderWidth = 1.0;
    layer.cornerRadius = 5;
    layer.borderColor = [UIColor yellowColor].CGColor;
}


//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    [[UIColor greenColor]set];
//    
//    CGRect stroke = rect;
//    stroke.origin.x+=5;
//    stroke.origin.y+=5;
//    stroke.size.width-=10;
//    stroke.size.height-=10;
//
//    
//    CGContextStrokeRect(ctx, stroke);
//    
//    
//}

-(CGPoint)midPoint:(CGRect)r
{
    return CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
}


@end
