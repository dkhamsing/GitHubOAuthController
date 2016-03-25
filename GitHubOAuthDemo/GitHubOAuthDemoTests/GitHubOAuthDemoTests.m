//
//  GitHubOAuthDemoTests.m
//  GitHubOAuthDemoTests
//
//  Created by Daniel Khamsing on 4/30/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GitHubOAuthController.h"

static NSString *const kClient    = @"key";
static NSString *const kSecret    = @"secret";
static NSString *const kScope     = @"scope";
static NSString *const kRedirect  = @"scheme://";

@interface GitHubOAuthDemoTests : XCTestCase

@property (nonatomic, strong) GitHubOAuthController *authController;

@end

@implementation GitHubOAuthDemoTests

- (void)setUp {
    [super setUp];
    
    self.authController = [[GitHubOAuthController alloc] initWithClientId:@"" clientSecret:@"" scope:@"" success:nil failure:nil];
    
    [[GitHubOAuthController sharedInstance] configureForSafariViewControllerWithClientId:kClient clientSecret:kSecret redirectUri:kRedirect scope:kScope];
}

- (void)testAuthUrl {
    NSString *expect = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?redirect_uri=%@&client_id=%@&scope=%@", kRedirect, kClient, kScope];
    XCTAssertTrue([[GitHubOAuthController sharedInstance].authUrl.absoluteString isEqualToString:expect]);
}

- (void)testInit {
    XCTAssertTrue([self.authController isKindOfClass:[UIViewController class]]);
}

- (void)testSharedInstance {
    XCTAssertTrue([[GitHubOAuthController sharedInstance] isKindOfClass:[GitHubOAuthController class]]);
}

@end
