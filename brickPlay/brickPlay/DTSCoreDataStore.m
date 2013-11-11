//
//  DTSCoreDataStore.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-08.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSCoreDataStore.h"
#import <CoreData/CoreData.h>

typedef void(^coreDataCountBlock)(NSUInteger count);

@interface DTSCoreDataStore ()

@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;


@end

@implementation DTSCoreDataStore





+(id)shared
{
    static DTSCoreDataStore *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
        [shared setupStore];
    });
    
    return shared;
}



#pragma mark - Setup




-(void)setupStore
{
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSURL *storeURL = [NSURL fileURLWithPath:[self dataArchivePath]];
    
    NSPersistentStoreCoordinator *pcs = [self storeCoordinatorWithModel:_model url:storeURL];
    
    _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainContext setPersistentStoreCoordinator:pcs];
    [_mainContext setUndoManager:nil];
    
    _privateContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_privateContext performBlock:^{
        [_privateContext setParentContext:_mainContext];
        [_privateContext setUndoManager:nil];
    }];
    
    
}


-(NSPersistentStoreCoordinator*)storeCoordinatorWithModel:(NSManagedObjectModel*)model url:(NSURL*)storeURL
{
    NSPersistentStoreCoordinator *pcs = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSError *error;
    
    if(nil == [pcs addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                          URL:storeURL
                                      options:nil
                                        error:&error]){
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    

    
    return pcs;
}




#pragma mark - Custom Fetches 




-(id)insertNewObjectWithEnityName:(NSString*)entityName
{
    
    id manageObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self mainContext]];

    return manageObject;
}


-(void)fetchAvailableWords:(NSArray*)words completion:(void (^)(NSArray* availableWords))completion
{
    NSMutableArray *availableWords = [NSMutableArray array];
    NSPredicate *predicate;
    __block int fetches = words.count;
    
    for (NSString *word in words) {
        
        predicate = [NSPredicate predicateWithFormat:@"word == %@", [word lowercaseString]];

        [self fetchCountWithEntity:@"Words" predicate:predicate completion:^(NSUInteger count) {
            
            if(count > 0){
                [availableWords addObject:[word uppercaseString]];
            }
            if(--fetches == 0){
                completion(availableWords);
            }
        }];
    }
}






#pragma mark - General Fetches 






-(NSArray *)fetchWithEntity:(NSString *)entity predicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sort limit:(NSInteger)limit error:(NSError**)error
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
         
    [request setSortDescriptors:sort];
    
    [request setPredicate:predicate];
    
    if(limit > 0)
        [request setFetchLimit:limit];
    
    return [[self mainContext] executeFetchRequest:request error:error];
}


-(void)fetchCountWithEntity:(NSString*)entity predicate:(NSPredicate*)predicate completion:(coreDataCountBlock)completion
{
    __block NSUInteger count;
    
    [[self privateContext]performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entity];
        
        [request setIncludesSubentities:NO];
        [request setPredicate:predicate];
        
        NSError *error;
        count  = [_privateContext countForFetchRequest:request error:&error];
        
        [_mainContext performBlock:^{
            if(count == NSNotFound)
                completion(0);
            
            completion(count);
        }];
    }];
}




-(void)saveContext
{
    
    [[self mainContext]save:nil];
}
 








#pragma mark - Paths



-(NSString*)dataArchivePath
{
    return [self archivePathWithKey:@"data.archive"];
}

-(NSString *)archivePathWithKey:(NSString*)key
{
    NSArray *documentDirectorys = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectorys objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
