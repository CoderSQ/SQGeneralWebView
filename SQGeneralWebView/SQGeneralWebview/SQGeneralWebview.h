//
//  SQGeneralWebview.h
//  SQGeneralWebView
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN
//#import <sys/cdefs.h>

@class SQGeneralWebview;

@protocol SQGeneralWebviewDelegate <NSObject>

@optional

- (BOOL)sq_webView:(nonnull SQGeneralWebview *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)sq_webViewDidStartLoad:(nonnull SQGeneralWebview *)webView;
- (void)sq_webViewDidFinishLoad:(nonnull SQGeneralWebview *)webView;
- (void)sq_webView:(nonnull SQGeneralWebview *)webView didFailLoadWithError:(nullable NSError *)error;

@end

@interface SQGeneralWebview : UIView

/***  使用的真实的webview */
@property (nonatomic, strong, nonnull) id webView;

//@property (nonatomic, strong, readonly) NSURLRequest* originRequest;
@property (nonatomic, weak, nullable) id<SQGeneralWebviewDelegate> delegate;

//webview的title 支持kvo
@property (nonatomic, copy, readonly) NSString *title;
//webview的加载进度 支持kvo
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, strong, readonly, nullable) NSURLRequest* currentRequest;

//---- UI 或者 WK 的API
@property (nonatomic, readonly, nonnull) UIScrollView *scrollView;

- (nonnull instancetype)initWithFrame:(CGRect)frame;

- (void)loadData:(nonnull NSData *)data MIMEType:(nonnull NSString *)MIMEType textEncodingName:(nonnull NSString *)textEncodingName baseURL:(nullable NSURL *)baseURL;
- (void)loadRequest:(nonnull NSURLRequest *)request;
- (void)loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL;

//- (nullable NSString *)stringByEvaluatingJavaScriptFromString:(nonnull NSString *)script __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

- (void)evaluateJavaScript:(nonnull NSString*)javaScriptString completionHandler:(void (^__nullable)(__nullable id,  NSError * __nullable error))completionHandler;


/**
 *  重新加载当前页面
 */
- (void)reload;

#pragma mark - interaction with js  use webviewjavascript

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;

NS_ASSUME_NONNULL_END
@end