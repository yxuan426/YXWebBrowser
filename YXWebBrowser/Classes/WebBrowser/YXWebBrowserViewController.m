//
//  YXWebBrowserViewController.m
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import "YXWebBrowserViewController.h"
#import "YXWebBrowserViewController_extension.h"

#import "YXUIWebViewController.h"
#import "YXWKWebViewController.h"

@implementation YXWebBrowserViewController

#define kWebViewFrame CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)
#define kNavigationBarFrame CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)
#define kProgressFrame CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + 44 , CGRectGetWidth(self.navigationController.navigationBar.frame), 2)

#define kCanUseWKWebView (NSClassFromString(@"WKWebView") != nil)

#pragma mark - life cycle

+ (YXWebBrowserViewController *)webBrowser{
    return [YXWebBrowserViewController webBrowserWithRequest:nil];
}

+ (id)webBrowserWithURLString:(NSString *)URLString{
    return [YXWebBrowserViewController webBrowserWithURL:[NSURL URLWithString:URLString]];
}

+ (id)webBrowserWithURL:(NSURL *)URL{
    return [YXWebBrowserViewController webBrowserWithRequest:[NSURLRequest requestWithURL:URL]];
}

+ (id)webBrowserWithRequest:(NSURLRequest *)request{
    return [YXWKWebViewController webBrowserWithRequest:request userScript:nil];
}

+ (id)webBrowserWithURLString:(NSString *)URLString userScript:(DYWKUserScript *)script{
    return [YXWKWebViewController webBrowserWithURL:[NSURL URLWithString:URLString] userScript:script];
}

+ (id)webBrowserWithURL:(NSURL *)URL userScript:(DYWKUserScript *)script{
    return [YXWKWebViewController webBrowserWithRequest:[NSURLRequest requestWithURL:URL] userScript:script];
}

+ (id)webBrowserWithRequest:(NSURLRequest *)request userScript:(DYWKUserScript *)script{
    YXWebBrowserViewController *instance = nil;
    //WKWebKit可用时，优先使用
    if (kCanUseWKWebView) {
        instance = [[YXWKWebViewController alloc] initWithRequest:request userScript:script];
    }else{
        instance = [[YXUIWebViewController alloc] init];
    }
    instance.request = request;
    instance.progressTintColor =[UIColor orangeColor];//设置默认颜色
    instance.navigationBarTintColor = [UIColor orangeColor];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];//对象在子类生成
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.progressView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = newBackButton;//设置back标题
    self.navigationController.navigationBar.tintColor = self.navigationBarTintColor;
    
    [self relayout];//重新布局UI
    [self loadWebPage];//加载网页
}

- (void)dealloc{
}

#pragma mark - public methods

- (void)observeLoadingDidStart:(YXWebBrowserDidStartLoadBlock)start
                     didFinish:(YXWebBrowserDidFinishLoadBlock)finish
                     didFailed:(YXWebBrowserDidFailLoadBlock)failure{
    self.startBlock = start;
    self.finishBlock = finish;
    self.failureBlock = failure;
}

- (UINavigationController *)navigationControllerForModalPresent{
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(returnAndDismiss)];
    return naviVC;
}

- (void)clearAllCookies{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
}

//由子类实现
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler{}
- (void)setNotifyAlertViewTitle:(NSString *)viewTitle actionTitle:(NSString *)actionTitle{}
- (void)setConfirmAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle{}
- (void)setInputAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle{}

#pragma mark - event responses

- (void)returnAndDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - override

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (self.shouldRotateFromInterfaceOrientation) {
        [self relayout];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - private methods

- (void)loadWebPage{
}

- (void)relayout{
    self.webView.frame = kWebViewFrame;
    self.navigationBar.frame = kNavigationBarFrame;
    self.progressView.frame = kProgressFrame;
}

#pragma mark - getters

- (YXWebNavigationBar *)navigationBar{
    if (!_navigationBar) {
        _navigationBar = [[YXWebNavigationBar alloc] initWithFrame:kNavigationBarFrame];
        _navigationBar.tintColor = _navigationBarTintColor;
    }
    return _navigationBar;
}

- (YXWebProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[YXWebProgressView alloc] initWithFrame:kProgressFrame];
        _progressView.progressTintColor = _progressTintColor;
    }
    return _progressView;
}

- (NSString *)currentURLString{
    return [_request.URL absoluteString];
}

- (NSURL *)currentURL{
    return _request.URL;
}

- (NSURLRequest *)currentRequest{
    return _request;
}

- (float)loadingProgress{
    return _progressView.progress;
}

#pragma mark - setters

- (void)setProgressTintColor:(UIColor *)progressTintColor{
    _progressTintColor = progressTintColor;
    _progressView.progressTintColor = progressTintColor;
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor{
    _navigationBarTintColor = navigationBarTintColor;
    _navigationBar.tintColor = navigationBarTintColor;
    self.navigationController.navigationBar.tintColor = navigationBarTintColor;
}


@end
