//
//  DTSPiecesController.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-28.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void(^changedPiecesBlock)(NSArray*removed, NSArray*added, NSArray*moved);



@class DTSPiece, DTSTrace;

@interface DTSPiecesController : NSObject




+(id)controllerWithSections:(NSInteger)sections rowsInSections:(NSInteger)rowsInSections;


@property (nonatomic, strong, readonly) NSMutableSet *pieces;


-(BOOL)selectPiece:(DTSPiece*)piece;

-(BOOL)updatePositionOfSelectedWithTranslation:(CGPoint)point;

-(BOOL)setSelectedToEmptySpace;

-(NSSet*)allWords;

-(NSSet*)wordsFromLastMove;

-(NSArray*)tracesFromWords:(NSSet*)words;

-(BOOL)addPiece:(DTSPiece*)piece indexPath:(NSIndexPath*)indexPath;

-(DTSPiece*)selectedPiece;

-(void)replaceWord:(DTSTrace*)trace replacementPieces:(NSArray *)pieces changedPieces:(changedPiecesBlock)changedPieces;


@end
