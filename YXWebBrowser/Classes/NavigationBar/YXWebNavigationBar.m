//
//  YXWebNavigationBar.m
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import "YXWebNavigationBar.h"

@interface YXWebNavigationBar()

@property (nonatomic , strong) UIToolbar *barView;

@property (nonatomic , strong) UIBarButtonItem *forwardBtn;
@property (nonatomic , strong) UIBarButtonItem *backBtn;
@property (nonatomic , strong) UIBarButtonItem *stopBtn;
@property (nonatomic , strong) UIBarButtonItem *refreshBtn;
@property (nonatomic , strong) UIBarButtonItem *shareBtn;

@end

@implementation YXWebNavigationBar

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.barView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    return nil;
}

#pragma mark - public methods

- (void)updateStateWithFlagsIsloading:(BOOL)loading canGoBack:(BOOL)canGoBack canGoForward:(BOOL)canGoForward{
    self.backBtn.enabled = canGoBack;
    self.forwardBtn.enabled = canGoForward;
    
    UIBarButtonItem *refreshOrStopBtn = loading ? self.stopBtn : self.refreshBtn;
    NSMutableArray *operationBarItems = [self.barView.items mutableCopy];
    [operationBarItems replaceObjectAtIndex:5 withObject:refreshOrStopBtn];
    self.barView.items = operationBarItems;
}

#pragma mark - event responses

- (void)backwardEventHandler:(UIEvent *)event{
    if (self.goBackEventCallback) {
        self.goBackEventCallback();
    }
}

- (void)forwardEventHandler:(UIEvent *)event{
    if (self.goForwardEventCallback) {
        self.goForwardEventCallback();
    }
}

- (void)refreshEventHandler:(UIEvent *)event{
    if (self.refreshEventCallback) {
        self.refreshEventCallback();
    }
}

- (void)stopEventHandler:(UIEvent *)event{
    if (self.stopEventCallback) {
        self.stopEventCallback();
    }
}

- (void)shareEventHandler:(UIEvent *)event{
    if (self.shareEventCallback) {
        self.shareEventCallback();
    }
}

#pragma mark - getters

- (UIToolbar *)barView{
    if (!_barView) {
        _barView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 44, CGRectGetWidth(self.frame), 44)];
        _barView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                     | UIViewAutoresizingFlexibleWidth);
        _barView.backgroundColor = [UIColor blackColor];
        
        UIImage *backImg = [UIImage imageNamed:@"YXWebBrowser.bundle/webbrowser_back"];
        UIImage *nextImg = [UIImage imageNamed:@"YXWebBrowser.bundle/webbrowser_next"];
        UIImage *stoploadingImg = [UIImage imageNamed:@"YXWebBrowser.bundle/webbrowser_stoploading"];
        UIImage *refreshImg = [UIImage imageNamed:@"YXWebBrowser.bundle/webbrowser_refresh"];
        
        _backBtn = [[UIBarButtonItem alloc] initWithImage:backImg
                                                    style:UIBarButtonItemStyleDone
                                                   target:self
                                                   action:@selector(backwardEventHandler:)];
        _forwardBtn = [[UIBarButtonItem alloc] initWithImage:nextImg
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(forwardEventHandler:)];
        _stopBtn = [[UIBarButtonItem alloc] initWithImage:stoploadingImg
                                                    style:UIBarButtonItemStyleDone
                                                   target:self
                                                   action:@selector(stopEventHandler:)];
        _refreshBtn = [[UIBarButtonItem alloc] initWithImage:refreshImg
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(refreshEventHandler:)];
        
        //等分布局
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *items = @[flexibleSpace,
                           _backBtn,
                           flexibleSpace,
                           _forwardBtn,
                           flexibleSpace,
                           _refreshBtn,
                           flexibleSpace];
        
        _barView.items = items;
    }
    return _barView;
}

#pragma mark - setters

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    _barView.tintColor = tintColor;
}

@end
