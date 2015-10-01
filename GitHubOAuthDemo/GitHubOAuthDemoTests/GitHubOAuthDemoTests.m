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

@interface GitHubOAuthDemoTests : XCTestCase

@property (nonatomic, strong) GitHubOAuthController *authController;

@end

@implementation GitHubOAuthDemoTests

- (void)setUp {
    [super setUp];
    
    self.authController = [[GitHubOAuthController alloc] initWithClientId:@"" clientSecret:@"" scope:@"" success:nil failure:nil];
    
    [[GitHubOAuthController sharedInstance] configureForSafariViewControllerWithClientId:@"client" clientSecret:@"secret" redirectUri:@"redirect" scope:@"scope"];
}

//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}

- (void)testAuthUrl {
    XCTAssertTrue([[GitHubOAuthController sharedInstance].authUrl.absoluteString isEqualToString:@"https://github.com/login/oauth/authorize?redirect_uri=redirect&client_id=client&scope=scope"]);
}

- (void)testInit {
    XCTAssertTrue([self.authController isKindOfClass:[UIViewController class]]);
}

@end
