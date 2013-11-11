//
//  DTSRecap.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-30.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSRecap.h"

@interface DTSRecap ()

@property (nonatomic) BOOL isNotEmpty;
@property (nonatomic) BOOL isUpdated;

@property (nonatomic) CGRect fromPosition;
@property (nonatomic) CGRect toPosition;
@property (nonatomic) CGPoint fieldOrigin;
@property (nonatomic) NSInteger margin;

@property (nonatomic) NSRange affectedVerticalSections;
@property (nonatomic) NSRange affectedHorizontalSections;

@end

@implementation DTSRecap


-(id)initWithFieldPosition:(CGPoint)origin margin:(NSInteger)margin
{
    if(self = [super init]){
        
        _fieldOrigin = origin;
        _margin = margin;
    }
    return self;
}


+(id)recapWithFieldPosition:(CGPoint)origin margin:(NSInteger)margin
{
    return [[DTSRecap alloc]initWithFieldPosition:origin margin:margin];
}




#pragma mark Custom Setters/Getters




-(BOOL)isNotEmpty
{
    if(CGRectIsNull([self fromPosition]) || CGRectIsNull([self toPosition])){
       
        return NO;
    }
    return YES;
}

-(NSRange)affectedHorizontalSections
{
    if(NO == [self isUpdated]){
        [self calculateAffectedSections];
    }
    return _affectedHorizontalSections;
}

-(NSRange)affectedVerticalSections
{
    if(NO == [self isUpdated]){
        [self calculateAffectedSections];
    }
    return _affectedVerticalSections;
}



#pragma mark - Incoming Move



-(void)movedFromPosition:(CGRect)from toPosition:(CGRect)to
{
    [self setFromPosition:from];
    [self setToPosition:to];
    [self setIsUpdated:NO];
}



#pragma mark - Calculate Affected Sections



-(void)calculateAffectedSections
{
    CGPoint from = [self fromPosition].origin;
    CGPoint to = [self toPosition].origin;

    if(from.x == to.x){
        [self setRangeFromHorizontalMoveWithFromOrigin:from
                                              toOrigin:to
                                             pieceSize:[self fromPosition].size];
    }else{

        [self setRangeFromVerticalMoveWithFromOrigin:from
                                             toOrigin:to
                                            pieceSize:[self fromPosition].size];
    }
    
    [self setIsUpdated:YES];
}

-(void)setRangeFromVerticalMoveWithFromOrigin:(CGPoint)from toOrigin:(CGPoint)to pieceSize:(CGSize)size
{
    int vLoc = [self rangeLocWithDistanceToPiece:from.y offset:_fieldOrigin.y pieceSize:size.height];
    int hLoc = [self rangeLocWithDistanceToPiece:MIN(from.x,to.x) offset:_fieldOrigin.x pieceSize:size.width];
    
    self.affectedHorizontalSections = NSMakeRange(hLoc, 2);
    self.affectedVerticalSections = NSMakeRange(vLoc, 1);
}

-(void)setRangeFromHorizontalMoveWithFromOrigin:(CGPoint)from toOrigin:(CGPoint)to pieceSize:(CGSize)size
{
    int hLoc = [self rangeLocWithDistanceToPiece:from.x offset:_fieldOrigin.x pieceSize:size.width];
    int vLoc = [self rangeLocWithDistanceToPiece:MIN(from.y,to.y) offset:_fieldOrigin.y pieceSize:size.height];
    
    self.affectedHorizontalSections = NSMakeRange(hLoc, 1);
    self.affectedVerticalSections = NSMakeRange(vLoc, 2);
}

-(NSInteger)rangeLocWithDistanceToPiece:(float)distance offset:(float)offset pieceSize:(float)pieceSize
{
    int safe = 10;
    int loc = ((distance+safe) - offset) / (pieceSize + _margin);
    return loc;
}



@end
