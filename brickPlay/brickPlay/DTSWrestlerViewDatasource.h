//
//  DTSWrestlerViewDatasource.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTSWrestlerView,DTSPiece,DTSPieceView, DTSTrace, DTSTraceView;

@protocol DTSWrestlerViewDatasource <NSObject>




-(DTSPiece*)wrestlerView:(DTSWrestlerView*)wView pieceForRowAtIndexPath:(NSIndexPath*)indexpath;

-(NSInteger)numberOfSectionsInWrestlerView:(DTSWrestlerView*)wrestlerView;

-(NSInteger)numberOfRowsForEachSectionInWrestlerView:(DTSWrestlerView*)wrestlerView;

-(DTSPiece*)wrestlerView:(DTSWrestlerView*)wView pieceForReplacingPiece:(DTSPiece*)piece;


@optional

-(DTSTraceView*)wrestlerView:(DTSWrestlerView*)wView overlayForWord:(DTSTrace*)word;







@end
