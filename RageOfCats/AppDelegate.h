//
//  AppDelegate.h
//  RageOfCats
//
//  Created by martin magalong on 12/10/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) FacebookManager *fbManager;

@end
