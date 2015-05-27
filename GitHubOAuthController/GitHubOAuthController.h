//
//  GitHubOAuthController.h
//
//  Created by Daniel Khamsing on 4/29/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

/** GitHub OAuth Controller. */
@interface GitHubOAuthController : UIViewController

/*
 Initialize GitHub OAuth controller.
 @param clientId GitHub app client id.
 @param clientSecret GitHub app client secret.
 @param scope OAuth scope, see https://developer.github.com/v3/oauth/#scopes for more information.
 @param success Block to execute in successful authentication with access token and raw response parameters.
 @param failure Block to execute in authentication failure with error parameter.
 @param disableDesktop Block to execute when user taps the Desktop Version link. If set to nil, the user can tap on Desktop Version.
 @return Instance of GitHub OAuth controller.
 */
- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret scope:(NSString *)scope success:(void (^)(NSString *accessToken, NSDictionary *raw))success failure:(void (^)(NSError *error))failure disableDesktop:(void (^)())disableDesktop;

/**
 Show GitHub OAuth controller modally.
 @param controller Controller to show modal in.
 */
- (void)showModalFromController:(UIViewController *)controller;

@end
