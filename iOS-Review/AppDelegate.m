//
//  AppDelegate.m
//  iOS-Review
//
//  Created by zhengzeqin on 2021/5/21.
//  https://github.com/zeqinjie/JPBasicPrincipleKit
/**
 
 MJiOS底层笔记--OC对象本质: https://juejin.cn/post/6844903767003889678#heading-0
 【iOS】架构师之路~底层原理篇 一 :(OC本质、KVC、KVO、Categroy、Block）: https://juejin.cn/post/6844903920322494478#heading-12
 
 */
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
