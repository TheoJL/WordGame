//
//  DTSAppDelegate.h
//  brickPlay
//
//  Created by theodor lindgren on 2012-12-23.
//  Copyright (c) 2012 theodor lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTSViewController;

@interface DTSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DTSViewController *viewController;

@end
