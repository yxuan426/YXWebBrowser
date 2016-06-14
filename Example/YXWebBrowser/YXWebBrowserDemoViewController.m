//
//  YXWebBrowserDemoViewController.m
//  YXWebBrowser
//
//  Created by Sternapara on 06/13/2016.
//  Copyright (c) 2016 Sternapara. All rights reserved.
//

#import "YXWebBrowserDemoViewController.h"
#import "YXWebBrowserViewController.h"

@interface YXWebBrowserDemoViewController ()

@end

@implementation YXWebBrowserDemoViewController

#define kHost @"http://stackoverflow.com"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - deleagte - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXWebBrowserViewController *webBrowser = [YXWebBrowserViewController webBrowserWithURLString:kHost];
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
    if (indexPath.section == 1) {
        YXWebBrowserViewController *webBrowser = [YXWebBrowserViewController webBrowserWithURLString:kHost];
        [self presentViewController:[webBrowser navigationControllerForModalPresent] animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - deleagte - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yxwebbrowserdemocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yxwebbrowserdemocell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"NavigationPresent";
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"ModalPresent";
    }
    return cell;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
