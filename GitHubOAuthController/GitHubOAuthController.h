//
//  GitHubOAuthController.h
//
//  Created by Daniel Khamsing on 4/29/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const gh_safariViewService = @"com.apple.SafariViewService";

/** GitHub OAuth Controller. */
@interface GitHubOAuthController : UIViewController

/**
 Initialize GitHub OAuth controller.
 @param clientId GitHub app client id.
 @param clientSecret GitHub app client secret.
 @param scope OAuth scope, see https://developer.github.com/v3/oauth/#scopes for more information.
 @param success Block to execute in successful authentication with access token and raw response parameters.
 @param failure Block to execute in authentication failure with error parameter.
 @return Instance of GitHub OAuth controller.
 */
- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret scope:(NSString *)scope success:(void (^)(NSString *accessToken, NSDictionary *raw))success failure:(void (^)(NSError *error))failure;

/**
 Show GitHub OAuth controller modally.
 @param controller Controller to show modal in.
 */
- (void)showModalFromController:(UIViewController *)controller;

#pragma mark Safari view controller

/**
 😢 Shared instance to be used in Safari view controller.
 @return Shared instance.
 */
+ (instancetype)sharedInstance;

/**
 Authentication url.
 @return Authentication url.
 */
- (NSURL *)authUrl;

/**
 Configure GitHub OAuth for Safari view controller.
 @param clientId GitHub app client id.
 @param clientSecret GitHub app client secret.
 @param redirectUri GitHub app redirect uri, has to match the url scheme.
 @param scope OAuth scope, see https://developer.github.com/v3/oauth/#scopes for more information.
 */
- (void)configureForSafariViewControllerWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret redirectUri:(NSString *)redirectUri scope:(NSString *)scope;

/**
 Exchange code for access token. The blocks return on the main thread.
 @param url Url containing code.
 @param success Block to execute in successful authentication with access token and raw response parameters.
 @param failure Block to execute in authentication failure with error parameter.
 */
- (void)exchangeCodeForAccessTokenInUrl:(NSURL *)url success:(void (^)(NSString *accessToken, NSDictionary *raw))success failure:(void (^)(NSError *error))failure;

/**
 App delegate helper to get access token for - application:openURL:options:.
 @param url Open url.
 @param options Open url options.
 @param success Success completion block that takes a results parameter (OAuth token, OAuth token secret, Twitter screen name, etc..)
 @param failure Failure block.
 */
- (void)handleOpenUrl:(NSURL *)url options:(NSDictionary *)options success:(void (^)(NSString *accessToken, NSDictionary *raw))success failure:(void (^)(NSError *error))failure;

/**
 Present GitHub OAuth login with Safari View Controller.
 @param controller Controller to present GitHub OAuth login from.
 */
- (void)presentOAuthSafariLoginFromController:(UIViewController *)controller;

@end
