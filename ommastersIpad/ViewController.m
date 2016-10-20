//
//  ViewController.m
//  BWPNavigationController
//
//  Created by BWP on 16/1/5.
//  Copyright © 2016年 BWP. All rights reserved.
//

#import "ViewController.h"
//#import "OneViewController.h"
#import <WebKit/WebKit.h>
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth  [[UIScreen mainScreen] bounds].size.width
#define PRIMARY_COLOR UIColorARGB(1,55,75,112)
#define UIColorARGB(a,r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define GZFontWithSize(siz) [UIFont fontWithName:GZFont size:siz]
#define GZFont       @"Helvetica"
@interface ViewController ()<UIWebViewDelegate,UIWebViewDelegate,WKNavigationDelegate>


@property (nonatomic ,strong) UIButton *backBtn1;
@property (nonatomic ,strong) UIButton *shareBtn;
@property (nonatomic ,strong) UIView *navBar;
@property (nonatomic ,strong) UIWebView *consoleWebView;


@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.consoleWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.consoleWebView.delegate=self;
    self.consoleWebView.scrollView.bounces = NO;
    self.consoleWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.consoleWebView.backgroundColor = [UIColor clearColor];
    self.consoleWebView.scalesPageToFit = YES;
    self.consoleWebView.contentMode = UIViewContentModeRedraw;
    self.consoleWebView.opaque = YES;
    [self.view addSubview:self.consoleWebView];

    [self requestHTML];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:(UIBarButtonItemStyleDone) target:self action:@selector(homeViewAction)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:(UIBarButtonItemStyleDone) target:self  action:@selector(cleanCache)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_booking_delete"] style:(UIBarButtonItemStylePlain) target:self action:@selector(cleanCache)];

    
}
- (void)cleanCache{
    [self cleanCacheAndCookie];
}
- (void)requestHTML{
    //初始化webview
    NSString *httpStr = @"http://192.168.0.104:8088/masters/";
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.consoleWebView loadRequest:httpRequest];
    
}

- (void)homeViewAction{
    [self requestHTML];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}
- (void)viewWillLayoutSubviews
{
    [self _shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}
-(void)_shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        //        [self.navBar removeFromSuperview];
        //        [self createNavBar];
        
    } else { // 横屏
        //        [self.navBar removeFromSuperview];
        //        [self createNavBar];
        
    }
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
}

@end
