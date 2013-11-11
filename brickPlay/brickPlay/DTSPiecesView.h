//
//  DTSPiecesView.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSPiecesView : UIView

-(id)initWithFrame:(CGRect)frame pieces:(NSSet *)pieces;

@property (nonatomic, strong) NSMutableSet *pieces;

@end
