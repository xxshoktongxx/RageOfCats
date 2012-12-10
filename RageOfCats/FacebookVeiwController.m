//
//  FacebookVeiwController.m
//  FacebookTest
//
//  Created by martin magalong on 12/8/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import "FacebookVeiwController.h"


@implementation FacebookVeiwController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake (0,0,320,480);
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Post" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button1.frame = CGRectMake(0, 0, 30, 30);
    [button1 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = buttonDone;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Cancel" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button2.frame = CGRectMake(0, 0, 30, 30);
    [button2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10,10,300,150)];
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
}

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done{
    _parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"http://google.com",@"link",
    @"", @"picture",
    @"", @"name",
    @"", @"caption",
    _textView.text, @"description",
    @"125165664210637",@"place",nil];
    [self.delegate _didPost:_parameters];
}
@end
