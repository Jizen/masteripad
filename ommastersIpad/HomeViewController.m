//
//  HomeViewController.m
//  ommastersIpad
//
//  Created by 瑞宁科技02 on 2016/10/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "HomeViewController.h"
#import <WebKit/WebKit.h>
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth  [[UIScreen mainScreen] bounds].size.width
#define PRIMARY_COLOR UIColorARGB(1,55,75,112)
#define UIColorARGB(a,r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define GZFontWithSize(siz) [UIFont fontWithName:GZFont size:siz]
#define GZFont       @"Helvetica"

@interface HomeViewController ()<UIWebViewDelegate,UIWebViewDelegate,WKNavigationDelegate>


@property (nonatomic ,strong) UIButton *backBtn1;
@property (nonatomic ,strong) UIButton *shareBtn;
@property (nonatomic ,strong) UIView *navBar;
@property (nonatomic ,strong) UIWebView *consoleWebView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self requestHTML];
    
}
- (void)requestHTML{
    //初始化webview
    self.consoleWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.consoleWebView.delegate=self;
    self.consoleWebView.scrollView.bounces = NO;
    self.consoleWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.consoleWebView.backgroundColor = [UIColor clearColor];
    self.consoleWebView.scalesPageToFit = YES;
    self.consoleWebView.contentMode = UIViewContentModeScaleToFill;
    self.consoleWebView.opaque = YES;
    NSString *httpStr = @"https://app.mpub.cn/masters/";
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.consoleWebView loadRequest:httpRequest];
    [self.view addSubview:self.consoleWebView];
    
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
        
    } else { // 横屏
        
    }
}


- (void)answerForQuestion:(UIButton *)btn{
    [self requestHTML];
    
}

@end
