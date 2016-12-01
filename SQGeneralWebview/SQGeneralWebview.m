//
//  SQGeneralWebview.m
//  SQGeneralWebView
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQGeneralWebview.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

#define kObserverKeyTitle @"title"
#define kObserverKeyProgress @"estimatedProgress"

@interface SQGeneralWebview () <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong, readwrite, nonnull) id webView;
@property (nonatomic, assign, readwrite) BOOL isWKWebView;
@property (nonatomic, readwrite) double estimatedProgress;
@property (nonatomic, copy, readwrite) NSString *title;


/*** 为WebViewJavascriptBridge 或 WKWebViewJavascriptBridge */
@property (nonatomic, strong) id bridge;

/** 给UIWebView计算进度的定时器*/
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation SQGeneralWebview

#pragma mark - lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Class cls = NSClassFromString(@"WKWebView");
        if (cls) {
            _isWKWebView = YES;
        } else {
            _isWKWebView = NO;
        }
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"SQGeneralWebview dealloc");
    if (_isWKWebView) {
        WKWebView *webView = _webView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        [webView stopLoading];
        [webView removeFromSuperview];
        
        [webView removeObserver:self forKeyPath:kObserverKeyTitle];
        [webView removeObserver:self forKeyPath:kObserverKeyProgress];
        
    } else {
        UIWebView *webView = _webView;
        
        [webView setDelegate:nil];
        [webView loadHTMLString:@"" baseURL:nil];
        [webView stopLoading];
        [webView removeFromSuperview];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    _webView = nil;
}

#pragma mark - public methods

- (void)reload {
    
    if ([self.webView respondsToSelector:@selector(reload)]) {
        IMP reloadImp =  [self.webView methodForSelector:@selector(reload)];
        void (*func)(id, SEL) = (void *)reloadImp;
        func(self.webView, @selector(reload));
    }
    
    //    if (self.isWKWebView) {
    //        WKWebView *webView = self.webView;
    //        [webView reload];
    //    } else {
    //        UIWebView *webView = self.webView;
    //        [webView reload];
    //    }
}

- (void)loadRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutRequest = [request mutableCopy];
    if (mutRequest.timeoutInterval == 60) {
        mutRequest.timeoutInterval = 5;
    }
    
    if ([self.webView respondsToSelector:@selector(loadRequest:)]) {
        IMP requestImp = [self.webView methodForSelector:@selector(loadRequest:)];
        void (*func)(id, SEL, id) = (void *) requestImp;
        func(self.webView, @selector(loadRequest:), mutRequest);
    }
    
    //    if (self.isWKWebView) {
    //        WKWebView *webView = self.webView;
    //        [webView loadRequest:request];
    //    } else {
    //        UIWebView *webView = self.webView;
    //        [webView loadRequest:request];
    //    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    if ([self.webView respondsToSelector:@selector(loadHTMLString:baseURL:)]) {
        IMP loadImp = [self.webView methodForSelector:@selector(loadHTMLString:baseURL:)];
        void (*func)(id, SEL, id, id) = (void *)loadImp;
        func(self.webView, @selector(loadHTMLString:baseURL:), string, baseURL);
    }
    
    //    if (self.isWKWebView) {
    //        WKWebView *webView = self.webView;
    //        [webView loadHTMLString:string baseURL:baseURL];
    //    } else {
    //        UIWebView *webView = self.webView;
    //        [webView loadHTMLString:string baseURL:baseURL];
    //    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    
    if (_isWKWebView) {
        [(WKWebView *)self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    } else {
        NSString* result = [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler) {
            completionHandler(result, nil);
        }
    }
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    if (_isWKWebView) {
        WKWebView *webView = self.webView;
        [webView loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
    } else {
        UIWebView *webView = self.webView;
        [webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
    }
}

- (void)setScalePageToFit:(BOOL) fit {
    if (!_isWKWebView) { // UIWebView调整以显示
        [(UIWebView *)self.webView setScalesPageToFit:fit];
    }
}

- (BOOL)scalesPageToFit {
    if (_isWKWebView) {
        return YES;
    } else {
        return [(UIWebView *)self.webView scalesPageToFit];
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kObserverKeyProgress]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] floatValue];
        return;
    }
    
    if([keyPath isEqualToString:kObserverKeyTitle]) {
        self.title = change[NSKeyValueChangeNewKey];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    //    NSLog(@"url = %@", navigationAction.request.URL.absoluteString);
    //    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
    //        && ![hostname containsString:@".baidu.com"]) { // 不是百度的主机，则不再在webView打开链接，调到safari中打开
    //        // 对于跨域，需要手动跳转
    //        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    //
    //        // 不允许web内跳转
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //    } else {
    //        decisionHandler(WKNavigationActionPolicyAllow);
    //    }
    BOOL result = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    
    if (result) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    return decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

/* @abstract Invoked when a server redirect is received for the main
 frame
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}

/*! @abstract Invoked when content starts arriving for the main frame. */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [self callback_webViewDidStartLoad];
}

/*! @abstract Invoked when a main frame navigation completes.*/
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self callback_webViewDidFinishLoad];
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.*/
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

#pragma mark - WKUIDelegate

