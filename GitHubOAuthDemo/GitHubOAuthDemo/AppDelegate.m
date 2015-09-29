//
//  AppDelegate.m
//  GitHubOAuthDemo
//
//  Created by Daniel Khamsing on 4/30/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import "AppDelegate.h"

// Constants
#import "SafariDemoController.h"
#import "TraditionalDemoController.h"

// Controllers
#import "DemoController.h"
#import "GitHubOAuthController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[GitHubOAuthController sharedInstance] configureForSafariViewControllerWithClientId:kClientId clientSecret:kClientSecret redirectUri:kRedirectUri scope:kScope];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = ({
        DemoController *controller = [[DemoController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        navigationController;
    });
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSString *source = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([source isEqualToString:gh_safariViewService]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCloseSafariViewController object:nil];
        
        [[GitHubOAuthController sharedInstance] exchangeCodeForAccessTokenInUrl:url success:^(NSString *accessToken, NSDictionary *raw) {
            NSString *message = [NSString stringWithFormat:@"oauth with safari view controller: retrieved access token: %@ \nraw: %@", accessToken, raw];
            NSLog(@"%@", message);            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"☺" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];

        } failure:nil];
        
        return YES;
    };
    
    return NO;
}

@end
