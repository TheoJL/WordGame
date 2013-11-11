//
//  DTSWrestlerView.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-02.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSWrestlerViewDelegate.h"
#import "DTSWrestlerViewDatasource.h"

@class DTSTrace;
@interface DTSWrestlerView : UIView



@property (nonatomic, copy, readonly) NSSet *pieces;

@property (nonatomic, weak) IBOutlet id <DTSWrestlerViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <DTSWrestlerViewDatasource> datasource;

-(void)start;

-(void)emphasizeStringsOfWords:(NSSet*)words;

-(void)triggerWordsWithCompletion:(void(^)(BOOL done))completion;



-(void)resetAllViews;


@end
