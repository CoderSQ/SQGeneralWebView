//
//  ViewController1.m
//  SQGeneralWebView
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "ViewController1.h"

#import "SQGeneralWebView.h"
#import <WebKit/WebKit.h>

#import <MJRefresh.h>

@interface ViewController1 () <SQGeneralWebViewDelegate>

@property (nonatomic, strong) SQGeneralWebView *webViews;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"http://image.baidu.com/search/index?tn=baiduimage&ipn=r&ct=201326592&cl=2&lm=-1&st=-1&fr=&sf=1&fmq=1463574658346_R&pv=&ic=0&nc=1&z=&se=1&showtab=0&fb=0&width=&height=&face=0&istype=2&ie=utf-8&word=宠物";
    
    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webViews loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
    UIScrollView *sv = self.webViews.scrollView;
    
    __weak typeof(self) weakSelf = self;
    sv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.webViews reload];
    }];
}


#pragma mark - SQGeneralWebViewDelegate

- (BOOL)sq_webView:(SQGeneralWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)sq_webViewDidStartLoad:(SQGeneralWebView *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)sq_webViewDidFinishLoad:(SQGeneralWebView *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.webViews.scrollView.mj_header endRefreshing];
}

- (void)sq_webView:(SQGeneralWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.webViews.scrollView.mj_header endRefreshing];
}

#pragma getter
- (SQGeneralWebView *)webViews {
    if (_webViews == nil) {
        NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
        _webViews = [[SQGeneralWebView alloc] initWithFrame:self.view.bounds];
        _webViews.delegate = self;
        
        [self.view addSubview:_webViews];
    }
    
    return _webViews;
}

- (void)dealloc {
    NSLog(@"viewcontroller dealloc");
    [_webViews removeFromSuperview];
    _webViews = nil;
}


@end
