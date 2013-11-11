//
//  DTSPiecesViewController.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSPiecesViewController.h"
#import "DTSPiece.h"
#import "DTSPieceView.h"
#import "DTSPiecesController.h"
#import "DTSTrace.h"
#import "DTSWrestlerView.h"

@interface DTSPiecesViewController ()

@property (nonatomic, strong) NSArray *letters;




@end

@implementation DTSPiecesViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
 
    _letters =
    @[
    @[@"A",@"I",@"U",@"E",@"F"],
    @[@"G",@"T",@"F",@"Å",@"R"],
    @[@"Y",@"U",@"-",@"E",@"A"],
    @[@"H",@"A",@"J",@"O",@"R"],
    @[@"I",@"Z",@"Å",@"P",@"A"]
    ];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    DTSWrestlerView *ww = [[DTSWrestlerView alloc]initWithFrame:[[self view]bounds]];
    
    [[self view]addSubview:ww];
    
    [ww setDatasource:self];
    [ww setDelegate:self];
    
    
    [ww start];
}



-(NSInteger)numberOfRowsForEachSectionInWrestlerView:(DTSWrestlerView *)wrestlerView
{
    return 5;
}


-(NSInteger)numberOfSectionsInWrestlerView:(DTSWrestlerView *)wrestlerView
{
    return 5;
}


-(DTSPiece *)wrestlerView:(DTSWrestlerView *)wView pieceForRowAtIndexPath:(NSIndexPath *)indexpath
{
    return [DTSPiece pieceWithTitle:_letters[indexpath.section][indexpath.row]];
}


-(void)wrestlerView:(DTSWrestlerView *)wView didSelectView:(DTSPieceView *)pieceView
{
    //NSLog(@"Did select %@ ", [[pieceView piece]title]);
}


-(void)wrestlerView:(DTSWrestlerView *)wView didReleaseView:(DTSPieceView *)pieceView changedPosition:(BOOL)changed
{
    //NSLog(@"Did release %@. Changed %i", [[pieceView piece]title], changed);
}


-(void)wrestlerView:(DTSWrestlerView *)wView viewModifiedWithAddedLetterCombinations:(NSSet *)combinations
{
    //NSLog(@"New combinations %@", combinations);

    //From dictionary, core-data. Hardcoded
    [wView emphasizeStringsOfWords:[NSSet setWithObjects:@"HAJ", @"FÅR",@"RARA", nil]];

}


-(DTSPiece *)wrestlerView:(DTSWrestlerView *)wView pieceForReplacingPiece:(DTSPiece *)piece
{
    return [DTSPiece pieceWithTitle:@"M"];
}






#pragma mark - Convenience










@end
