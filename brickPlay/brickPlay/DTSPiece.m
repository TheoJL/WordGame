//
//  DTSPiece.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSPiece.h"

@interface DTSPiece ()

@property (nonatomic, strong) NSNumber *sortNumberVertical;
@property (nonatomic, strong) NSNumber *sortNumberHorizontal;



@end
@implementation DTSPiece



+(id)pieceWithTitle:(NSString*)title value:(NSString*)value
{
    DTSPiece *piece = [[DTSPiece alloc]init];
    
    [piece setTitle:title];
    [piece setValue:value];
    
    return piece;
}


#pragma mark - Custom Setters/Getters


-(NSNumber *)sortNumberHorizontal
{
    if(nil == _sortNumberHorizontal){
       
        _sortNumberHorizontal = @([[NSString stringWithFormat:@"%i.%05i", (int)self.position.origin.y, (int)self.position.origin.x]floatValue]);

    }
    return _sortNumberHorizontal;
}

-(NSNumber *)sortNumberVertical
{
    if(nil == _sortNumberVertical){
        
        _sortNumberVertical = @([[NSString stringWithFormat:@"%i.%05i", (int)self.position.origin.x, (int)self.position.origin.y]floatValue]);
        
    }
    return _sortNumberVertical;
}

-(void)setPosition:(CGRect)position
{
    _sortNumberHorizontal = nil;
    _sortNumberVertical = nil;
    
    _position = position;
}



#pragma mark - Convenience




-(CGPoint)origin
{
    if(CGRectIsNull([self position])){
        return CGPointZero;
    }
    
    return CGPointMake([self position].origin.x, [self position].origin.y);
}

-(CGSize)size
{
    CGSize size = CGSizeMake([self position].size.width, [self position].size.height);
    return size;
}


@end
