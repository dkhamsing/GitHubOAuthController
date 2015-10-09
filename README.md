# GitHubOAuthController

Simple GitHub OAuth Controller for iOS

[![Build Status](https://travis-ci.org/dkhamsing/GitHubOAuthController.svg?branch=master)](https://travis-ci.org/dkhamsing/GitHubOAuthController)
[![Version](https://img.shields.io/cocoapods/v/GitHubOAuthController.svg?style=flat)](https://cocoapods.org/pods/GitHubOAuthController)
[![License](https://img.shields.io/cocoapods/l/GitHubOAuthController.svg?style=flat)](http://cocoadocs.org/docsets/GitHubOAuthController)
[![Platform](https://img.shields.io/cocoapods/p/GitHubOAuthController.svg?style=flat)](http://cocoadocs.org/docsets/GitHubOAuthController)


![](Assets/demo.gif)

# Installation

## [CocoaPods](https://cocoapods.org/)

``` ruby
platform :ios, '9.0'
pod 'GitHubOAuthController'
```

## Manual

Add the files in the GitHubOAuthController folder to your project.

## Usage

### Traditional in app OAuth

``` objc
#import "GitHubOAuthController.h"

GitHubOAuthController *oAuthController = [[GitHubOAuthController alloc] initWithClientId:kClientId clientSecret:kClientSecret scope:kScope success:^(NSString *accessToken, NSDictionary *raw) {
  NSLog(@"access token: %@ \nraw: %@", accessToken, raw);
} failure:nil];
    
[oAuthController showModalFromController:self];
```

### OAuth with Safari View Controller

- Set url scheme in `.plist`
  
![plist](Assets/plist.png)

```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string>com.dkhamsing.GitHubOAuthDemo</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>GitHubOAuthDemo</string>
			</array>
		</dict>
	</array>
```
- Set *Authorization callback URL* in GitHub app https://github.com/settings/developers, i.e. `GitHubOAuthDemo://token`

- Get token in app delegate

``` objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSString *source = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([source isEqualToString:gh_safariViewService]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCloseSafariViewController object:nil];
        
        [[GitHubOAuthController sharedInstance] requestAccessTokenWithUrl:url success:^(NSString *accessToken, NSDictionary *raw) {
            NSLog(@"oauth with safari view controller: retrieved access token: %@ \nraw: %@", accessToken, raw);
        } failure:nil];
        
        return YES;
    };
    
    return NO;
}
```

# Demo

GitHubOAuthController includes a demo project.

# Thanks

This project was inspired by Caleb Davenport's [SimpleAuth](https://github.com/calebd/SimpleAuth).

# Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

# License

GitHubOAuthController is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
