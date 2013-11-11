//
//  DTSFXSubView.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-16.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSFXSubView.h"
#import <QuartzCore/QuartzCore.h>
#import "DTSPiece.h"

@implementation DTSFXSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)addExplosionToPositionInPiece:(DTSPiece*)piece
{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    
    emitter.emitterPosition = CGPointMake(CGRectGetMidX(piece.position), CGRectGetMidY(piece.position));
    
    emitter.emitterSize = CGSizeMake(50, 50);
    
    CAEmitterCell *explosion = [CAEmitterCell emitterCell];
    
    explosion.contents      = (__bridge id)[[UIImage imageNamed:@"particleRed"] CGImage];
    explosion.birthRate		= 300;
    explosion.velocity		= 100;
    explosion.velocityRange = 50;
    explosion.emissionRange	= 2* M_PI;	// 360 deg
    explosion.yAcceleration	= 200;		// gravity
    explosion.lifetime		= 0.6;
    explosion.redRange      = 1.0;
    explosion.redSpeed      = 0.5;
    explosion.spin			= 2* M_PI;
    explosion.spinRange		= 2* M_PI;
    explosion.redRange      = 1.0;
    explosion.redSpeed      = 0.5;
    explosion.scale         = 0.7;


    CAEmitterCell *explosion2 = [CAEmitterCell emitterCell];
    
    explosion2.contents      = (__bridge id)[[UIImage imageNamed:@"particleWhite"] CGImage];
    explosion2.birthRate		= 10;
    explosion2.velocity		= 200;
    explosion2.emissionRange	= 2* M_PI;	// 360 deg
    explosion2.lifetime		= 0.3;
    explosion2.redRange      = 1.0;
    explosion2.redSpeed      = 0.5;
    explosion2.spin			= 2* M_PI;
    explosion2.spinRange		= 2* M_PI;
    explosion2.scale = 0.7;

    emitter.emitterCells = @[explosion, explosion2];
    
    [[self layer]addSublayer:emitter];
   
    double delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [emitter setLifetime:0.0];
        [emitter removeFromSuperlayer];
    });
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
