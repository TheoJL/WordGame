//
//  DTSPiecesController.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-28.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSPiecesController.h"
#import "DTSPiece.h"
#import "DTSSelected.h"
#import "DTSRecap.h"
#import "DTSTrace.h"


@interface DTSPiecesController ()

@property (nonatomic, strong) DTSSelected *selected;
@property (nonatomic, strong) DTSPiece *empty;
@property (nonatomic, strong) DTSRecap *recap;
@property (nonatomic, strong) NSMutableSet *pieces;

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger margin;
@property (nonatomic) NSInteger minWordLength;
@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfRowsInSections;


@end

@implementation DTSPiecesController

- (id)init
{
    if(self = [super init]){
        
        [self setupCustomInitialisation];
    }
    return self;
}


+(id)controllerWithSections:(NSInteger)sections rowsInSections:(NSInteger)rowsInSections
{
    DTSPiecesController *controller = [[DTSPiecesController alloc]init];
    [controller setNumberOfSections:sections];
    [controller setNumberOfRowsInSections:rowsInSections];
    
    return controller;
}



#pragma mark - Custom Initialisation



-(void)setupCustomInitialisation
{
    _width  = 60;
    _height = 60;
    _margin = 4;
    _minWordLength = 3;
}



#pragma mark - Custom Setters/Getters



-(NSMutableSet *)pieces
{
    if(nil == _pieces){
        _pieces = [NSMutableSet set];
    }
    
    return _pieces;
}

-(DTSSelected *)selected
{
    if(nil == _selected){
        _selected = [DTSSelected selectedWithPiecesSize:CGSizeMake(_width, _height) margin:_margin];
    }
    return _selected;
}

-(DTSRecap *)recap
{
    if(nil == _recap){
        _recap = [DTSRecap recapWithFieldPosition:CGPointMake(0, 0) margin:_margin];
    }
    return _recap;
}




#pragma mark - Add Pieces




-(BOOL)addPiece:(DTSPiece*)piece indexPath:(NSIndexPath*)idxPath
{
    CGRect position = CGRectMake((_width+_margin)*idxPath.row, (_height+_margin)*idxPath.section, _width, _height);
    
    [piece setPosition:position];
    
    if([[piece title]isEqualToString:@"-"]){
        [self setEmpty:piece];
    }else{
        [[self pieces]addObject:piece];
    }
    
    return YES;
}




#pragma mark - Select




-(BOOL)selectPiece:(DTSPiece*)piece
{
    return [[self selected]selectPiece:piece emptyPosition:[[self empty]position]];
}


#pragma mark - Select update



-(BOOL)setSelectedToEmptySpace
{
    BOOL moved = [[self selected]moveToEmptySpace:[[self empty]position]];
    
    if(NO == moved){
        return NO;
    }
    
    [[self recap]movedFromPosition:[_selected outsetRect] toPosition:[[self empty]position]];
    [[self empty]setPosition:[_selected outsetRect]];
    
    
    return YES;
}


-(BOOL)updatePositionOfSelectedWithTranslation:(CGPoint)point
{
    return [[self selected]updatePositionWithTranslation:point];
}



#pragma mark - Deliver Potential Words




-(NSSet*)wordsFromLastMove
{
    if(NO == [[self recap]isNotEmpty]){
        return nil;
    }
    
    return [self wordsWithHorizontalRange:[[self recap]affectedHorizontalSections]
                            verticalRange:[[self recap]affectedVerticalSections]];
}


-(NSSet*)allWords
{
    NSRange vRange = NSMakeRange(0, _numberOfSections);
    NSRange hRange = NSMakeRange(0, _numberOfRowsInSections);
    
    return [self wordsWithHorizontalRange:hRange verticalRange:vRange];
}


-(NSSet*)wordsWithHorizontalRange:(NSRange)hRange verticalRange:(NSRange)vRange
{
    NSMutableSet *wordsHorizontal = [self wordsFromLetters:[self sortedPiecesByHorizontal] vertical:NO sectionRange:vRange];
    NSMutableSet *wordsVertical = [self wordsFromLetters:[self sortedPiecesByVertical] vertical:YES sectionRange:hRange];
    [wordsHorizontal unionSet:wordsVertical];

    return wordsHorizontal;
}


