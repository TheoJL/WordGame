//
//  DTSPieceView.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTSPiece;
@interface DTSPieceView : UIView

@property (nonatomic, strong) DTSPiece *piece;

@property (nonatomic) BOOL highlighted;

+(id)pieceViewWithPiece:(DTSPiece*)piece;

@end
