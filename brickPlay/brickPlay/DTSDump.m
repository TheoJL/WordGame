//
//  DTSDump.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-28.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSDump.h"

@implementation DTSDump

/*
 -(void)setSelectedToNearestPosition
 {
 DTSSelected *selected = [self selected];
 
 if(nil == [selected piece]){
 return;
 }
 
 CGRect position = [[selected piece]position];
 CGPoint pPos = [[selected piece]origin];
 
 if([selected xSpan] /2 > pPos.x - selected.minX)
 position.origin.x = selected.minX;
 else
 position.origin.x = selected.maxX;
 
 
 if([selected ySpan] /2 > pPos.y - selected.minY)
 position.origin.y = selected.minY;
 else
 position.origin.y = selected.maxY;
 
 
 [[selected piece]setPosition:position];
 }
 */

-(NSInteger)xSpan
{
    return self.maxX - self.minX;
}

-(NSInteger)ySpan
{
    return self.maxY - self.minY;
}


*/

//-(NSArray*)matrixFromArray:(NSArray*)arr numberOfRows:(NSInteger)rows
//{
//    int sections = arr.count / rows;
//
//    NSMutableArray *matrix = [[NSMutableArray alloc]init];
//
//    for(int i = 0; i < sections; i++){
//        NSMutableArray *aArr = [[NSMutableArray alloc]init];
//        for(int j = 0; j < rows; j++){
//
//            [aArr addObject:arr[(i*rows)+j]];
//        }
//        [matrix addObject:aArr];
//    }
//    return matrix;
//}



-(NSArray*)horizontalWordsFromMatrix:(NSArray*)matrix
{
    NSMutableArray *set = [[NSMutableArray alloc]init];
    
    for (NSArray *array in matrix) {
        int count = 0;
        for(DTSPiece *piece in array){
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for(int i = count; i < array.count; i++){
                
                [arr addObject:[piece title]];
            }
            [set addObject:[arr componentsJoinedByString:@""]];
            count++;
        }
    }
    return set;
}

-(NSArray*)verticalWordsFromMatrix:(NSArray*)matrix
{
    NSMutableArray *set = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < 5; i++){
        int count = 0;
        
        for(int j = 0 ; j < matrix.count; j++, count++){
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            
            for (int k = count; k < matrix.count; k++) {
                [arr addObject:[(DTSPiece*)matrix[k][i] title]];
                
            }
            [set addObject:[arr componentsJoinedByString:@""]];
            
        }
        
        
    }
    
    
    
    return set;
}


CFAbsoluteTime starttime = CFAbsoluteTimeGetCurrent();
NSLog(@"%.2fms", 1000.0*(CFAbsoluteTimeGetCurrent() - starttime));




//    NSPredicate *removeLetters = [NSPredicate predicateWithFormat:@"position.origin.x > %f AND position.origin.x < %f AND position.origin.y > %f AND position.origin.y < %f", wPos.origin.x - epsilon, wPos.origin.x + epsilon, wPos.origin.y, wPos.origin.y + wPos.size.height];
//    NSPredicate *predtest = [NSPredicate predicateWithBlock:^BOOL(DTSPiece *evaluatedObject, NSDictionary *bindings) {
//
//        CGRect r = evaluatedObject.position;
//
//        if (fabsf(r.origin.x - traceX) < 0.0001 && r.origin.y >= traceY && r.origin.y <= traceY + tracePos.size.height) {
//            return YES;
//        }
//        return NO;
//    }];



//    if(remove.count != word.pieces.count){
//        changedPieces(@[],@[],@[]);
//        return;
//    }


//-(NSInteger)numberOfPieces
//{
//    if(0 == _numberOfPieces){
//        _numberOfPieces = _numberOfRowsInSections * _numberOfSections;
//    }
//
//    return _numberOfPieces;
//}







NSLog(@"removed %i, added %i, moved %i ", removed.count, added.count, moved.count );

for (DTSPiece *p in added) {
    NSLog(@"Added letter: %@, x: %f, y: %f", [p title], p.position.origin.x, p.position.origin.y);
}
NSLog(@"----------");
for (DTSPiece *p in removed) {
    NSLog(@"Removed letter: %@, x: %f, y: %f", [p title], p.position.origin.x, p.position.origin.y);
}
for (DTSPiece *p in moved) {
    NSLog(@"Moved letter: %@, x: %f, y: %f", [p title], p.position.origin.x, p.position.origin.y);
}




//-(NSArray*)createViewsFromAllPieces
//{
//    NSMutableArray *views = [NSMutableArray array];
//
//    for(DTSPiece *piece in [[self pieceController]pieces]){
//        [self createViewForPiece:piece];
//        [views addObject:[piece pieceView]];
//    }
//    return views;
//}


-(void)createViewForPiece:(DTSPiece*)piece
{
    DTSPieceView *view = [DTSPieceView pieceViewWithPiece:piece];
    [piece setPieceView:view];
}


/*
 
 -(NSArray*)wordsFromFile
 {
 NSString* filePath = @"norstedts_stora_svenska_ordbok";
 NSString* fileRoot = [[NSBundle mainBundle]
 pathForResource:filePath ofType:@"txt"];
 
 
 NSString* fileContents =
 [NSString stringWithContentsOfFile:fileRoot
 encoding:NSUTF8StringEncoding error:nil];
 
 
 NSArray* allLinedStrings =
 [fileContents componentsSeparatedByCharactersInSet:
 [NSCharacterSet newlineCharacterSet]];
 
 NSArray *filtered = [self removeUnwantedWordsFromArray:allLinedStrings];
 
 
 return filtered;
 }
 
 -(NSArray*)removeUnwantedWordsFromArray:(NSArray*)words
 {
 NSMutableArray *filtered = [[NSMutableArray alloc]init];
 for(NSString *s in words) {
 
 NSString *niceString = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 if(niceString.length > 1 && niceString.length < 6){
 [filtered addObject:niceString];
 }
 }
 NSLog(@"count %i", filtered.count);
 return filtered;
 }
 */





NSLog(@"New combinations %@", combinations);

//From dictionary, core-data. Hardcoded
//[wView emphasizeStringsOfWords:[NSSet setWithObjects:@"HAJ", @"FÅR",@"RARA", nil]];




-(BOOL)canPieceBeSelected:(DTSPiece*)piece
{
    CGPoint ePos = [self emptyPosition].origin;
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



/*
 -(NSArray*)fetchWords:(NSArray*)words
 {
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@",
 arrayOfManagedObjectIDs];
 }
 */


@end
