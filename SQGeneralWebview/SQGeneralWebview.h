//
//  SQGeneralWebView.h
//  SQGeneralWebView
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebViewJavascriptBridge.h>
#import <WKWebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN
//#import <sys/cdefs.h>

@class SQGeneralWebView;

@protocol SQGeneralWebViewDelegate <NSObject>

@optional

- (BOOL)sq_webView:(nonnull SQGeneralWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)sq_webViewDidStartLoad:(nonnull SQGeneralWebView *)webView;
- (void)sq_webViewDidFinishLoad:(nonnull SQGeneralWebView *)webView;
- (void)sq_webView:(nonnull SQGeneralWebView *)webView didFailLoadWithError:(nullable NSError *)error;

@end

@interface SQGeneralWebView : UIView

/***  使用的真实的webview */
@property (nonatomic, strong,readonly, nonnull) id webView;

/** 当前是否是wkwebview */
@property (nonatomic, assign, readonly) BOOL isWKWebView;


//@property (nonatomic, strong, readonly) NSURLRequest* originRequest;
@property (nonatomic, weak, nullable) id<SQGeneralWebViewDelegate> delegate;

//webview的title 支持kvo
@property (nonatomic, copy, readonly) NSString *title;
//webview的加载进度 支持kvo
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, strong, readonly, nullable) NSURLRequest* currentRequest;

//---- UI 或者 WK 的API
@property (nonatomic, readonly, nonnull) UIScrollView *scrollView;

/** 调整页面大小以适应屏幕 */
@property (nonatomic) BOOL scalesPageToFit;


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
