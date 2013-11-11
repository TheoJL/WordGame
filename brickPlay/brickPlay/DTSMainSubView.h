//
//  DTSMainSubView.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DTSAnimationCool ,
    DTSAnimationYEAH

    
} DTSAnimationType;

typedef void(^animationBlock)(BOOL start, BOOL done);

@class DTSPiece;
@interface DTSMainSubView : UIView


-(void)addPieceViews:(NSSet*)pieceViews;

-(void)updatePieceViewWithPiece:(DTSPiece*)piece animation:(BOOL)animation;

-(void)highlightPieceViews:(NSArray*)pieces completion:(animationBlock)animationBlock;

-(void)updateViewsAtOnceWithDelay:(NSInteger)delay
                    removedPieces:(NSArray*)removed
                    updatedPieces:(NSArray*)updated
                      addedPieces:(NSArray*)added
                     removedBlock:(animationBlock)removedBlock
                     updatedBlock:(animationBlock)updatedBlock
                       addedBlock:(animationBlock)addedBlock
                        completed:(animationBlock)completed;





-(void)addTraceViews:(NSArray*)traces;
-(void)removeTraceViews:(NSArray*)traces;


@end
