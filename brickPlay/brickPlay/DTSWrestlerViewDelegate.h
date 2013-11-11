//
//  DTSWrestlerViewDelegate.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTSWrestlerView,DTSPiece,DTSPieceView, DTSTrace;

@protocol DTSWrestlerViewDelegate <NSObject>


@optional

-(void)wrestlerView:(DTSWrestlerView*)wView didSelectView:(DTSPieceView*)pieceView;

-(void)wrestlerView:(DTSWrestlerView*)wView didReleaseView:(DTSPieceView*)pieceView changedPosition:(BOOL)changed;

-(void)wrestlerView:(DTSWrestlerView*)wView viewModifiedWithAddedLetterCombinations:(NSSet*)combinations;

-(BOOL)wrestlerView:(DTSWrestlerView*)wView shouldReplaceTappedWord:(DTSTrace*)word;

-(void)wrestlerView:(DTSWrestlerView*)wView didReplaceWord:(DTSTrace*)word userTriggered:(BOOL)usrTriggd;


@end
