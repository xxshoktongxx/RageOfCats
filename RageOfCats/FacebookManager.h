//
//  FacebookManager.h
//  FacebookTest
//
//  Created by martin magalong on 11/30/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
//#import "FacebookVeiwController.h"

@interface FacebookManager : NSObject</*FBviewControllerProtocol,*/FBDialogDelegate>{
    NSMutableDictionary *_tempParam;
//    FacebookVeiwController *_controller;
    Facebook *_facebook;
}
@property (strong, nonatomic) FBSession *session;
+ (FacebookManager *)sharedInstance;
- (BOOL)isAuthenticated;
//- (void)getNearBy:(NSDictionary *)param callback:(void(^)(id))callback;
- (void)openSession;
- (void)closeSession;
- (void)publishStory;
@end

