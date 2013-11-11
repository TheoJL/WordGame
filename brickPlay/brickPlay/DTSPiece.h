//
//  DTSPiece.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTSPieceView;
@interface DTSPiece : NSObject

+(id)pieceWithTitle:(NSString*)title value:(NSString*)value;

@property (nonatomic) CGRect position;
@property (nonatomic, weak) DTSPieceView *pieceView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong, readonly) NSNumber *sortNumberHorizontal;
@property (nonatomic, strong, readonly) NSNumber *sortNumberVertical;

@property (nonatomic) BOOL isDeleted;

-(CGPoint)origin;
-(CGSize)size;



@end
