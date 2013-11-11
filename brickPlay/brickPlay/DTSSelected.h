//
//  DTSSelected.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-27.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSPiece.h"

@interface DTSSelected : NSObject

+(id)selectedWithPiecesSize:(CGSize)size margin:(NSInteger)margin;

@property (nonatomic, strong, readonly) DTSPiece *piece;
@property (nonatomic, readonly) CGRect outsetRect;


-(BOOL)selectPiece:(DTSPiece *)piece emptyPosition:(CGRect)position;

-(BOOL)moveToEmptySpace:(CGRect)emptyPosition;

-(BOOL)updatePositionWithTranslation:(CGPoint)point;




@end
