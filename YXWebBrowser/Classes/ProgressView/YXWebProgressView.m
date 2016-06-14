//
//  YXWebProgressView.m
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import "YXWebProgressView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface YXWebProgressView()<NJKWebViewProgressDelegate>

@property (nonatomic , strong) NJKWebViewProgress *progressCaculator;
@property (nonatomic , strong) NJKWebViewProgressView *proressView;

@property (nonatomic , weak) id<UIWebViewDelegate> webViewProxy;
@property (nonatomic , weak) id<UIWebViewDelegate> caculatorProxy;

@end

@implementation YXWebProgressView

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame webview:nil finalWebViewDelegateHandler:nil];
}

- (instancetype)initWithFrame:(CGRect)frame webview:(UIWebView *)webView finalWebViewDelegateHandler:(id<UIWebViewDelegate>)finalHandler{
    if (self = [super initWithFrame:frame]) {
        _progressCaculator = [[NJKWebViewProgress alloc] init];
        if (webView) {
            webView.delegate = _progressCaculator;                    //NJKWebViewProgress需要在UIWebViewDelegate事件的响应下计算加载进度
        }
        if (finalHandler) {
            _progressCaculator.webViewProxyDelegate = finalHandler;   //NJKWebViewProgress将UIWebViewDelegate事件传递出去
        }
        _progressCaculator.progressDelegate = self;                   //进度计算结果代理
        [self addSubview:self.proressView];
    }
    return self;
}

#pragma mark - public methods

- (void)setProgress:(float)progress{
    _progress = progress;
    [self.proressView setProgress:progress animated:YES];
}

- (void)setProgressTintColor:(UIColor *)tintColor{
    _progressTintColor = tintColor;
    _proressView.progressBarView.backgroundColor = tintColor;
}

#pragma mark - deleagte - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    _progress = progress;
    [self.proressView setProgress:progress animated:YES];
}

#pragma mark - getters

- (NJKWebViewProgressView *)proressView{
    if (!_proressView) {
        _proressView = [[NJKWebViewProgressView alloc] initWithFrame:self.bounds];
        _proressView.progress = 0.0;
        _proressView.barAnimationDuration = .8;
        _proressView.fadeAnimationDuration = .15;
        _proressView.fadeOutDelay = .95;
    }
    return _proressView;
}

@end
