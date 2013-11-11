//
//  DTSPieceView.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSPieceView.h"
#import "DTSPiece.h"

@implementation DTSPieceView

+(id)pieceViewWithPiece:(DTSPiece*)piece
{
    DTSPieceView *pieceView = [[DTSPieceView alloc]initWithPiece:piece];
    return pieceView;
}

-(id)initWithPiece:(DTSPiece*)piece
{
    if(self = [super initWithFrame:CGRectZero]){
 
        [self setUserInteractionEnabled:NO];
        _piece = piece;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"No, you don't.");
    return [self initWithPiece:nil];
}

-(void)drawRect:(CGRect)rect
{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
   
    [self drawPiece:[self piece] context:ctx];
}

-(void)drawPiece:(DTSPiece*)piece context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGRect rect = [self bounds];
    
    [self clipCornersToOvalWidth:5.0f height:5.0f inRect:rect];
    CGContextClip(ctx);
    
    [self drawGradientInContext:ctx inRect:rect selected:_highlighted];
    
    [self drawPieceTitle:[piece title] inRect:rect];
    
    [self drawPieceValue:[piece value] inRect:rect];
    
    CGContextRestoreGState(ctx);
    
}


//-(void)drawBackgroundInContext:(CGContextRef)context rect:(CGRect)rect
//{
//    CGContextFillRect(context, rect);
//}

- (void) clipCornersToOvalWidth:(float)ovalWidth height:(float)ovalHeight inRect:(CGRect)rect
{
    float fw, fh;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}



-(void)drawGradientInContext:(CGContextRef)c inRect:(CGRect)frame selected:(BOOL)highlighted
{
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    
    UIColor *startColor, *endColor;
    if(highlighted){
        startColor = [UIColor colorWithRed:28.0f/255 green:63.0f/255 blue:253.0f/255 alpha:.9];
        endColor = [UIColor colorWithRed:44.0f/255 green:29.0f/255 blue:255.0f/255 alpha:.9];
    }else{
        startColor = [UIColor colorWithRed:169.0f/255 green:3.0f/255 blue:41.0f/255 alpha:.9];
        endColor = [UIColor colorWithRed:109.0f/255 green:0.0f/255 blue:25.0f/255 alpha:.9];
    }
    
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents([startColor CGColor]);
    
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents([endColor CGColor]);
    
    
    CGFloat colorComponents[8] = {
        /* Four components of the orange color (RGBA) */
        startColorComponents[0],
        startColorComponents[1],
        startColorComponents[2],
        startColorComponents[3], /* First color = orange */
        /* Four components of the blue color (RGBA) */
        endColorComponents[0],
        endColorComponents[1],
        endColorComponents[2],
        endColorComponents[3], /* Second color = blue */
    };
    
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, colorComponents, locations, num_locations);
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
    CGPoint midCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
    CGContextDrawLinearGradient(c, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
}

-(void)drawPieceTitle:(NSString*)title inRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    
    UIFont *fontOfStartTime = [UIFont systemFontOfSize:20];
    
    float yPos,xPos, width, height;
	
    CGSize sizeNecessary = [title sizeWithFont:fontOfStartTime];
    
    width = sizeNecessary.width;
    height = sizeNecessary.height;
    
    xPos = round(rect.origin.x + (rect.size.width/2 - width/2));
    yPos = round(rect.origin.y + (rect.size.height/2 - height/2));
    
    if(yPos + height + 3 > [self bounds].size.height){
        
        return;
    }
    
    CGRect titleRect = CGRectMake(xPos,
                                  yPos,
                                  width,
                                  height);
    
    [title drawInRect: titleRect
             withFont:fontOfStartTime
        lineBreakMode:NSLineBreakByTruncatingTail
            alignment:NSTextAlignmentLeft];
	
}

-(void)drawPieceValue:(NSString*)value inRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    
    UIFont *fontOfStartTime = [UIFont systemFontOfSize:14];
    
    float yPos,xPos, width, height;
	
    CGSize sizeNecessary = [value sizeWithFont:fontOfStartTime];
    
    width = sizeNecessary.width;
    height = sizeNecessary.height;

    xPos = round(CGRectGetMaxX(rect) - (width+7));
    yPos = round(CGRectGetMaxY(rect) - (height+6));
    
    if(yPos + height + 3 > [self bounds].size.height){
        
        return;
    }
    
    CGRect valueRect = CGRectMake(xPos,
                                  yPos,
                                  width,
                                  height);
    
    [value drawInRect: valueRect
             withFont:fontOfStartTime
        lineBreakMode:NSLineBreakByTruncatingTail
            alignment:NSTextAlignmentLeft];
	
}

@end