-(NSMutableSet*)wordsFromLetters:(NSArray*)letters vertical:(BOOL)vertical sectionRange:(NSRange)r
{
    NSMutableSet *set = [[NSMutableSet alloc]init];
    int maxLen = (vertical) ? [self numberOfSections] : [self numberOfRowsInSections];
    int limit = (r.location + r.length <= maxLen) ? maxLen * (r.length + r.location) : 0;
    for(int start = (r.location * maxLen) ; start < limit; start += maxLen){
        
        for (int j = 0; j < maxLen; j++) {

            for (int k = 0; k < maxLen; k++) {
                
                NSMutableArray *arr = [[NSMutableArray alloc]init];

                for (int l = j; l < maxLen-k; l++) {
                    
                    [arr addObject:[(DTSPiece*)letters[start+l] title]];
                }
                [self addLettersAsWordToSet:set letters:arr];
            }
        }
    }
    return set;
}


-(void)addLettersAsWordToSet:(NSMutableSet*)set letters:(NSArray*)letters
{
    if(letters.count >= _minWordLength ){
        NSString *s = [letters componentsJoinedByString:@""];
        if([s rangeOfString:@"-"].location == NSNotFound)
            [set addObject:s];
    }
}





#pragma mark - Traces from words





-(NSArray *)tracesFromWords:(NSSet *)words
{
    NSArray *hSorted = [self sortedPiecesByHorizontal];
    NSArray *vSorted = [self sortedPiecesByVertical];

    NSMutableArray *traces = [self tracesFromWords:words pieces:hSorted section:_numberOfRowsInSections];
    [traces addObjectsFromArray:[self tracesFromWords:words pieces:vSorted section:_numberOfSections]];
    

    return traces;
}


-(NSMutableArray*)tracesFromWords:(NSSet *)words pieces:(NSArray *)pieces section:(NSInteger)section
{
    NSMutableArray *traces = [[NSMutableArray alloc]init];
    
    NSString *joinedLetters = [self joinedLettersFromPieces:pieces];
    
    for(NSString *word in words){
        
        for (int i = 0; i < pieces.count; i += section) {
            
            NSString *haystack = [joinedLetters substringWithRange:NSMakeRange(i, section)];
            DTSTrace * trace = [self traceWord:word haystack:haystack pieces:pieces section:i];
            
            if(trace)
                [traces addObject:trace];;
        }
     }
    return traces;
}


