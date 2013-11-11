//
//  DTSSelected.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-27.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSSelected.h"

@interface DTSSelected ()

@property (nonatomic) CGRect emptyPosition;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger margin;

@property (nonatomic) NSInteger maxX;
@property (nonatomic) NSInteger minX;
@property (nonatomic) NSInteger minY;
@property (nonatomic) NSInteger maxY;

@property (nonatomic) CGPoint outsetPoint;
@property (nonatomic) CGRect outsetRect;


@end


@implementation DTSSelected



- (id)initWithPiecesSize:(CGSize)size margin:(NSInteger)margin
{
    self = [super init];
    if (self) {
        _width = size.width;
        _height = size.height;
        _margin = margin;
    }
    return self;
}


+(id)selectedWithPiecesSize:(CGSize)size margin:(NSInteger)margin
{
    DTSSelected *selected = [[DTSSelected alloc]initWithPiecesSize:size margin:margin];
    return selected;
}



#pragma mark - Custom Setters/Getters



-(void)setPiece:(DTSPiece *)piece
{
    if(piece){
        [self setOutsetPoint:[piece origin]];
        [self setOutsetRect:[piece position]];
    }else{
        [self setOutsetPoint:CGPointZero];
        [self setOutsetRect:CGRectZero];
    }
    _piece = piece;
}



#pragma mark - Select piece




-(BOOL)selectPiece:(DTSPiece *)piece emptyPosition:(CGRect)emptyPosition
{
    
    if([self canPieceBeSelected:piece emptyPosition:emptyPosition]){
        [self setEmptyPosition:emptyPosition];
        [self setPiece:piece];
        [self setDirectionLimitations];
        return YES;
    }
    
    [self setPiece:nil];
    return NO;
}


-(BOOL)canPieceBeSelected:(DTSPiece*)piece emptyPosition:(CGRect)emptyPosition
{
    CGPoint ePos = emptyPosition.origin;
    CGPoint pPos = [piece origin];
    CGSize pSize = [piece size];
    int margin = 20;
    
    if (fabsf(pPos.x - ePos.x) > 0.1f && fabsf(pPos.y - ePos.y) > 0.1f) {
        return NO;
    }
    
    CGRect pieceArea = CGRectMake(pPos.x-(pSize.width+margin), pPos.y-(pSize.height+margin), 200, 200);
    
    if(CGRectContainsPoint(pieceArea, ePos)){
        return YES;
    }
    
    return NO;
}


-(void)setDirectionLimitations
{
    
    CGPoint ePos = [self emptyPosition].origin;
    CGPoint pPos = [[self piece]origin];
    
    if(pPos.x == ePos.x){
        
        [self setDirectionLimitationToVerticalFlexWithPiecePosition:pPos emptyPosition:ePos];
        
    }else if(pPos.y == ePos.y){
        
        [self setDirectionLimitationToHorizontalFlexWithPiecePosition:pPos emptyPosition:ePos];
    }
}

-(void)setDirectionLimitationToVerticalFlexWithPiecePosition:(CGPoint)pPos emptyPosition:(CGPoint)ePos
{
    [self setMaxX:pPos.x];
    [self setMinX:pPos.x];
    
    if(pPos.y < ePos.y){
        
        [self setMaxY:pPos.y + _height +_margin];
        [self setMinY:pPos.y];
    }else{
        [self setMaxY:pPos.y];
        [self setMinY:pPos.y - (_height +_margin)];
    }
}

-(void)setDirectionLimitationToHorizontalFlexWithPiecePosition:(CGPoint)pPos emptyPosition:(CGPoint)ePos
{
    [self setMaxY:pPos.y];
    [self setMinY:pPos.y];
    
    if(pPos.x < ePos.x){
        
        [self setMaxX:pPos.x + _width + _margin];
        [self setMinX:pPos.x];
    }else{
        [self setMaxX:pPos.x];
        [self setMinX:pPos.x - (_width + _margin)];
    }
}




#pragma mark - Update




-(BOOL)updatePositionWithTranslation:(CGPoint)point
{
    if(nil == _piece){
        return NO;
    }
    
    CGRect pos = _piece.position;
    CGPoint pPos = pos.origin;
    

    if(_maxX+1 > pPos.x + point.x && _minX-1 < pPos.x + point.x   ){
        pos.origin.x += point.x;
    }
    if(_maxY+1 > pPos.y + point.y  && _minY-1 < pPos.y + point.y ){
        pos.origin.y += point.y;
    }
    
    [_piece setPosition:pos];

    return YES;
}


-(BOOL)moveToEmptySpace:(CGRect)emptyPosition
{
    if(nil == _piece){
        return NO;
    }
    
    CGRect position = [_piece position];
    
    if([self isSelectedNearOutsetPoint]){
        position.origin = _outsetPoint;
        [_piece setPosition:position];
        return NO;
    }
    
    position.origin.x = emptyPosition.origin.x;
    position.origin.y = emptyPosition.origin.y;

    
    [_piece setPosition:position];
    
    return YES;
}


-(BOOL)isSelectedNearOutsetPoint
{
    
    
    CGPoint pPos = _piece.origin;
    CGSize pSize = _piece.size;
    CGPoint oPos = _outsetPoint;
    
    
    int xArrow = pPos.x + pSize.width/2;
    int yArrow = pPos.y + pSize.height/2;
    
    if(xArrow >= oPos.x && xArrow <= oPos.x + pSize.width && yArrow >= oPos.y && yArrow <= oPos.y + pSize.height){
        return YES;
    }
    
    return NO;
}








@end
