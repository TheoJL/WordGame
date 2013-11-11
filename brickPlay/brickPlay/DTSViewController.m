//
//  DTSViewController.m
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import "DTSViewController.h"
#import "DTSCoreDataStore.h"
#import "DTSBrickPlayStore.h"
#import "DTSWrestlerView.h"
#import "DTSPieceView.h"
#import "DTSPiece.h"
#import "DTSTrace.h"

@interface DTSViewController ()

@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSString *replacements;
@property (nonatomic, strong) NSDictionary *values;

@property (nonatomic) NSInteger currentPoints;
@property (nonatomic) NSInteger roundCount;
@property (nonatomic) NSInteger turnCount;
@property (nonatomic) NSInteger maxTurns;
@property (nonatomic) NSInteger maxRounds;

@property (nonatomic, strong) NSString *player1;
@property (nonatomic, strong) NSString *player2;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic) BOOL isPlayerTwoTurn;


@end

@implementation DTSViewController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithPlayerOne:nil playerTwo:nil];
}


-(id)initWithPlayerOne:(NSString*)pl1 playerTwo:(NSString*)pl2
{
    if(self = [super initWithNibName:nil bundle:nil]){
        _player1 = pl1;
        _player2 = pl2;
        
        [DTSBrickPlayStore sharedStore];

        [self setupCustomInitialisation];
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self updatePlayerNames];
    [self setRoundCountToNumber:0];
    
    [[self wrestlerView] start];
}



#pragma mark - Custom Initialisation



-(void)setupCustomInitialisation
{
    _maxRounds  = 1000;
    _maxTurns   = 30;
    _replacements = @"JASDRTAFÅVMVLSDFKJFSKJHUUFSJKDNVSKNXNVNVJFLASKJDFIRJLGPEKADOPKEAFASFAALDKFFSAFDFJGKRJGAIRJTIJITTKTKNVANASNSAFALÖSKDFÖLSKFJIJRIJGTUASGJAJSLGJAÖSFKPAOSKFOKOIAJGAGÖASGÖASJGKASJGASJFOAIFJAIS";
    
    _letters =
    @[
    @[@"A",@"I",@"U",@"E",@"A"],
    @[@"M",@"S",@"F",@"Å",@"Å"],
    @[@"B",@"E",@"-",@"E",@"W"],
    @[@"A",@"B",@"J",@"O",@"S"],
    @[@"I",@"M",@"J",@"P",@"T"]
    ];
    
    _values = @{
    @"A" : @(3),
    @"B" : @(2),
    @"C" : @(2),
    @"D" : @(3),
    @"E" : @(3),
    @"F" : @(3),
    @"G" : @(2),
    @"H" : @(2),
    @"I" : @(3),
    @"J" : @(2),
    @"K" : @(2),
    @"L" : @(1),
    @"M" : @(3),
    @"N" : @(2),
    @"O" : @(2),
    @"P" : @(2),
    @"Q" : @(1),
    @"R" : @(2),
    @"S" : @(3),
    @"T" : @(3),
    @"U" : @(1),
    @"V" : @(4),
    @"X" : @(6),
    @"Y" : @(2),
    @"Z" : @(4),
    @"Å" : @(5),
    @"Ä" : @(3),
    @"Ö" : @(5)
    };
}



#pragma mark - WW Datasource



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
    NSString *title = _letters[indexpath.section][indexpath.row];
    NSString *value = [NSString stringWithFormat:@"%i", [[_values objectForKey:title]intValue]];

    return [DTSPiece pieceWithTitle:title value:value];
}




#pragma mark - WW Delegate




-(void)wrestlerView:(DTSWrestlerView *)wView didReleaseView:(DTSPieceView *)pieceView changedPosition:(BOOL)changed
{
    if(changed){
        [self setTurnCountToNumber:++_turnCount];
        [self endRoundIfUserRunOutOfTurns];
    }
}


-(void)wrestlerView:(DTSWrestlerView *)wView viewModifiedWithAddedLetterCombinations:(NSSet *)combinations
{
    [[DTSCoreDataStore shared]fetchAvailableWords:[combinations allObjects] completion:^(NSArray *availableWords) {
        
        [wView emphasizeStringsOfWords:[NSSet setWithArray:availableWords]];
    }];
}


-(DTSPiece *)wrestlerView:(DTSWrestlerView *)wView pieceForReplacingPiece:(DTSPiece *)piece
{
    static int test = 0;
    NSString *title = [_replacements substringWithRange:NSMakeRange(++test, 1)];
    NSString *value = [NSString stringWithFormat:@"%i", [[_values objectForKey:title]intValue]];
    
    return [DTSPiece pieceWithTitle:title value:value];
}


