//
//  DTSViewController.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSWrestlerViewDelegate.h"
#import "DTSWrestlerViewDatasource.h"

@class DTSWrestlerView;
@interface DTSViewController : UIViewController <DTSWrestlerViewDelegate, DTSWrestlerViewDatasource, UIAlertViewDelegate>

-(id)initWithPlayerOne:(NSString*)pl1 playerTwo:(NSString*)pl2;

@property (weak, nonatomic) IBOutlet DTSWrestlerView *wrestlerView;

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnsLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundsLabel;



@property (weak, nonatomic) IBOutlet UILabel *playerOneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerOneScore;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoScore;


@end
