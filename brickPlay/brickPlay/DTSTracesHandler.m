//
//  DTSTracesHandler.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-05.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSTracesHandler.h"
#import "DTSTrace.h"
#import "DTSPiece.h"
@interface DTSTracesHandler ()

@property (nonatomic, strong) NSMutableSet *traces;

@end

@implementation DTSTracesHandler


#pragma mark - Custom Getters/Setters


-(NSMutableSet *)traces
{
    if(nil == _traces){
        _traces = [[NSMutableSet alloc]init];
    }
    return _traces;
}




#pragma mark - Add traces




-(NSArray*)tracesNotAlreadyExistsFromAddingTraces:(NSArray *)traces
{
    NSMutableArray *added = [NSMutableArray array];
    for (DTSTrace *trace in traces) {
        if(NO == [[self traces]containsObject:trace]){
            [added addObject:trace];
        }
    }
    [[self traces]addObjectsFromArray:added];

    return added;
}



#pragma mark - Remove traces



-(NSArray*)tracesRemovedAfterCleaning
{
    NSMutableArray *removed = [NSMutableArray array];
    
    [removed addObjectsFromArray:[self removedTracesContainingMovedPiece]];
    
    [removed addObjectsFromArray:[self removedTracesContainedInExistingTrace]];
    

    return removed;
}



-(NSArray*)removedTracesContainedInExistingTrace
{
    NSMutableArray *removed = [NSMutableArray array];
    NSMutableArray *sorted = [[self tracesSortedByWordValues]mutableCopy];
    
    for(DTSTrace *trace in sorted){
        if([self isTraceContainedInExistingTraces:trace]){
            [removed addObject:trace];
            [[self traces]removeObject:trace];
        }
    }
    return removed;
}


-(BOOL)isTraceContainedInExistingTraces:(DTSTrace*)trace
{
    for (DTSTrace *t in [self traces]) {
        if (t == trace) 
            continue;
        
        if(CGRectContainsRect(t.position, trace.position)){
            return YES;
        }
    }
    return NO;
}


-(NSArray*)removedTracesContainingMovedPiece
{
    NSMutableArray *remove = [NSMutableArray array];
    
    for (DTSTrace *trace in [self traces]) {
        
        if(NO == [self rectContainsPieces:[trace position] pieces:[trace pieces]]){
            
            [remove addObject:trace];
        }
    }
    [self removeTracesInArray:remove];

    return remove;
}


-(BOOL)rectContainsPieces:(CGRect)rect pieces:(NSArray*)pieces
{
    BOOL contains = YES;
    for (DTSPiece *piece in pieces) {
        if([piece isDeleted] || NO == CGRectContainsPoint(rect, [piece position].origin)){
            contains = NO;
        }
    }
    return contains;
}


-(void)removeTracesInArray:(NSArray*)traces
{
    for (DTSTrace *trace in traces) {
        [[self traces]removeObject:trace];
    }
}



#pragma mark - Traces



-(NSArray*)tracesSortedByWordValues
{
    NSArray *allTraces = [[self traces]allObjects];
    NSArray *sortedArray = [allTraces sortedArrayUsingComparator:^(id b, id a) {
        DTSTrace *t1 = (DTSTrace *)a;
        DTSTrace *t2 = (DTSTrace *)b;
        
        NSComparisonResult result = [t1.wordLength compare:t2.wordLength];
        if (result == NSOrderedSame) {
            result = [t1.wordValue compare:t2.wordValue];
        }
        return result;
    }];
    
    return sortedArray;
}



#pragma mark - Convenience


@end
