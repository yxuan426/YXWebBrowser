//
//  YXWebNavigationBar.h
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXWebNavigationBarItemClickedBlock)();

@interface YXWebNavigationBar : UIView

@property (nonatomic , copy) YXWebNavigationBarItemClickedBlock goBackEventCallback;
@property (nonatomic , copy) YXWebNavigationBarItemClickedBlock goForwardEventCallback;
@property (nonatomic , copy) YXWebNavigationBarItemClickedBlock refreshEventCallback;
@property (nonatomic , copy) YXWebNavigationBarItemClickedBlock stopEventCallback;
@property (nonatomic , copy) YXWebNavigationBarItemClickedBlock shareEventCallback;

@property (nonatomic , strong) UIColor *tintColor;

- (void)updateStateWithFlagsIsloading:(BOOL)loading canGoBack:(BOOL)canGoBack canGoForward:(BOOL)canGoForward;

@end
