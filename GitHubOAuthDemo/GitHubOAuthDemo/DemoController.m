//
//  DemoController.m
//  GitHubOAuthDemo
//
//  Created by Daniel Khamsing on 9/29/15.
//  Copyright © 2015 dkhamsing. All rights reserved.
//

#import "DemoController.h"

// Controllers
#import "SafariDemoController.h"
#import "TraditionalDemoController.h"

@interface DemoController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"GitHubOAuthController Demo";
    
    self.dataSource = @[
                        @"Traditional OAuth",
                        @"OAuth with Safari View Controller",
                        ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    UIViewController *controller = ({
        NSString *text = self.dataSource[indexPath.row];
        [text isEqualToString:@"Traditional OAuth"];
    }) ?
    [[TraditionalDemoController alloc] init] : [[SafariDemoController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
