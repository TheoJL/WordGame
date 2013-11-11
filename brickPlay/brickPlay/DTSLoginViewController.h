//
//  DTSLoginViewController.h
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-15.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *playerOneField;
@property (weak, nonatomic) IBOutlet UITextField *playerTwoField;



@end
