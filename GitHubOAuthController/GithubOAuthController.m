//
//  GitHubOAuthController.m
//
//  Created by Daniel Khamsing on 4/29/15.
//  Copyright (c) 2015 dkhamsing. All rights reserved.
//

#import "GitHubOAuthController.h"

NSString *gh_url_authorize = @"https://github.com/login/oauth/authorize";
NSString *gh_url_token = @"https://github.com/login/oauth/access_token";

NSString *gh_title = @"Loading";

@interface GitHubOAuthController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *spinnerView;

@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic) BOOL modal;

@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *clientId;

@property (nonatomic, copy) void (^success)(NSString *, NSDictionary *);
@property (nonatomic, copy) void (^failure)(NSError *);
@property (nonatomic, copy) void (^disableDesktop)();
@end

@implementation GitHubOAuthController

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    if (!self.clientSecret) {
        [self gh_logMessage:@"Error: please use initWithClientId:clientSecret:scope:success:failure"];
        return nil;
    }
    
    // Init
    self.closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(gh_close)];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.spinnerView = [[UIView alloc] init];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Subviews
    [self.view addSubview:self.webView];
    [self.view addSubview:self.spinnerView];
    [self.spinnerView addSubview:indicatorView];
    
    // Setup
    self.title = gh_title;
    self.webView.delegate = self;
    self.spinnerView.backgroundColor = [UIColor blackColor];
    self.spinnerView.alpha = 0;
    [indicatorView startAnimating];
    
    // Layout
    indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{ @"spin":self.spinnerView, };
    NSDictionary *metrics = nil;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[spin]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[spin]|" options:0 metrics:metrics views:views]];
    
    return self;
}

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret scope:(NSString *)scope success:(void (^)(NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure disableDesktop:(void (^)())disableDesktop {
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    self.success = success;
    self.failure = failure;
    self.disableDesktop = disableDesktop;
    
    self = [self init];
    
    scope = [scope stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *authUrl = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&scope=%@", gh_url_authorize, clientId, scope];
    NSURL *url = [NSURL URLWithString:authUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    return self;
}

- (void)showModalFromController:(UIViewController *)controller {
    self.modal = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];    
    [controller presentViewController:navigationController animated:YES completion:nil];
    
    self.navigationItem.rightBarButtonItem = self.closeButton;    
}

#pragma mark - Private

- (void)gh_close {
    self.webView.delegate = nil;

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    if (self.modal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)gh_logMessage:(NSString *)message {
    NSLog(@"%@", [NSString stringWithFormat:@"GitHub OAuth %@", message]);
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.title isEqualToString:gh_title]) {
        self.title = @"";
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString isEqualToString:@"https://github.com/site/mobile_preference"]) {
        if (self.disableDesktop) {
            self.disableDesktop();
         
            NSLog(@"GitHubOAuthController disabled the desktop version, you can change this by setting disableDesktop to nil.");
            return NO;
        }
    }
    
    // Exchange code for access token
    NSString *match = @"?code=";
    NSRange range = [request.URL.absoluteString rangeOfString:match];
    if (range.location != NSNotFound) {
        self.spinnerView.alpha = 0.4;
        NSString *code = [request.URL.absoluteString substringFromIndex:(range.location + match.length)];
        
        NSDictionary *parameters = @{
                                     @"code" : code,
                                     @"client_id" : self.clientId,
                                     @"client_secret" : self.clientSecret,
                                     @"grant_type" : @"authorization_code"
                                     };
        
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        NSURL *URL = [NSURL URLWithString:gh_url_token];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%@", @([requestData length])] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if ([indexSet containsIndex:statusCode] && data) {
                NSError *parseError = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                if (dictionary) {
                    if (self.success) {
                        self.success(dictionary[@"access_token"], dictionary);
                    }
                }
                else {
                    [self gh_logMessage:[NSString stringWithFormat:@"parse error: %@", parseError.localizedDescription]];
                    if (self.failure) {
                        self.failure(parseError);
                    }
                }
            }
            else {
                [self gh_logMessage:[NSString stringWithFormat:@"connection error: %@", connectionError.localizedDescription]];
                if (self.failure) {
                    self.failure(connectionError);
                }
            }
            
            [self gh_close];
        }];
        
        return NO;
    }
    
    return YES;
}

@end
