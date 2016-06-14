//
//  YXWebBrowserViewController_extension.h
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import "YXWebBrowserViewController.h"

//subviews
#import "YXWebProgressView.h"
#import "YXWebNavigationBar.h"

@interface YXWebBrowserViewController ()

@property (nonatomic , copy) NSString *URLString;
@property (nonatomic , copy) NSURL *URL;
@property (nonatomic , strong) NSURLRequest *request;

@property (nonatomic , strong) UIView *webView;
@property (nonatomic , strong) YXWebProgressView *progressView;
@property (nonatomic , strong) YXWebNavigationBar *navigationBar; //下方的导航栏

@property (nonatomic , copy) YXWebBrowserDidStartLoadBlock startBlock;
@property (nonatomic , copy) YXWebBrowserDidFinishLoadBlock finishBlock;
@property (nonatomic , copy) YXWebBrowserDidFailLoadBlock failureBlock;

- (void)loadWebPage;

@end
