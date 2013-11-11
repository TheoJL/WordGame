//
//  DTSWrestlerView.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSWrestlerView.h"
#import "DTSPiecesController.h"
#import "DTSTracesHandler.h"
#import "DTSMainSubView.h"
#import "DTSPieceView.h"
#import "DTSTraceView.h"
#import "DTSPiece.h"
#import "DTSTrace.h"


@interface DTSWrestlerView ()

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapDubbelRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapSingelRecognizer;


@property (nonatomic, strong) DTSPiecesController *pieceController;
@property (nonatomic, strong) DTSTracesHandler *tracesHandler;
@property (nonatomic, strong) DTSMainSubView *mainSubView;


@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfRowsInSections;

@end


@implementation DTSWrestlerView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addMoveRecognizer];
        [self addTapRecognizers];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addMoveRecognizer];
        [self addTapRecognizers];
        
    }
    return self;
}




#pragma mark - Custom Setters/Getters




-(DTSMainSubView *)mainSubView
{
    if(nil == _mainSubView){
        _mainSubView = [[DTSMainSubView alloc]initWithFrame:self.bounds];

        [self addSubview:_mainSubView];
        
    }
    return _mainSubView;
}


-(DTSPiecesController *)pieceController
{
    if(nil == _pieceController){
        _pieceController = [DTSPiecesController controllerWithSections:[self numberOfSections] rowsInSections:[self numberOfRowsInSections]];
    }
    return _pieceController;
}


-(DTSTracesHandler *)tracesHandler
{
    if(nil == _tracesHandler){
        _tracesHandler = [[DTSTracesHandler alloc]init];
    }
    return _tracesHandler;
}


-(NSInteger)numberOfSections
{
    if(0 == _numberOfSections){
        _numberOfSections = [[self datasource]numberOfSectionsInWrestlerView:self];
    }
    return _numberOfSections;
}


-(NSInteger)numberOfRowsInSections
{
    if(0 == _numberOfRowsInSections){
        _numberOfRowsInSections = [[self datasource]numberOfRowsForEachSectionInWrestlerView:self];
    }
    return _numberOfRowsInSections;
}


-(id<DTSWrestlerViewDelegate>)delegate
{
    if(nil == _delegate){
        NSAssert(NO, @"No delegate assign");
    }
    return _delegate;
}


-(id<DTSWrestlerViewDatasource>)datasource
{
    if(nil == _datasource){
        NSAssert(NO, @"No datasource assign");
    }
    return _datasource;
}




#pragma mark - Start/Add/Create




-(void)start
{
    [self addStartPieces];
    
    [[self mainSubView]addPieceViews:[[self pieceController]pieces]];
    
    if([[self delegate]respondsToSelector:@selector(wrestlerView:viewModifiedWithAddedLetterCombinations:)]){
        [_delegate wrestlerView:self viewModifiedWithAddedLetterCombinations:[[self pieceController]allWords]];
    }
}


-(void)addStartPieces
{
    for(int i = 0; i < [self numberOfSections]; i++){
        
        [self addStartPiecesInSection:i];
    }
}


-(void)addStartPiecesInSection:(NSInteger)section
{
    for(int i = 0; i < [self numberOfRowsInSections]; i++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        
        DTSPiece *piece = [[self datasource]wrestlerView:self pieceForRowAtIndexPath:indexPath];
        
        [[self pieceController]addPiece:piece indexPath:indexPath];
    }
}





#pragma mark - Gesture Recognizers
#pragma mark Move/Touch





-(void)addMoveRecognizer
{
    [self setMoveRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMove:)]];
   

    [[self moveRecognizer] setCancelsTouchesInView:NO];
    [self addGestureRecognizer:[self moveRecognizer]];
}


