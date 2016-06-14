//
//  YXWKWebViewController.m
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "YXWKWebViewController.h"
#import "YXWebBrowserViewController_extension.h"
#import "RegExCategories.h"

@interface YXWKWebViewController()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic , strong) WKUserScript *userScript;
@property (nonatomic , strong) WKWebView *wkWebView;

//弹框标题
@property (nonatomic , copy) NSString *notifyAlertTitle_View;
@property (nonatomic , copy) NSString *notifyAlertTitle_Action;

@property (nonatomic , copy) NSString *confirmAlertTitle_View;
@property (nonatomic , copy) NSString *confirmAlertTitle_YES;
@property (nonatomic , copy) NSString *confirmAlertTitle_NO;

@property (nonatomic , copy) NSString *inputAlertTitle_View;
@property (nonatomic , copy) NSString *inputAlertTitle_YES;
@property (nonatomic , copy) NSString *inputAlertTitle_NO;

@end

@implementation YXWKWebViewController

#define kWebViewFrame CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)

#pragma mark - life cycle

- (id)initWithRequest:(NSURLRequest *)request userScript:(DYWKUserScript *)script{
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (script) {
            WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script.source
                                                              injectionTime:(WKUserScriptInjectionTime)script.injectionTime
                                                           forMainFrameOnly:script.forMainFrameOnly];
            _userScript = userScript;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBarEvents];
    [self setDefualtAlertViewTitles];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//监听progress
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];//监听标题
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - public methods

- (void)setNotifyAlertViewTitle:(NSString *)viewTitle actionTitle:(NSString *)actionTitle{
    self.notifyAlertTitle_View = viewTitle;
    self.notifyAlertTitle_Action = actionTitle;
}

- (void)setConfirmAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle{
    self.confirmAlertTitle_View = viewTitle;
    self.confirmAlertTitle_YES = yesActionTitle;
    self.confirmAlertTitle_NO = noActionTitle;
}

- (void)setInputAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle{
    self.inputAlertTitle_View = viewTitle;
    self.inputAlertTitle_YES = yesActionTitle;
    self.inputAlertTitle_NO = noActionTitle;
}

#pragma mark - deleagte - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //指向AppStore和URLScheme的链接无法打开，使用openURL:方法跳转
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    if ([urlString isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if (![urlString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

#pragma mark - deleagte - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.notifyAlertTitle_View message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:self.notifyAlertTitle_Action style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.confirmAlertTitle_View message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.confirmAlertTitle_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:self.confirmAlertTitle_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.inputAlertTitle_View message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:self.inputAlertTitle_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:self.inputAlertTitle_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - override

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setProgress:progress];
    }else if ([keyPath isEqualToString:@"title"]) {
        NSString *title = change[NSKeyValueChangeNewKey];
        self.title = title;
    }
}

- (UIView *)webView{
    return self.wkWebView;
}

- (void)loadWebPage{
    [self.wkWebView loadRequest:self.request];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler{
    [self.wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark - private methods

- (void)configureNavigationBarEvents{
    __weak typeof(self) weakSelf = self;
    self.navigationBar.goBackEventCallback = ^{
        [weakSelf.wkWebView goBack];
    };
    self.navigationBar.goForwardEventCallback = ^{
        [weakSelf.wkWebView goForward];
    };
    self.navigationBar.refreshEventCallback = ^{
        weakSelf.progressView.progress = 0.0;
        [weakSelf.wkWebView reload];
    };
    self.navigationBar.stopEventCallback = ^{
        [weakSelf.wkWebView stopLoading];
    };
    self.navigationBar.shareEventCallback = ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.currentURLString;
    };
}

- (void)setDefualtAlertViewTitles{
    self.notifyAlertTitle_View = @"我是一个提示框";
    self.notifyAlertTitle_Action = @"我知道了";
    
    self.confirmAlertTitle_View = @"我是一个选择框";
    self.confirmAlertTitle_YES = @"确认";
    self.confirmAlertTitle_NO = @"取消";
    
    self.inputAlertTitle_View = @"我是一个输入框";
    self.inputAlertTitle_YES = @"确认";
    self.inputAlertTitle_NO = @"取消";
}

#pragma mark - getters

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        CGRect frame = kWebViewFrame;
        if (_userScript) {
            WKUserContentController *userContentCtrler = [[WKUserContentController alloc] init];
            [userContentCtrler addUserScript:_userScript];
            WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
            config.userContentController = userContentCtrler;
            _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        }else{
            _wkWebView = [[WKWebView alloc] initWithFrame:frame];
        }
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

@end