/**
 *   If you do not implement this method, the web view will behave as if the user selected the OK button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [self showAlertViewWithMessage:message];
    completionHandler();
}

/*
 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [self showAlertViewWithMessage:message];
    completionHandler(YES);
}

/** 文本输入提示 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    [self showAlertViewWithMessage:@"文本输入"];
    completionHandler(@"");
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    self.estimatedProgress = 0.0f;
    [self.timer setFireDate:[NSDate distantPast]];
    return [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self callback_webViewDidStartLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.estimatedProgress = 1.0f;
    //    [self.timer setFireDate:[NSDate distantFuture]];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self callback_webViewDidFinishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //    [self.timer setFireDate:[NSDate distantFuture]];
    [self callback_webViewDidFailLoadWithError:error];
}

#pragma mark - callback prive methods

- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    
    if ([self.delegate respondsToSelector:@selector(sq_webView:shouldStartLoadWithRequest:navigationType:)]) {
        
        if (navigationType == -1) {
            navigationType = WKNavigationTypeOther;
        }
        return [self.delegate sq_webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)callback_webViewDidStartLoad {
    
    if ([self.delegate respondsToSelector:@selector(sq_webViewDidStartLoad:)]) {
        [self.delegate sq_webViewDidStartLoad:self];
    }
}

- (void)callback_webViewDidFinishLoad {
    !_timer.isValid ? : [_timer invalidate] ;
    if ([self.delegate respondsToSelector:@selector(sq_webViewDidFinishLoad:)]) {
        [self.delegate sq_webViewDidFinishLoad:self];
    }
}

- (void)callback_webViewDidFailLoadWithError:(NSError *)error {
    !_timer.isValid ? : [_timer invalidate] ;
    if ([self.delegate respondsToSelector:@selector(sq_webView:didFailLoadWithError:)]) {
        [self.delegate sq_webView:self didFailLoadWithError:error];
    }
}

#pragma mark - public methods
- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler {
    [self.bridge registerHandler:handlerName handler:handler];
}

- (void)callHandler:(NSString*)handlerName {
    [self.bridge callHandler:handlerName];
}

- (void)callHandler:(NSString*)handlerName data:(id)data {
    [self.bridge callHandler:handlerName data:data];
}

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback{
    [self.bridge callHandler:handlerName data:data responseCallback:responseCallback];
}

#pragma mark -events
- (void) progressTimerDidFire {
    
    CGFloat increment = 0.005/(self.estimatedProgress + 0.2);
    if([self.webView isLoading] && self.estimatedProgress <= 1.0) {
        self.estimatedProgress = (self.estimatedProgress < 0.75f) ? self.estimatedProgress + increment : self.estimatedProgress + 0.0001;
        if (self.estimatedProgress >= 1.0) {
            self.estimatedProgress = 1.0f;
        }
        
        NSLog(@"progress = %f", self.estimatedProgress);
    }
}

#pragma mark - private
//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    //    NSLog(@"fileURL.fileURL = %@", fileURL.fileURL)
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

#pragma mark - getter

- (NSString *)title {
    if (_isWKWebView) {
        return [(WKWebView *)self.webView title];
    } else {
        return [(UIWebView *)self.webView  stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

-(id)webView {
    if (_webView == nil) {
        if (_isWKWebView) {
            [self setupWKWebView];
        } else {
            [self setupUIWebView];
        }
        
        NSLog(@"frame = %@", NSStringFromCGRect( [(UIView *)_webView frame]));
        [self addSubview:_webView];
    }
    
    return _webView;
}

- (void) setupWKWebView {
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKProcessPool *pool = [[WKProcessPool alloc] init];
    config.processPool = pool;
    
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.minimumFontSize = 12.0f;
    preference.javaScriptEnabled = YES;
    preference.javaScriptCanOpenWindowsAutomatically = NO;
    
    config.preferences = preference;
    
    // WKWebView设置为UIWebView scalePageToFit
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *content = [[WKUserContentController alloc] init];
    [content addUserScript:wkUScript];
    
    config.userContentController = content;
    
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    WKWebView *webView = _webView;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    
    [webView addObserver:self forKeyPath:kObserverKeyTitle options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:kObserverKeyProgress options:NSKeyValueObservingOptionNew context:nil];
}

- (void) setupUIWebView {
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    
    UIWebView *webView = _webView;
    
    webView.frame = self.bounds;
    //    webView.delegate = self;
}

- (UIScrollView *)scrollView {
    return [self.webView scrollView];
}

- (NSURLRequest *)currentRequest {
    if (_isWKWebView) {
        return [NSURLRequest requestWithURL:[(WKWebView *)self.webView URL]];
    } else {
        return [(UIWebView *)self.webView request];
    }
}

- (id)bridge {
    
    if (_bridge == nil) {
        
        if (self.isWKWebView) {
#ifdef DEBUG
            [WKWebViewJavascriptBridge enableLogging];
#endif
            _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
            [_bridge setWebViewDelegate:self];
            
        } else {
            
#ifdef DEBUG
            [WebViewJavascriptBridge enableLogging];
#endif
            _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
            [_bridge setWebViewDelegate:self];
        }
    }
    
    return _bridge;
}


//- (NSURLRequest *)originRequest {
//    if (_isWKWebView) {
//        return [(WKWebView *)self.webView ];
//    } else {
//
//    }
//}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(progressTimerDidFire) userInfo:nil repeats:YES];
    }
    
    return _timer;
}


- (void) showAlertViewWithMessage:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