-(void)handleMove:(UIPanGestureRecognizer*)gr
{
    switch ([gr state]) {
        case UIGestureRecognizerStateChanged:
            
            [self dragChanged:[gr translationInView:self]];
            [gr setTranslation:CGPointZero inView:self];
            break;
            
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateEnded:
            [self dragEnded];
            break;
            
        case UIGestureRecognizerStateCancelled:
            [self dragEnded];
            break;
            
        default:
            break;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    DTSPiece *piece = [self pieceAtPoint:[touch locationInView:self]];
    
    BOOL success = [[self pieceController]selectPiece:piece];
    
    if(success && [[self delegate]respondsToSelector:@selector(wrestlerView:didSelectView:)]){
        [_delegate wrestlerView:self didSelectView:[piece pieceView]];
    }
}


-(void)dragBegan:(CGPoint)point
{
    //Code moved to touchesBegan
}


-(void)dragChanged:(CGPoint)point
{
    
    if(NO == [[self pieceController]updatePositionOfSelectedWithTranslation:point]){
        return;
    }
    
    DTSPiece *piece = [[self pieceController]selectedPiece];

    [[self mainSubView]updatePieceViewWithPiece:piece animation:NO];
}


-(void)dragEnded
{    
    DTSPiece *piece = [[self pieceController]selectedPiece];
    
    if(nil == piece){
        return;
    }
    
    BOOL moved = [[self pieceController]setSelectedToEmptySpace];

    [[self mainSubView]updatePieceViewWithPiece:piece animation:YES];
    
    if([[self delegate]respondsToSelector:@selector(wrestlerView:didReleaseView:changedPosition:)]){
        [_delegate wrestlerView:self didReleaseView:[piece pieceView] changedPosition:moved];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(afterMoved:) userInfo:nil repeats:NO];
}


-(void)afterMoved:(NSTimer*)timer
{
    [self removeUnvalidTraces];

    if([[self delegate]respondsToSelector:@selector(wrestlerView:viewModifiedWithAddedLetterCombinations:)]){
        [_delegate wrestlerView:self viewModifiedWithAddedLetterCombinations:[_pieceController wordsFromLastMove]];
    }
}




#pragma mark Tap/Dubbeltap




-(void)addTapRecognizers
{
    _tapSingelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(didSingelTap:)];
    _tapSingelRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:_tapSingelRecognizer];
    
    _tapDubbelRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(didDubbelTap:)];
    _tapDubbelRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_tapDubbelRecognizer];
    
    [_tapSingelRecognizer requireGestureRecognizerToFail:_tapDubbelRecognizer];
}


-(void)didSingelTap:(UITapGestureRecognizer*)gr
{
    //NSLog(@"didSingelTap");
}


-(void)didDubbelTap:(UITapGestureRecognizer*)gr
{
    DTSTrace *word = [self traceAtPoint:[gr locationInView:self]];
    
    if(NO == [self shouldReplaceWord:word]){
        return;
    }
    
    [self replaceWord:word];
    
    [self didReplaceWord:word userTriggered:YES];
}


-(void)replaceWord:(DTSTrace*)trace
{
    

    [[self pieceController]replaceWord:trace replacementPieces:[self piecesFromDelegateWithReplacingWord:trace] changedPieces:^(NSArray *removed, NSArray *added, NSArray *moved)
     {
         [[self mainSubView]updateViewsAtOnceWithDelay:0 removedPieces:removed updatedPieces:moved addedPieces:added
            removedBlock:^(BOOL start, BOOL done) {
            //Fix: Notify Delegate
               
          } updatedBlock:^(BOOL start, BOOL done) {
            //Fix: Notify Delegate
               
            } addedBlock:^(BOOL start, BOOL done) {
            //Fix: Notify Delegate
                            
            } completed:^(BOOL start, BOOL done) {
                if(done){
                    
                    if([[self delegate]respondsToSelector:@selector(wrestlerView:viewModifiedWithAddedLetterCombinations:)]){
                        [_delegate wrestlerView:self viewModifiedWithAddedLetterCombinations:[_pieceController allWords]];
                    }
                }
            }];
        }];
    
    [self removeUnvalidTraces];
}


-(NSArray*)piecesFromDelegateWithReplacingWord:(DTSTrace*)trace
{
    NSMutableArray *pieces = [NSMutableArray array];
    for (DTSPiece *retiredPiece in trace.pieces) {
        DTSPiece *piece = [[self datasource]wrestlerView:self pieceForReplacingPiece:retiredPiece];
        
        [pieces addObject:piece];
    }
    return pieces;
}




