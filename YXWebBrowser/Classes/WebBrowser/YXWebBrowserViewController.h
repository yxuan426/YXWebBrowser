//
//  YXWebBrowserViewController.h
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXWebBrowserDidStartLoadBlock)();
typedef void(^YXWebBrowserDidFinishLoadBlock)();
typedef void(^YXWebBrowserDidFailLoadBlock)(NSError *error);

@class DYWKUserScript;
@interface YXWebBrowserViewController : UIViewController

//初始化
+ (id)webBrowser;
+ (id)webBrowserWithURLString:(NSString *)URLString;
+ (id)webBrowserWithURL:(NSURL *)URL;
+ (id)webBrowserWithRequest:(NSURLRequest *)request;

//进度条颜色
@property (nonatomic , strong) UIColor *progressTintColor;
//导航栏标题颜色
@property (nonatomic , strong) UIColor *navigationBarTintColor;
//模态弹出下的导航栏
- (UINavigationController *)navigationControllerForModalPresent;

//监听加载进度
- (void)observeLoadingDidStart:(YXWebBrowserDidStartLoadBlock)start didFinish:(YXWebBrowserDidFinishLoadBlock)finish didFailed:(YXWebBrowserDidFailLoadBlock)failure;
//清除所有cookie
- (void)clearAllCookies;
//执行javascript脚本
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler;

//获取请求地址
@property (nonatomic , copy, readonly) NSURL *currentURL;
@property (nonatomic , copy, readonly) NSString *currentURLString;
@property (nonatomic , strong, readonly) NSURLRequest *currentRequest;
//获取加载进度
@property (nonatomic , assign, readonly) float loadingProgress;

//设置是否随屏幕旋转，默认为NO(不自动旋转)
@property (nonatomic , assign) BOOL shouldRotateFromInterfaceOrientation;

//*********************** 以下方法仅在iOS8之后生效 *****************************//
//初始化
+ (id)webBrowserWithURLString:(NSString *)URLString userScript:(DYWKUserScript *)script NS_AVAILABLE_IOS(8_0);
+ (id)webBrowserWithURL:(NSURL *)URL userScript:(DYWKUserScript *)script NS_AVAILABLE_IOS(8_0);
+ (id)webBrowserWithRequest:(NSURLRequest *)request userScript:(DYWKUserScript *)script NS_AVAILABLE_IOS(8_0);
//设置JS三种弹框标题文字
- (void)setNotifyAlertViewTitle:(NSString *)viewTitle actionTitle:(NSString *)actionTitle NS_AVAILABLE_IOS(8_0);
- (void)setConfirmAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle NS_AVAILABLE_IOS(8_0);
- (void)setInputAlertViewTitle:(NSString *)viewTitle yesActionTitle:(NSString *)yesActionTitle noActionTitle:(NSString *)noActionTitle NS_AVAILABLE_IOS(8_0);

@end
