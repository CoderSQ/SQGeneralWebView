//
//  ViewController.m
//  SQGeneralWebView
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "ViewController.h"

#import "SQGeneralWebview.h"
#import <MJRefresh.h>

#import <WebKit/WebKit.h>
#import "ViewController1.h"

#import "WebViewJavascriptBridge.h"

//#import "WKWebViewJavascriptBridge.h"

@interface ViewController () <SQGeneralWebviewDelegate>

@property (nonatomic, strong) SQGeneralWebview *webViews;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webViews loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.lehumall.com/html5/app/index.html?=http://app.lehumall.com"]]];
    UIScrollView *sv = self.webViews.scrollView;
    
    __weak typeof(self) weakSelf = self;
    sv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.webViews reload];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"进入" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    
    [self.webViews registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
}


#pragma mark - SQGeneralWebviewDelegate

- (BOOL)sq_webView:(SQGeneralWebview *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)sq_webViewDidStartLoad:(SQGeneralWebview *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)sq_webViewDidFinishLoad:(SQGeneralWebview *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.webViews.scrollView.mj_header endRefreshing];
    
    NSLog(@"request = %@", self.webViews.currentRequest);
}

- (void)sq_webView:(SQGeneralWebview *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.webViews.scrollView.mj_header endRefreshing];
}

