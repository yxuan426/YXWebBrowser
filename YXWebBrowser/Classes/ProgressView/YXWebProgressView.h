//
//  YXWebProgressView.h
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXWebProgressView : UIView

/**
 *  使用YXUIWebViewController时使用此方法初始化
 *  njk需要UIWebViewDelegate的load事件来计算进度
 *  先将webview的delegate设置为njk，njk进行计算，同时传递给vc
 *  UIWebView->NJKWebViewProgress->YXUIWebViewController,这样传递可以不破坏njk的代码
 *
 *  @param frame        frame
 *  @param webView      uiwebview对象
 *  @param finalHandler vc对象
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame webview:(UIWebView *)webView finalWebViewDelegateHandler:(id<UIWebViewDelegate>)finalHandler;

@property (nonatomic , strong) UIColor *progressTintColor;
@property (nonatomic , assign) float progress;

@end
