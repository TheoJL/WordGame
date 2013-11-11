//
//  DTSLoginViewController.m
//  brickPlay
//
//  Created by theodor lindgren on 2013-01-15.
//  Copyright (c) 2013 theodor lindgren. All rights reserved.
//

#import "DTSLoginViewController.h"
#import "DTSViewController.h"

@interface DTSLoginViewController ()

@end

@implementation DTSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /* ########### OVERRIDE ############ */

   // [self override];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1){
        [[self playerTwoField]becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self startGame];
    }
    return YES;
}


-(void)startGame
{
    if([[self playerOneField]text].length > 2 && [[self playerTwoField]text].length > 2){
        
        DTSViewController *vc = [[DTSViewController alloc]initWithPlayerOne:self.playerOneField.text playerTwo:self.playerTwoField.text];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO" message:@"Must be valid names" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)override
{
    DTSViewController *vc = [[DTSViewController alloc]initWithPlayerOne:@"Urban" playerTwo:@"Utte"];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
