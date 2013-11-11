//
//  DTSTrace.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-30.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSTrace.h"
#import "DTSPiece.h"

@interface DTSTrace ()

@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSArray *pieces;
@property (nonatomic) CGRect position;
@property (nonatomic) BOOL isVertical;

@property (nonatomic) NSNumber *wordLength;
@property (nonatomic) NSNumber *wordValue;


@end


@implementation DTSTrace



-(id)initWithWord:(NSString*)word pieces:(NSArray*)pieces
{
    if(self = [super init]){
        _word = word;
        _pieces = pieces;
        _position = [self calculatePosition];
    }
    return self;
}


+(id)traceWithWord:(NSString *)word pieces:(NSArray *)pieces
{
    DTSTrace *trace = [[DTSTrace alloc]initWithWord:word pieces:pieces];
    return trace;
}



#pragma mark - Custom Setters/Getters



-(NSNumber *)wordValue
{
    if(nil == _wordValue){
        _wordValue = @([self calculateValueOfAllPieces:[self pieces]]);
    }
    return _wordValue;
}


-(NSNumber *)wordLength
{
    if(nil == _wordLength){
        _wordLength = @([self pieces].count);
    }
    return _wordLength;
}



#pragma mark - Uniqueness to position



- (BOOL)isEqual:(DTSTrace*)unObj
{
    if ([unObj isMemberOfClass:[self class]]) {
        return (CGRectEqualToRect([unObj position],[self position]));
    }
    return NO;
}

- (NSUInteger)hash
{
    return round(((_position.origin.x+19)+(_position.origin.y+9))) * round(((_position.size.height+2) + (_position.size.width+3))) ;
}



#pragma mark - Calculate Position





-(CGRect)calculatePosition
{
    if([self pieces].count < 2){
        return CGRectNull;
    }
    DTSPiece *one = _pieces[0];
    DTSPiece *two = _pieces[1];
    
    return (one.origin.x == two.origin.x)?[self calculateVerticalPosition]:[self calculateHorizontalPosition];
}

-(CGRect)calculateVerticalPosition
{
    [self setIsVertical:YES];
    
    DTSPiece *p1 = _pieces[0];
    DTSPiece *p2 = _pieces[_pieces.count-1];
    
    CGRect r1 = p1.position;
    CGRect r2 = p2.position;
    
    return CGRectMake(r1.origin.x, p1.origin.y, p1.size.width, (r2.origin.y+r2.size.height)-r1.origin.y);
}

-(CGRect)calculateHorizontalPosition
{
    DTSPiece *p1 = _pieces[0];
    DTSPiece *p2 = _pieces[_pieces.count-1];
    
    CGRect r1 = p1.position;
    CGRect r2 = p2.position;
    
    return CGRectMake(r1.origin.x, p1.origin.y, (r2.origin.x+r2.size.width)-r1.origin.x, r1.size.height );
}


#pragma mark - Convenience



-(NSInteger)calculateValueOfAllPieces:(NSArray*)pieces
{
    NSInteger sum = 0;
    for (DTSPiece* piece in pieces) {
        sum += piece.value.intValue;
    }
    return sum;
}

@end
