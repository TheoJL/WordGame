//
//  DTSBrickPlayStore.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSBrickPlayStore.h"
#import "DTSCoreDataStore.h"
#import "Words.h"
@interface DTSBrickPlayStore()

@property (nonatomic, strong) NSManagedObjectModel *model;

@end
@implementation DTSBrickPlayStore

- (id)init
{
    self = [super init];
    if (self) {
        [self start];
    }
    return self;
}

+(id)sharedStore
{
    static DTSBrickPlayStore *sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]init];
        
    });
    
    return sharedStore;
}


-(void)start
{
    BOOL inserted = [[NSUserDefaults standardUserDefaults]boolForKey:@"insertedRootWordsKey"];
    
    if(NO == inserted){
        [self insertRootWords];
        [[DTSCoreDataStore shared] saveContext];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"insertedRootWordsKey"];
    }

}


-(void)insertRootWords
{
    NSArray *root = [self wordsFromFile];
    
    for(NSString *word in root){
        Words *mo = [[DTSCoreDataStore shared]insertNewObjectWithEnityName:@"Words"];
        [mo setWord:word];
    }
}


 
 -(NSArray*)wordsFromFile
 {
     NSString* filePath = @"saol13";
     NSString* fileRoot = [[NSBundle mainBundle]
                           pathForResource:filePath ofType:@"txt"];
 
     
     NSString* fileContents =
     [NSString stringWithContentsOfFile:fileRoot
                               encoding:NSUTF8StringEncoding error:nil];
 
 
     NSArray* allLinedStrings =
     [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
 
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
 


@end
