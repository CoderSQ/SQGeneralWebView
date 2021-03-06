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

#pragma mark - webview相关代理方法
- (BOOL)sq_webView:(nonnull SQGeneralWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)sq_webViewDidStartLoad:(nonnull SQGeneralWebView *)webView;
- (void)sq_webViewDidFinishLoad:(nonnull SQGeneralWebView *)webView;
- (void)sq_webView:(nonnull SQGeneralWebView *)webView didFailLoadWithError:(nullable NSError *)error;

#pragma mark -右滑手势相关代理方法

// 返回当前webview是否可以goBack, 当goBack状态改变时会调用这个方法
- (void)sq_webView:(SQGeneralWebView *)webView canGoBack:(BOOL) canGoBack;
// 这个方法在右滑返回时，如果webview没有可返回的页面时调用:通知代理，这是最后一个页面，并且用户使用了返回手势
//- (void) sq_webViewShouldGoBack:(nonnull SQGeneralWebView*)webView;
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

// 当前webview的request
@property (nonatomic, strong, readonly, nullable) NSURLRequest* currentRequest;

//---- UI 或者 WK 的API
@property (nonatomic, readonly, nonnull) UIScrollView *scrollView;

/** 调整页面大小以适应屏幕 */
@property (nonatomic) BOOL scalesPageToFit;

#pragma mark - 开启webview右滑返回上一个页面, 默认支持为YES
@property (nonatomic, assign) BOOL panGesEnable;



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

// 让webView 回滚到上一个页面
- (void)goBack;

#pragma mark - interaction with js  use webviewjavascript

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;



NS_ASSUME_NONNULL_END
@end
