//
//  ViewController.m
//  BWPNavigationController
//
//  Created by BWP on 16/1/5.
//  Copyright © 2016年 BWP. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth  [[UIScreen mainScreen] bounds].size.width
#define PRIMARY_COLOR UIColorARGB(1,55,75,112)
#define UIColorARGB(a,r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define GZFontWithSize(siz) [UIFont fontWithName:GZFont size:siz]
#define GZFont       @"Helvetica"
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface ViewController ()<UIWebViewDelegate,UIWebViewDelegate,WKNavigationDelegate>


@property (nonatomic ,strong) UIButton *backBtn1;
@property (nonatomic ,strong) UIButton *shareBtn;
@property (nonatomic ,strong) UIView *navBar;
@property (nonatomic ,strong) UIWebView *consoleWebView;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic ,copy)NSString *mybaseurl;

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"极赞控制台";
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
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:(UIBarButtonItemStylePlain) target:self action:@selector(cleanCache)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    [self creatPopView];

    
}


//
- (void)creatPopView{
    
    /**
     *  rightBarButton的点击标记，每次点击更改flag值。
     *  如果您用普通的button就不需要设置flag，通过按钮的seleted属性来控制即可
     */
    self.flag = YES;
    
    NSDictionary *dict0 = @{@"imageName" : @"home",
                            @"itemName" : @"首页"
                            };
    NSDictionary *dict1 = @{@"imageName" : @"refresh",
                            @"itemName" : @"清除缓存"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"http",
                            @"itemName" : @"设置地址"
                            };
    
    NSString* version=[[NSString alloc]initWithFormat:@"当前版本 %@%@",@"v",CURRENT_VERSION];

    NSDictionary *dict3 = @{@"imageName" : @"version",
                            @"itemName" : version
                            };
    NSArray *dataArray = @[dict0,dict1,dict2,dict3];
    // 计算菜单frame
    CGFloat x = 12;
    CGFloat y = 64 ;
    CGFloat width = self.view.bounds.size.width * 0.2;
    CGFloat height = dataArray.count * 40;  // 40 -> tableView's RowHeight
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建menu
     */
    [MenuView createMenuWithFrame:CGRectMake(x, y, width, height) target:self.navigationController dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        // do something
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag];
        
    } backViewTap:^{
        // 点击背景遮罩view后的block，可自定义事件
        // 这里的目的是，让rightButton点击，可再次pop出menu
        weakSelf.flag = YES;
    }];

}

- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    
    if (tag == 1) {
        [self requestHTML];
    }else if (tag == 2){
        [self cleanCache];
        [self hudWithTitle:@"清除缓存成功"];
        
    }else if (tag == 3){
         [self setBaseUrl];
    }else{
        [self hudWithTitle:str];

    }
    [MenuView hidden];  // 隐藏菜单

    self.flag = YES;
}

- (void)dealloc{
    [MenuView clearMenu];   // 移除菜单
}

- (void)setBaseUrl{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置服务端地址" preferredStyle:UIAlertControllerStyleAlert];
    //添加普通输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        NSString *myurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"mybaseurl"];
        if (myurl.length == 0) {

        }else{
            textField.text = myurl;
        }
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    //添加取消按钮 UIAlertActionStyleCancel - 文字是蓝色的 只能使用一次
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    //添加确定按钮 UIAlertActionStyleDefault - 文字是蓝色的 可以添加多个
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = alert.textFields.firstObject.text;
        self.mybaseurl = url;
        [user setValue:url forKey:@"baseUrl"];
        [user setValue:self.mybaseurl forKey:@"mybaseurl"];
        [user synchronize];
        
        [self requestHTML];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cleanCache{
    
    if (self.flag) {
        [MenuView showMenuWithAnimation:self.flag];
        self.flag = NO;
    }else{
        [MenuView showMenuWithAnimation:self.flag];
        self.flag = YES;
    }

}
- (void)requestHTML{
    NSString *httpStr ;

    NSString *myurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"mybaseurl"];
    if (myurl.length == 0) {
        httpStr = @"https://app.mpub.cn/masters/";//http://192.168.0.102:8088/masters/
    }else{
        httpStr = myurl;
    }

    NSLog(@"----- %@ ----- ",httpStr);
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.consoleWebView loadRequest:httpRequest];
    
}

- (void)homeViewAction{
    [self requestHTML];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    self.title = title;
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

- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
