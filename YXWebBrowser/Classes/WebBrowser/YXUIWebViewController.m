//
//  YXUIWebViewController.m
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import "YXUIWebViewController.h"
#import "YXWebBrowserViewController_extension.h"

@interface YXUIWebViewController()<UIWebViewDelegate>

@property (nonatomic , strong) UIWebView *uiWebView;
@property (nonatomic , strong) YXWebProgressView *proxyProgressView;


@end

@implementation YXUIWebViewController

#define kWebViewFrame CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)
#define kProgressFrame CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + 44 , CGRectGetWidth(self.navigationController.navigationBar.frame), 2)

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBarEvents];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - deleagte - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self.navigationBar updateStateWithFlagsIsloading:webView.loading canGoBack:webView.canGoBack canGoForward:webView.canGoForward];
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

#pragma mark - override

- (void)loadWebPage{
    [self.uiWebView loadRequest:self.request];
}

- (UIView *)webView{
    return self.uiWebView;
}

- (YXWebProgressView *)progressView{
    return self.proxyProgressView;
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id, NSError * __nullable error))completionHandler{
    NSString *rs = [self.uiWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
    if (rs) {
        completionHandler(rs, nil);
    }else{
        NSError *customError = nil;
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"evaluate javascript failed" forKey:NSLocalizedDescriptionKey];
        customError = [NSError errorWithDomain:@"YXUIWebViewController" code:200 userInfo:details];
        completionHandler(rs, customError);
    }
}

#pragma mark - private methods

- (void)configureNavigationBarEvents{
    __weak typeof(self) weakSelf = self;
    self.navigationBar.goBackEventCallback = ^{
        [weakSelf.uiWebView goBack];
    };
    self.navigationBar.goForwardEventCallback = ^{
        [weakSelf.uiWebView goForward];
    };
    self.navigationBar.refreshEventCallback = ^{
        weakSelf.progressView.progress = 0.0;
        [weakSelf.uiWebView reload];
    };
    self.navigationBar.stopEventCallback = ^{
        [weakSelf.uiWebView stopLoading];
    };
    self.navigationBar.shareEventCallback = ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.currentURLString;
    };
}

#pragma mark - getters

- (UIWebView *)uiWebView{
    if (!_uiWebView) {
        _uiWebView = [[UIWebView alloc] initWithFrame:kWebViewFrame];
    }
    return _uiWebView;
}

- (YXWebProgressView *)proxyProgressView{
    if (!_proxyProgressView) {
        _proxyProgressView = [[YXWebProgressView alloc] initWithFrame:kProgressFrame
                                                              webview:self.uiWebView
                                          finalWebViewDelegateHandler:self];
        
        if (self.progressTintColor) {
            [_proxyProgressView setProgressTintColor:self.progressTintColor];
        }
    }
    return _proxyProgressView;
}

@end