-(void)wrestlerView:(DTSWrestlerView *)wView didReplaceWord:(DTSTrace *)word userTriggered:(BOOL)usrTriggd
{
    _currentPoints += [self calculateValueOfWord:word];
    [[self pointsLabel]setText:[NSString stringWithFormat:@"%i", _currentPoints]];
}




#pragma mark - Convenience





-(NSInteger)calculateValueOfWord:(DTSTrace*)word
{
    NSInteger sum = 0;
    for (DTSPiece* piece in [word pieces]) {
        sum += piece.value.intValue;
    }
    return sum;
}


-(void)endRoundIfUserRunOutOfTurns
{
    if(_turnCount >= _maxTurns){
        [[self wrestlerView]setUserInteractionEnabled:NO];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(triggerWords) userInfo:nil repeats:NO];
    }
}






#pragma mark - Temporary "Offline Game" Methods






-(void)triggerWords
{
    __weak DTSViewController *weakSelf = self;
    [[self wrestlerView]triggerWordsWithCompletion:^(BOOL done) {
        [weakSelf updateUsersAfterRound];
        [[self wrestlerView]setUserInteractionEnabled:YES];
    }];
}


-(void)updateUsersAfterRound
{
    [self notifyUserAboutScores];
    if(_isPlayerTwoTurn){
        [self setRoundCountToNumber:++_roundCount];
    }
    [self setTurnCountToNumber:0];
    [self addPointsToCurrentPlayer];
    [self updatePlayerNames];
    [[self pointsLabel]setText:@"0"];
    self.currentPoints = 0;
    [[self wrestlerView]resetAllViews];
}


-(void)setTurnCountToNumber:(NSInteger)number
{
    _turnCount = number;
    NSInteger value = _maxTurns - _turnCount;

    [[self turnsLabel]setText:[NSString stringWithFormat:@"%i",value]];
}


-(void)setRoundCountToNumber:(NSInteger)number
{
    _roundCount = number;
    NSInteger value = _maxRounds - _roundCount;
    if(value == 0)
        [self weHaveAWinner];
    
    [[self roundsLabel]setText:[NSString stringWithFormat:@"Rounds left %i", value]];
}


-(void)weHaveAWinner
{
    NSString *message = @"%@ is one-in-a-million! %@ scores %i and thats amazing!";

    if([[self playerOneScore]text].intValue > [[self playerTwoScore]text].intValue)
        message = [NSString stringWithFormat:message, _player1, _player1,_playerOneScore.text.intValue];
    else
        message = [NSString stringWithFormat:message, _player2, _player2,_playerTwoScore.text.intValue];
    
    [_alert setTitle:@"WINNER!"];
    [_alert setMessage:message];
    [_alert setDelegate:self];
}


-(void)notifyUserAboutScores
{
    NSString *message = @"%@ got %i points this round. Now it's %@'s turn.";
    if(_isPlayerTwoTurn)
        message = [NSString stringWithFormat:message, _player2,_currentPoints,_player1];
    else
        message = [NSString stringWithFormat:message, _player1,_currentPoints,_player2];
    
    NSString *round = [NSString stringWithFormat:@"Round %i", _roundCount+1];
    
    _alert = [[UIAlertView alloc]initWithTitle:round message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [_alert show];
}


-(void)addPointsToCurrentPlayer
{
    static NSInteger plyr1Score = 0;
    static NSInteger plyr2Score = 0;
    
    if(_isPlayerTwoTurn){
        plyr2Score += self.currentPoints;
        [[self playerTwoScore]setText:[NSString stringWithFormat:@"%i", plyr2Score]];
        self.isPlayerTwoTurn = NO;
    }else{
        plyr1Score += self.currentPoints;
        [[self playerOneScore]setText:[NSString stringWithFormat:@"%i", plyr1Score]];
        self.isPlayerTwoTurn = YES;
    }
}


-(void)updatePlayerNames
{   //temporary
    [[self playerOneNameLabel]setText:[self player1]];
    [[self playerTwoNameLabel]setText:[self player2]];
    
    [[self playerOneNameLabel]setTextColor:(_isPlayerTwoTurn)?[UIColor grayColor]:[UIColor whiteColor]];
    [[self playerTwoNameLabel]setTextColor:(_isPlayerTwoTurn)?[UIColor whiteColor]:[UIColor grayColor]];
    [[self playerOneScore]setTextColor:(_isPlayerTwoTurn)?[UIColor grayColor]:[UIColor whiteColor]];
    [[self playerTwoScore]setTextColor:(_isPlayerTwoTurn)?[UIColor whiteColor]:[UIColor grayColor]];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
