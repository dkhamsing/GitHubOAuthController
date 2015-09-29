//
//  SafariDemoController.m
//  GitHubOAuthDemo
//
//  Created by Daniel Khamsing on 9/29/15.
//  Copyright © 2015 dkhamsing. All rights reserved.
//

#import "TraditionalDemoController.h"

// Controllers
#import "GitHubOAuthController.h"

@implementation TraditionalDemoController

- (instancetype)init {
    self = [super init];
    
    // Init
    UIButton *oAuthButton = [[UIButton alloc] init];
    
    // Subviews
    [self.view addSubview:oAuthButton];
    
    // Setup
    self.view.backgroundColor = [UIColor whiteColor];
    
    [oAuthButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [oAuthButton addTarget:self action:@selector(actionStartTraditional) forControlEvents:UIControlEventTouchUpInside];
    [oAuthButton setTitle:@"Start Traditional OAuth" forState:UIControlStateNormal];
    
    // Layout
    oAuthButton.frame = ({
        CGRect frame;
        frame.origin.y = 200;
        frame.origin.x = 0;
        frame.size.width = self.view.bounds.size.width;
        frame.size.height = 50;
        frame;
    });
    oAuthButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return self;
}

- (void)actionStartTraditional {
    GitHubOAuthController *oAuthController = [[GitHubOAuthController alloc] initWithClientId:kClientId clientSecret:kClientSecret scope:kScope success:^(NSString *accessToken, NSDictionary *raw) {
        NSString *message = [NSString stringWithFormat:@"traditional oauth: retrieved access token: %@ \nraw: %@", accessToken, raw];
        NSLog(@"%@", message);        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"☺" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:nil];
    
    [oAuthController showModalFromController:self];
}

@end
