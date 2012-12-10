//
//  FacebookManager.m
//  FacebookTest
//
//  Created by martin magalong on 11/30/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import "FacebookManager.h"
#import "AppDelegate.h"

@implementation FacebookManager


static FacebookManager *_facebookManager = nil;

+(FacebookManager *)sharedInstance{
    if (_facebookManager == nil) {
        _facebookManager = [[self alloc]init];
    }
    return _facebookManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self showDebugLog];
        _facebook = [[Facebook alloc]initWithAppId:FBSession.activeSession.appID andDelegate:nil];
        _facebook.accessToken = FBSession.activeSession.accessToken;
        _facebook.expirationDate = FBSession.activeSession.expirationDate;
    }
    return self;
}

//
//#pragma mark Nearby Places
//- (void)getNearBy:(NSDictionary *)param callback:(void(^)(id))callback{
//    [param setValue:_session.accessToken forKey:@"access_token"];
//    [FBRequestConnection
//     startWithGraphPath:@"search"
//     parameters:param
//     HTTPMethod:@"GET"
//     completionHandler:^(FBRequestConnection *connection,
//                         id result,
//                         NSError *error) {
//         NSString *alertText;
//         if (error) {
//             alertText = [NSString stringWithFormat:@"Failed!"];
//         } else {
//             alertText = [NSString stringWithFormat:@"Success!"];
//         }
//         [self showAlertWithText:alertText];
//         callback(result);
//     }];
//    
//    //    FBRequest *request = [FBRequest requestForPlacesSearchAtCoordinate:location radiusInMeters:500 resultsLimit:20 searchText:@""];
//    //    [FBRequestConnection startForPostWithGraphPath:[request graphPath] graphObject:[request graphObject]completionHandler:nil];
//}
#pragma mark others
- (void)showAlertWithText:(NSString *)alertText{
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:alertText
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

#pragma mark - 
#pragma mark Session
- (void)showDebugLog{
    if (DEBUG) {
        [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorFBRequests, FBLoggingBehaviorFBURLConnections, nil]];
    }
}


- (void)openSession{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (void)closeSession{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)isAuthenticated{
    if (self.session.isOpen) {
        return YES;
    }
    return NO;
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error{
    switch (state) {
        case FBSessionStateOpen:
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil
                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark Actions
/** This is a public method that should be called when posting.*/
- (void)publishStory{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIViewController *mvc = appDelegate.window.rootViewController;
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:mvc initialText:@""
                                                                          image:[UIImage imageNamed:@"testimage.png"]
                                                                            url:[NSURL URLWithString:@"http://www.example.com"]
     handler:^(FBNativeDialogResult result, NSError *error) {
         NSString *alertText;
         if (error) {
             NSLog(@"Error on post: %@",error);
         } else {
             if (result == FBNativeDialogResultSucceeded) {
                 alertText = [NSString stringWithFormat:@"Success!"];
             } else {
                 alertText = [NSString stringWithFormat:@"Cancelled!"];
             }
             [self showAlertWithText:alertText];
         }
     }];
    if (!displayedNativeDialog) {
        //This will be called when version is below 6.0 or fb account in 6.0 is not setup.
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Facebook SDK for iOS", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
                                       @"https://developers.facebook.com/ios", @"link",
                                       @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
                                       @"http://google.com",@"action_link",
                                       nil];
        [_facebook dialog:@"feed" andParams:params andDelegate:self];
//        _controller = [[FacebookVeiwController alloc]init];
//        _controller.delegate = self;
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:_controller];
//        [mvc presentModalViewController:navController animated:YES];
    }
}

//#pragma mark - FB dialog box fall back if user version is below 6
//- (void)postStory:(NSDictionary *)param
//{
//    [param setValue:_session.accessToken forKey:@"access_token"];
//    [FBRequestConnection
//     startWithGraphPath:@"me/feed"
//     parameters:param
//     HTTPMethod:@"POST"
//     completionHandler:^(FBRequestConnection *connection,
//                         id result,
//                         NSError *error) {
//         NSString *alertText;
//         if (error) {
//             alertText = [NSString stringWithFormat:@"Failed!"];
//         } else {
//             alertText = [NSString stringWithFormat:@"Success!"];
//             _controller.delegate = nil;
//             [_controller dismissModalViewControllerAnimated:YES];
//         }
//         [self showAlertWithText:alertText];
//     }];
//}
///** This code is part of FB dialog fallback and should only be called in the class. */
//- (void)publishStory:(NSDictionary *)param{
//    _tempParam = [[NSMutableDictionary alloc]initWithDictionary:param];
//    // Ask for publish_actions permissions in context
//    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
//        // No permissions found in session, ask for it
//        [FBSession.activeSession reauthorizeWithPublishPermissions:
//         [NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
//             if (!error) {
//                 // If permissions granted, publish the story
//                 [self publishStory];
//             }
//         }];
//    } else {
//        [self publishStory];
//    }
//}
//
//#pragma mark - FBViewController delegate
//- (void)_didPost:(NSMutableDictionary *)param{
//    [self publishStory:param];
//}

#pragma mark - FBDialog
/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:@"Success!"
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}
@end