#pragma mark - Incomming Words




-(void)emphasizeStringsOfWords:(NSSet *)words
{
    NSArray *traces = [[self pieceController]tracesFromWords:words];
    NSArray *addedTraces = [[self tracesHandler]tracesNotAlreadyExistsFromAddingTraces:traces];
    
    [self traceViewsFromDatasourceWithTraces:addedTraces];
    [[self mainSubView]addTraceViews:addedTraces];
    [self removeUnvalidTraces];
}


-(void)traceViewsFromDatasourceWithTraces:(NSArray*)traces
{
    if(NO == [[self datasource]respondsToSelector:@selector(wrestlerView:overlayForWord:)]){
        return;
    }
    for (DTSTrace *trace in traces) {
        
        DTSTraceView *traceView = [_datasource wrestlerView:self overlayForWord:trace];
        [trace setTraceView:traceView];
        [traceView setTrace:trace];
    }
}



#pragma mark - Trigger All Words



-(void)triggerWordsWithCompletion:(void(^)(BOOL done))completion
{
    [self removeUnvalidTraces];

    NSArray *allTraces = [[self tracesHandler]tracesSortedByWordValues];
    
    __block int count = allTraces.count;

    for (DTSTrace *trace in allTraces) {
        
        if([self.tracesHandler.traces containsObject:trace] && [self shouldReplaceWord:trace]){
            
           [self triggerWord:trace completion:^(BOOL done) {
               if (done && --count <= 0)
                   completion(YES);
           }];
        }else
            count--;
    }
    if(count <= 0)
        completion(YES);
}


-(void)triggerWord:(DTSTrace*)trace completion:(void (^)(BOOL done))completion
{
    [[self pieceController]replaceWord:trace replacementPieces:[self piecesFromDelegateWithReplacingWord:trace] changedPieces:^(NSArray *removed, NSArray *added, NSArray *moved) {
       
        [[self mainSubView]highlightPieceViews:removed completion:^(BOOL start, BOOL done) {
            if(done)
                completion(YES);
        }];
    }];
    [self didReplaceWord:trace userTriggered:NO];

    [self removeUnvalidTraces];
}



#pragma mark - Reset All Views (temporary)



-(void)resetAllViews
{
    [[self mainSubView]removeFromSuperview];
    [self setMainSubView:nil];
    [[self mainSubView]addPieceViews:[[self pieceController]pieces]];
    [self setTracesHandler:nil];
    
    if([[self delegate]respondsToSelector:@selector(wrestlerView:viewModifiedWithAddedLetterCombinations:)]){
        [_delegate wrestlerView:self viewModifiedWithAddedLetterCombinations:[_pieceController allWords]];
    }
}



#pragma mark - Convenience




-(void)didReplaceWord:(DTSTrace*)word userTriggered:(BOOL)userTriggered
{
    if([[self delegate]respondsToSelector:@selector(wrestlerView:didReplaceWord:userTriggered:)]){
        [[self delegate]wrestlerView:self didReplaceWord:word userTriggered:userTriggered];
    }
}


-(BOOL)shouldReplaceWord:(DTSTrace*)trace
{
    BOOL hasSelector = [[self delegate]respondsToSelector:@selector(wrestlerView:shouldReplaceTappedWord:)];
    
    if(nil == trace){
        return NO;
    }
    
    return (hasSelector) ? [[self delegate]wrestlerView:self shouldReplaceTappedWord:trace] : YES;
}


-(void)removeUnvalidTraces
{
    NSArray *removed = [[self tracesHandler]tracesRemovedAfterCleaning];
    [[self mainSubView]removeTraceViews:removed];
}


-(DTSPiece*)pieceAtPoint:(CGPoint)point
{
    for(DTSPiece *piece in [[self pieceController]pieces]){
        
        if(CGRectContainsPoint([piece position], point)){
            return piece;
        }
    }
    return nil;
}


-(DTSTrace*)traceAtPoint:(CGPoint)point
{
    for(DTSTrace *trace in [[self tracesHandler]traces]){
        
        if(CGRectContainsPoint([trace position], point)){
            return trace;
        }
    }
    return nil;
}

@end