#pragma getter
- (SQGeneralWebview *)webViews {
    if (_webViews == nil) {
        NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
        _webViews = [[SQGeneralWebview alloc] initWithFrame:self.view.bounds];
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



- (void) btnClick {
    ViewController1 *vc = [[ViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - bridge


-(void)addRoute:(UIWebView*)webView
{
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
    
//    }];
    
    [_bridge registerHandler:@"scan_code_fun" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSString class]]) {
            return ;
        }
        NSDictionary *dict = data;
        NSDictionary *parms = [dict objectForKey:@"params"];
        NSLog(@"%@",dict);
        NSString *name = dict[@"funName"];
        
        if ([name isEqualToString:@"scan_code_fun"])
        { // 扫描
            NSLog(@"扫描");
            //            QRCodeViewController *qcr = [[QRCodeViewController alloc] init];
            //            UINavigationController *nav = [[UINavigationController  alloc] initWithRootViewController:qcr];
            //            [self presentViewController:nav animated:YES completion:nil];
        }
        else if ([name isEqualToString:@"message_fun"])
        { //消息
            //            if ([self isLogin]) {
            //                SystemNewsViewController *controller=[[SystemNewsViewController alloc]init];
            //                UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
            //                [self presentViewController:navigation animated:YES completion:nil];
            
            //            }
            NSLog(@"广告条1");
            
        }else if ([name isEqualToString:@"search_fun"])
        { //搜索
            NSLog(@"搜索");
            
            //            SearchViewController *search = [[SearchViewController alloc] init];
            //            UINavigationController *nav = [[UINavigationController  alloc] initWithRootViewController:search];
            //            [self presentViewController:nav animated:YES completion:nil];
        }
        else if ([name isEqualToString:@"banner_item_fun"])
        { //广告条
            switch ([[parms objectForKey:@"BANNER_JUMP_FLAG"] integerValue]) {
                case 1:
                {
                    NSLog(@"广告条1");
                    //                    //跳转活动详情
                    //                    AdsActivityController *detail = [[AdsActivityController alloc] init];
                    //                    detail.bannerId = [[parms objectForKey:@"ID"] intValue];
                    //                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
                    //                    [self presentViewController:navController animated:YES completion:nil];
                }
                    break;
                case 2:
                {
                    NSLog(@"广告条2");
                    //                    //跳转商品详情 去 intentId
                    //                    GoodsDetailNewViewController *detail = [[GoodsDetailNewViewController alloc] init];
                    //                    detail.productId = [[parms objectForKey:@"BANNER_JUMP_ID"] intValue];
                    //                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
                    //                    [self presentViewController:navController animated:YES completion:nil];
                }
                    break;
                case 3:
                {
                    NSLog(@"广告条3");
                    // 专区
                    //                    _isFromeAd = YES;
                    //                    [self intentPrefecture:[[parms objectForKey:@"ID"] integerValue] layoutId:[[parms objectForKey:@"BANNER_LAYOUT"] integerValue]type:[[parms objectForKey:@"BANNER_LAYOUT"] integerValue] withName:[parms objectForKey:@"BANNER_NAME"]];
                }
                    break;
                case 4:
                {
                    NSLog(@"广告条4");
                    
                    //                    // 快捷服务
                    //                    int type = [[parms objectForKey:@"BANNER_JUMP_ID"] intValue];
                    //                    [self lnkToolsClick:type];
                }
                    break;
                case 6:
                {
                    //                    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:item.bannerContent]];
                    //                    [self presentMoviePlayerViewControllerAnimated:controller];
                }
                    break;
                default:
                    break;
            }
            
        }else if ([name isEqualToString:@"seckill_more_fun"]){ //秒杀更多
            NSLog(@"秒杀");
            //            SecKillViewController *viewController = [[SecKillViewController alloc] init];
            //            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            //            [self presentViewController:navController animated:YES completion:nil];
            
        }else if ([name isEqualToString:@"shortcut_fun"]){ //快捷服务
            //            [self lnkToolsClick:[parms[@"dID"] intValue]];
            NSLog(@"广告条1");
        }else if ([name isEqualToString:@"good_detail_fun"] || [name isEqualToString:@"hot_recommendation_fun"]){ //商品详情 ||
            NSLog(@"商品详情");
            //            GoodsDetailNewViewController *webShop = [[GoodsDetailNewViewController alloc] init];
            //            webShop.productId = [[parms objectForKey:@"GOODS_ID"] integerValue];
            //            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webShop];
            //            [self presentViewController:navController animated:YES completion:nil];
        }else if ([name isEqualToString:@"promotion_more_fun"]){ //点击更多
            NSLog(@"广告条1");
            
            //            _isFromeAd = NO;
            //            [self intentPrefecture:[[parms objectForKey:@"id"] integerValue] layoutId:[[parms objectForKey:@"detail_layout"] integerValue] type:[[parms objectForKey:@"detail_layout"] integerValue]withName:[parms objectForKey:@"promotion_name"]];
        }else if ([name isEqualToString:@"show_detail_fun"]){
            NSLog(@"广告条1");
            
            //            HYShowDetailVC *detailVC = [[HYShowDetailVC alloc] init];
            //            HYShowModel *model = [HYShowModel objectWithKeyValues:parms];
            //            detailVC.model = model;
            //            detailVC.likeBlock = ^(NSInteger likeCount){};
            //            detailVC.commentBlock = ^(NSInteger commnetCount){};
            //            UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:detailVC];
            //            [self presentViewController:NAV animated:YES completion:nil];
        }else if ([name isEqualToString:@"set_hotline_fun"]){
            NSLog(@"广告条1");
            
            //            [[AppDefaultUtil sharedInstance] setHotLine:parms[@"hotline"]];
        }else if ([name isEqualToString:@"reload_web_fun"]){
            //            [self webViewLoadRequestError:NO];
            //            NSLog(@"网页刷新按钮");
        }

    }];
}

//-(BOOL)isLogin
//{
//    if (AppDelegateInstance.userInfo == nil) {
//        // 未登录
//        LoginViewController *loginView = [[LoginViewController alloc] init];
//        UINavigationController *naVController = [[UINavigationController alloc] initWithRootViewController:loginView];
//        [self presentViewController:naVController animated:YES completion:nil];
//        return NO;
//    }else {
//        return YES;
//    }
//}

//-(void)bobo
//{
//    
//    GRLiveConfig *con = [GRLiveConfig getInstance];
//    con.groupId = @"2016071801";
//    con.goodsClass = [GoodsDetailNewViewController class];
//    con.loginClass = [LoginViewController class];
//    con.shareBlock =  ^(NSString *url,NSString *title,NSString *dec,NSString *liveImgurl){
//        ShareView *shareView = [[ShareView alloc] init];
//        shareView.presentViewController = self;
//        shareView.shareContent = title;
//        shareView.shareImageUrl = liveImgurl;
//        shareView.shareUrl = url;
//        [shareView show];
//    };
//    con.navigationClass = [UINavigationController class];
//    con.payClass = [SubmitOrderViewController class];  //支付暂定
//    con.customNotificationString = @"dismiss_present";
//    
//    if (AppDelegateInstance.userInfo != nil) {
//        
//        con.isLogin = YES;
//        con.userTel = AppDelegateInstance.userInfo.phone;
//        
//        if (!_isEnterLive) {
//            [MBProgressHUD showMessage:nil];;
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"phone"] = AppDelegateInstance.userInfo.phone;
//            dict[@"userName"] = AppDelegateInstance.userInfo.phone;
//            dict[@"headImg"] =  AppDelegateInstance.userInfo.img;
//            dict[@"nickName"] = AppDelegateInstance.userInfo.userName;
//            [LHttpTool GETWithUrl:REQUEST_BOBOUSER Dict:dict success:^(id json) {
//                [MBProgressHUD hideHUD];
//                if ([json[@"statusCode"] isEqualToString:@"200"]) {
//                    [self presentGRLiveController];
//                }else{
//                    [MBProgressHUD showError:json[@"msg"]];
//                }
//            }];
//            return ;
//        }
//        [self presentGRLiveController];
//    }else{
//        con.isLogin = NO;
//        [self presentGRLiveController];
//    }
//}
//
//-(void)presentGRLiveController
//{
//    GRLiveHomeViewController *home = [[GRLiveHomeViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:home];
//    [self presentViewController:nav animated:YES completion:nil];
//    _isEnterLive = YES;
//}
//
//-(void)lnkToolsClick:(int)K
//{
//    id VC;
//    
//    if (K == 7){// 积分Club
//        if ([self isLogin]) {
//            ClubViewController *viewController = [[ClubViewController alloc] init];
//            VC = viewController;
//        }
//    }else if (K == 3){
//        if ([self isLogin]) {
//            AppointMentViewController *viewController = [[AppointMentViewController alloc] init];
//            VC = viewController;
//        }
//    }else if (K == 4){
//        if ([self isLogin]) {
//            AllOrderViewController *registerView = [[AllOrderViewController alloc] init];
//            registerView.mark = @"1";
//            registerView.status = @"4";
//            VC = registerView;
//        }
//    }else if (K == 8){
//        CustomerServiceViewController *viewController = [[CustomerServiceViewController alloc] init];
//        VC = viewController;
//    }else if (K == 6){ // 播播
//        [self bobo];
//    }else if (K == 10){
//        // 便民服务卡
//        if ([self isLogin]) {
//            if (AppDelegateInstance.userInfo.bdStatus == 0) {
//                CardLoginViewController *viewController = [[CardLoginViewController alloc] init];
//                VC = viewController;
//            }else {
//                ServeCardViewController *viewController = [[ServeCardViewController alloc] init];
//                VC = viewController;
//            }
//        }
//    }else if (K == 15){
//        // 申领乐虎红包
//        if ([self isLogin]) {
//            
//            ApplyTicketViewController *viewController = [[ApplyTicketViewController alloc] init];
//            viewController.stater = 5;
//            viewController.flag = 1;
//            VC = viewController;
//        }
//    }else if (K == 16){
//        // 问题俱乐部Club
//        LeHuWebViewController *viewController = [[LeHuWebViewController alloc] init];
//        
//        viewController.navigationItem.title = @"文体俱乐部";
//        viewController.m_contentUrl = @"http://112.84.178.50:8080/news";
//        VC = viewController;
//    }else if (K == 11){//话费充值
//        if ([self isLogin]) {
//            RechargeCallsController *viewController = [[RechargeCallsController alloc] init];
//            VC = viewController;
//        }
//    }else if (K == 12){//水费
//        if ([self isLogin]) {
//            WaterElectricityAndCoalViewController *viewController = [[WaterElectricityAndCoalViewController alloc] init];
//            viewController.segmentIndex = 1;
//            VC = viewController;
//        }
//    }else if (K == 13){//煤
//        if ([self isLogin]) {
//            WaterElectricityAndCoalViewController *viewController = [[WaterElectricityAndCoalViewController alloc] init];
//            viewController.segmentIndex = 2;
//            VC = viewController;
//        }
//    }else if (K == 14){  //电费
//        if ([self isLogin]) {
//            WaterElectricityAndCoalViewController *viewController = [[WaterElectricityAndCoalViewController alloc] init];
//            viewController.segmentIndex = 0;
//            VC = viewController;
//        }
//    }else if (K == 17){// 摇一摇Club
//        ShakeShakeViewController *viewController = [[ShakeShakeViewController alloc] init];
//        VC = viewController;
//    }else if (K == 22){//免费试用
//        if ([self isLogin]) {
//            TryOutHomeViewController *viewController=[[TryOutHomeViewController alloc]init];
//            VC = viewController;
//        }
//    }else if (K == 25){
//        if ([self isLogin]) {
//            [self sign]; //签到
//        }
//    }
//    if (VC) {
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:VC];
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//}
//
//-(void)intentPrefecture:(NSInteger) intentId layoutId:(NSInteger) layout type:(NSInteger)type withName:(NSString *)name
//{
//    switch (type) {
//        case 1:
//        {
//            // 专区布局1   TableView
//            PrefectureOneViewController *viewController = [[PrefectureOneViewController alloc] init];
//            viewController.ID =  [NSString stringWithFormat:@"%ld", (long)intentId];
//            viewController.name = name;
//            if (_isFromeAd == YES) {
//                viewController.flag = 3;
//            }else{
//                viewController.flag = 2;
//            }
//            
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            
//            [self presentViewController:navController animated:YES completion:nil];
//            
//        }
//            break;
//        case 2:
//        {
//            // 专区布局2  CollectionView
//            PrefectureTwoViewController *viewController = [[PrefectureTwoViewController alloc] init];
//            viewController.ID =  [NSString stringWithFormat:@"%ld", (long)intentId];
//            viewController.name = name;
//            if (_isFromeAd == YES) {
//                viewController.flag = 3;
//            }else{
//                viewController.flag = type;
//            }
//            
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            
//            [self presentViewController:navController animated:YES completion:nil];
//        }
//            break;
//        case 3:
//        {
//            // 专区布局1 TableView
//            PrefectureTwoViewController *viewController = [[PrefectureTwoViewController alloc] init];
//            viewController.ID =  [NSString stringWithFormat:@"%ld", (long)intentId];
//            viewController.name = name;
//            viewController.flag = type;
//            
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            
//            [self presentViewController:navController animated:YES completion:nil];
//        }
//        default:
//            break;
//    }
//    
//}
////签到
//-(void)sign
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"userId"] = AppDelegateInstance.userInfo.userId;
//    [LHttpTool GETWithUrl:REQUEST_MYLH_SIGN Dict:dict success:^(id json) {
//        NSNumber *re_type = [json objectForKey:@"type"];
//        NSString *msg=[NSString jsonUtils:[json objectForKey:@"msg"]];
//        if ([re_type integerValue]==1) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签到成功!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }else{
//            //签到失败
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"签到失败！" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    }];
//}


@end
