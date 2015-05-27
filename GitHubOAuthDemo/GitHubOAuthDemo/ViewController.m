//
//  ViewController.m
//  GitHubOAuthDemo
//
//  Created by Daniel Khamsing on 4/30/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import "ViewController.h"

#import "GitHubOAuthController.h"

static NSString *const kClientId = @"TODO";
static NSString *const kClientSecret = @"TODO";
static NSString *const kScope = @"user notifications repo";

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIButton *startOAuthButton;
@end

@implementation ViewController

- (IBAction)actionStart:(id)sender {
    GitHubOAuthController *oAuthController = [[GitHubOAuthController alloc] initWithClientId:kClientId clientSecret:kClientSecret scope:kScope success:^(NSString *accessToken, NSDictionary *raw) {
        NSLog(@"yayyy access token: %@ \nraw: %@", accessToken, raw);
        [self.startOAuthButton setTitle:@"YAYYY" forState:UIControlStateNormal];
        [self.startOAuthButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay" message:[NSString stringWithFormat:@"Access token is %@", accessToken]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    } failure:nil
                                              
        // disableDesktop:nil];
        disableDesktop:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Desktop version disabled" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show]; }];
    [oAuthController showModalFromController:self];
}

@end
