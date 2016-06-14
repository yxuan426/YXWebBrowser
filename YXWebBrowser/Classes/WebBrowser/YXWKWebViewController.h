//
//  YXWKWebViewController.h
//  YXWebBrowser
//
//  Created by Sternapara on 6/7/16.
//  Copyright © 2016 Sternapara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWebBrowserViewController.h"

typedef NS_ENUM(NSInteger, DYWKUserScriptInjectionTime) {
    DYWKUserScriptInjectionTimeAtDocumentStart,
    DYWKUserScriptInjectionTimeAtDocumentEnd
};

//对WKUserScript的对外替代类，方法和参数和WKUserScript完全保持一致
@interface DYWKUserScript : NSObject<NSCopying>

@property (nonatomic, readonly, copy) NSString *source;
@property (nonatomic, readonly) DYWKUserScriptInjectionTime injectionTime;
@property (nonatomic, readonly, getter=isForMainFrameOnly) BOOL forMainFrameOnly;

- (instancetype)initWithSource:(NSString *)source injectionTime:(DYWKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly;

@end

@interface YXWKWebViewController : YXWebBrowserViewController

- (id)initWithRequest:(NSURLRequest *)request userScript:(DYWKUserScript *)script;

@end
