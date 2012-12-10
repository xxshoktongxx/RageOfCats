//
//  ViewController.m
//  RageOfCats
//
//  Created by martin magalong on 12/10/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    _fbManager = [appDelegate fbManager];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [_fbManager openSession];
    } else {
//        [_fbManager openSession]; //show login controller;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_fbManager openSession];
    [self performSelector:@selector(publish) withObject:nil afterDelay:5.0f];
}

- (void)publish{
    [_fbManager publishStory];
}

@end
