//
//  DTSMainSubView.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSMainSubView.h"
#import "DTSTraceView.h"
#import "DTSPieceView.h"
#import "DTSPiece.h"
#import "DTSTrace.h"
#import "DTSFXSubView.h"
#import <QuartzCore/QuartzCore.h>

@interface DTSMainSubView ()

@property (nonatomic, strong) DTSFXSubView *fxSubView;

@end

@implementation DTSMainSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
    }
    return self;
}




#pragma mark - Custom Getters/Setters




-(DTSFXSubView *)fxSubView
{
    if(nil == _fxSubView){
        _fxSubView = [[DTSFXSubView alloc]initWithFrame:[self bounds]];
        [self addSubview:_fxSubView];
    }else{
        [self bringSubviewToFront:_fxSubView];
    }
    return _fxSubView;
}



#pragma mark - Pieces




-(void)addPieceViews:(NSSet*)pieces
{
    for (DTSPiece *piece in pieces) {
        
        DTSPieceView *view = [self viewForPiece:piece];
        [piece setPieceView:view];
        
        [view setFrame:[piece position]];
        
        [self insertSubview:view atIndex:0];
    }
}

-(void)updatePieceViewWithPiece:(DTSPiece*)piece animation:(BOOL)animation
{
    if(animation){
        
        [UIView animateWithDuration:0.1 animations:^{
            [[piece pieceView]setFrame:[piece position]];
            
            [[piece pieceView]setCenter:CGPointMake(CGRectGetMidX(piece.position), CGRectGetMidY(piece.position))];
        }];
        
    }else{
        [[piece pieceView]setFrame:[piece position]];
    }
}




#pragma mark - Traces



-(void)addTraceViews:(NSArray*)traces
{
    for (DTSTrace *trace in traces) {
        
        
        DTSTraceView *traceView = [self viewForTrace:trace];
        [trace setTraceView:traceView];
        [traceView setPosition:[trace position]];
        //[traceView setFrame:[trace position]];
        [self addSubview:traceView];
    }
}


-(void)removeTraceViews:(NSArray*)traces
{
    for (DTSTrace *trace in traces) {
        [[trace traceView] removeFromSuperview];
    }
}




#pragma mark - Group Animations




-(void)updateViewsAtOnceWithDelay:(NSInteger)delay
                    removedPieces:(NSArray*)removed
                    updatedPieces:(NSArray*)updated
                      addedPieces:(NSArray*)added
                     removedBlock:(animationBlock)removedBlock
                     updatedBlock:(animationBlock)updatedBlock
                       addedBlock:(animationBlock)addedBlock
                        completed:(animationBlock)completed

{
    completed(YES, NO);
    
    [self removePieceViews:removed delay:0+delay duration:0.2 animationBlock:removedBlock];
    [self updatePieceViews:updated delay:1+delay duration:1 animationBlock:updatedBlock];
    
    [self addPieceViews:added delay:1.8+delay duration:2 animationBlock:^(BOOL start, BOOL done) {
        addedBlock(start, done);
        if(done)
            completed(start, done);
    }];
}


-(void)removePieceViews:(NSArray*)pieces delay:(float)delay duration:(float)duration animationBlock:(animationBlock)animationBlock
{
    __block int iterations = pieces.count;
    
    // Work in progress
    
    for (DTSPiece *piece in pieces) {
        
        DTSPieceView *pw = [piece pieceView];
        
        
        [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [[pw layer]setBounds:CGRectZero];

        } completion:^(BOOL finished) {
            [pw removeFromSuperview];
            [[self fxSubView]addExplosionToPositionInPiece:piece];

            if(--iterations == 0)
                animationBlock(NO, YES);
        }];
    }
    animationBlock(YES, NO);
}


//-(void)removePieceViews:(NSArray*)pieces delay:(float)delay duration:(float)duration animationBlock:(animationBlock)animationBlock
//{
//    __block int iterations = pieces.count;
//   
//    for (DTSPiece *piece in pieces) {
//        
//        DTSPieceView *pw = [piece pieceView];
//        
//        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
//            
//           [pw setAlpha:0];
//            
//        } completion:^(BOOL finished) {
//            [pw removeFromSuperview];
//            if(--iterations == 0)
//                animationBlock(NO, YES);
//        }];
//    }
//    animationBlock(YES, NO);
//}


-(void)updatePieceViews:(NSArray*)pieces delay:(float)delay duration:(float)duration animationBlock:(animationBlock)animationBlock
{
    __block int iterations = pieces.count;

    for (DTSPiece *piece in pieces) {
        delay+=0.05;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [[piece pieceView]setFrame:[piece position]];

        } completion:^(BOOL finished) {
            if(--iterations == 0)
                animationBlock(NO, YES);
            
        }];
    }
    animationBlock(YES, NO);
}


-(void)addPieceViews:(NSArray*)pieces delay:(float)delay duration:(float)duration animationBlock:(animationBlock)animationBlock
{
    __block int iterations = pieces.count;
    
    for (DTSPiece *piece in pieces) {
        CGRect p = [piece position];
        
        DTSPieceView *pw = [self viewForPiece:piece];
        [piece setPieceView:pw];
        
        [pw setAlpha:0];
        [pw setFrame:p];
        
        [UIView animateWithDuration:0.8 delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            [pw setAlpha:1];
        } completion:^(BOOL finished) {
            if(--iterations == 0)
                animationBlock(NO, YES);
        }];
        
        [self insertSubview:[piece pieceView] atIndex:0];
    }
    animationBlock(YES,NO);
}



-(void)highlightPieceViews:(NSArray*)pieces completion:(animationBlock)animationBlock
{
    __block int iterations = pieces.count;
    
    for (DTSPiece *piece in pieces) {
        
        DTSPieceView *pw = [piece pieceView];
        [pw setHighlighted:YES];
        [pw setNeedsDisplay];
        [pw setAlpha:0.4];
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [pw setAlpha:1.0];
  
        } completion:^(BOOL finished) {
            
            if(--iterations == 0)
                animationBlock(NO, YES);
        }];
    }
    animationBlock(YES, NO);
}





#pragma mark - Convenience




-(DTSPieceView*)viewForPiece:(DTSPiece*)piece
{
    if([piece pieceView]){
        return [piece pieceView];
    }

    
    return [DTSPieceView pieceViewWithPiece:piece];
}


-(DTSTraceView*)viewForTrace:(DTSTrace*)trace
{
    if([trace traceView]){
        return [trace traceView];
    }
    return [DTSTraceView traceViewWithTrace:trace];
}


-(void)addArrayOfSubviews:(NSArray*)subviews toFront:(BOOL)front
{
    
    for(UIView *subview in subviews){
        if(front){
            [self addSubview:subview];
        }else{
            [self insertSubview:subview atIndex:0];
        }
    }
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
