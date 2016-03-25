//
//  ViewController.m
//  GitHubOAuthDemo
//
//  Created by Daniel Khamsing on 4/30/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import "SafariDemoController.h"

// Controllers
#import "GitHubOAuthController.h"

@implementation SafariDemoController

- (instancetype)init {
    self = [super init];
    
    // Init
    UIButton *safariButton = [[UIButton alloc] init];
    
    // Subviews
    [self.view addSubview:safariButton];
    
    // Setup
    self.view.backgroundColor = [UIColor whiteColor];
    
    [safariButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [safariButton addTarget:self action:@selector(actionStartSafari) forControlEvents:UIControlEventTouchUpInside];
    [safariButton setTitle:@"Start Safari View Controller OAuth" forState:UIControlStateNormal];
    
    // Layout
    safariButton.frame = ({
        CGRect frame;
        frame.origin.y = 200;
        frame.origin.x = 0;
        frame.size.width = self.view.bounds.size.width;
        frame.size.height = 50;
        frame;
    });
    safariButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return self;
}

- (void)actionStartSafari {
    [[GitHubOAuthController sharedInstance] presentOAuthSafariLoginFromController:self];
}

@end
