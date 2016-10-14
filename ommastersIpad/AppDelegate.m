//
//  AppDelegate.m
//  ommastersIpad
//
//  Created by 瑞宁科技02 on 2016/10/13.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Main storyboard file base name  在info.plist文件中 添加这个属性 value = @"Main"   会导致旋转屏幕效果消失
    
    // 样式一  带有导航栏并且有旋转效果
    [self useNavibarwithPage:YES];
    // 样式二 不带导航栏 需要    在info.plist文件中 添加这个属性Main storyboard file base name ，  value = @"Main"

    return YES;
}

// 是否显示导航栏
-(void)useNavibarwithPage:(BOOL)show{
    if (show) {
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        
            [self.window makeKeyAndVisible];
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