-(DTSTrace*)traceWord:(NSString*)word haystack:(NSString*)haystack pieces:(NSArray*)pieces section:(NSInteger)section 
{
    NSRange range = [haystack rangeOfString:word];
    if(range.location == NSNotFound){
        return nil;
    }
    range.location += section;
    
    return [DTSTrace traceWithWord:word pieces:[pieces objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
}





#pragma mark - Replace pieces





-(void)replaceWord:(DTSTrace*)trace replacementPieces:(NSArray *)pieces changedPieces:(changedPiecesBlock)changedPieces
{
    if([trace isVertical]){
        [self replaceVerticalWord:trace replacementPieces:pieces changedPieces:changedPieces];
    }else{
        [self replaceHorizontalWord:trace replacementPieces:pieces changedPieces:changedPieces];
    }
}


-(void)replaceHorizontalWord:(DTSTrace*)trace replacementPieces:(NSArray*)replacements changedPieces:(changedPiecesBlock)changedPieces
{
    CGRect tracePos = [trace position];
    
    NSPredicate *movePredicate = [NSPredicate predicateWithBlock:^BOOL(DTSPiece *evaluatedObject, NSDictionary *bindings) {
        CGRect r = evaluatedObject.position;
        
        if (r.origin.y+1 < tracePos.origin.y && r.origin.x+1 > tracePos.origin.x && r.origin.x-1 < tracePos.origin.x+tracePos.size.width) {
            return YES;
        }
        return NO;
    }];
    NSArray *move = [[self allPiecesWithEmpty] filteredArrayUsingPredicate:movePredicate];
    
    [self manhandlePositionsInAddPieces:replacements movePieces:move removePieces:[trace pieces] vertical:NO];
    
    changedPieces([trace pieces], replacements, [self sortPiecesByHorizontalInArray:move]);
}


-(void)replaceVerticalWord:(DTSTrace*)trace replacementPieces:(NSArray*)replacements changedPieces:(changedPiecesBlock)changedPieces
{
    CGRect tracePos = trace.position;

    NSPredicate *movePredicate = [NSPredicate predicateWithBlock:^BOOL(DTSPiece *evaluatedObject, NSDictionary *bindings) {
        CGRect r = evaluatedObject.position;
        if (fabsf(r.origin.x - tracePos.origin.x) < 0.0001 && r.origin.y < tracePos.origin.y) {
            return YES;
        }
        return NO;
    }];
    
    NSArray *move = [[self allPiecesWithEmpty] filteredArrayUsingPredicate:movePredicate];
    [self manhandlePositionsInAddPieces:replacements movePieces:move removePieces:[trace pieces] vertical:YES];

    changedPieces([trace pieces], replacements, [self sortPiecesByHorizontalInArray:move]);
}


-(void)manhandlePositionsInAddPieces:(NSArray*)add movePieces:(NSArray*)move removePieces:(NSArray*)remove vertical:(BOOL)vertical
{
    [self addYValueToPieces:move value:(vertical)? remove.count * (_height +_margin): _height +_margin];
    
    [self shiftPiecesPositionsFromPieces:remove toPieces:add];
    
    [self changeYValueToPieces:add startValue:0 increaseForEachPiece:(vertical)?(_height +_margin):0];
    
    [self removePiecesInArray:remove];
    
    [[self pieces]addObjectsFromArray:add];
}


-(void)addYValueToPieces:(NSArray*)pieces value:(NSInteger)value
{
    for(DTSPiece *piece in pieces){
        CGRect pos = piece.position;
        pos.origin.y += value;
        [piece setPosition:pos];
    }
}


-(void)changeYValueToPieces:(NSArray*)pieces startValue:(NSInteger)startValue increaseForEachPiece:(NSInteger)increase
{
    for (int i = 0; i < pieces.count; i++) {
        
        DTSPiece *piece = pieces[i];
        CGRect position = [piece position];
        position.origin.y = startValue + i * increase;
        [piece setPosition:position];
    }
}

-(void)shiftPiecesPositionsFromPieces:(NSArray*)fromPieces toPieces:(NSArray*)toPieces
{
    for(int i = 0; i < MIN(fromPieces.count, toPieces.count); i++){
        DTSPiece *fromPiece = fromPieces[i];
        DTSPiece *toPiece = toPieces[i];

        CGRect fromPosition = fromPiece.position;
        [toPiece setPosition:fromPosition];
    }
}





#pragma mark - Convenience



-(DTSPiece*)selectedPiece
{
    return [[self selected]piece];
}


-(NSString*)joinedLettersFromPieces:(NSArray*)pieces
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for(DTSPiece *p in pieces){
        [arr addObject:[p title]];
    }
    
    return [arr componentsJoinedByString:@""];
}


-(NSArray*)allPiecesWithEmpty
{
    NSMutableArray *arr = [[[self pieces]allObjects]mutableCopy];
    [arr addObject:[self empty]];
    return arr;
}


-(void)removePiecesInArray:(NSArray*)pieces
{
    NSMutableSet *allPieces = [self pieces];
    for (DTSPiece *piece in pieces) {
        [allPieces removeObject:piece];
        [piece setIsDeleted:YES];
    }
}


-(NSArray*)sortedPiecesByVertical
{
    return [self sortPiecesWithComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(DTSPiece*)a sortNumberVertical];
        NSNumber *second = [(DTSPiece*)b sortNumberVertical];
        
        return [first compare:second];
    }];

}


-(NSArray*)sortedPiecesByHorizontal
{

    return [self sortPiecesWithComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(DTSPiece*)a sortNumberHorizontal];
        NSNumber *second = [(DTSPiece*)b sortNumberHorizontal];
        
        return [first compare:second];
    }];
}


-(NSArray*)sortPiecesWithComparator:(NSComparator)comparator
{
    NSMutableArray *pieces = [[[self pieces]allObjects]mutableCopy];
    [pieces addObject:[self empty]];
    
    NSArray *sortedArray;
    sortedArray = [pieces sortedArrayUsingComparator:comparator];
    
    return sortedArray;
}

//TEST
-(NSArray*)sortPiecesByHorizontalInArray:(NSArray*)pieces
{
    NSArray *sortedArray;
    sortedArray = [pieces sortedArrayUsingComparator:^NSComparisonResult(id b, id a) {
        NSNumber *first = [(DTSPiece*)a sortNumberHorizontal];
        NSNumber *second = [(DTSPiece*)b sortNumberHorizontal];
        
        return [first compare:second];
    }];
    
    return sortedArray;
}




@end
