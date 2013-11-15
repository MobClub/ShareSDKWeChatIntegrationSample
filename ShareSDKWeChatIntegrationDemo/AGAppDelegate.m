//
//  AGAppDelegate.m
//  ShareSDKWeChatIntegrationDemo
//
//  Created by Nogard on 13-11-13.
//  Copyright (c) 2013年 ShareSDK. All rights reserved.
//

#import "AGAppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "AGShareSDKSampleViewController.h"

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    AGShareSDKSampleViewController *rootVC = [[AGShareSDKSampleViewController alloc] init];

    self.window.rootViewController = rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [ShareSDK registerApp:@"api20"];

    //TODO: 1. 先初始化微信Connection
    NSString *appId = @"wx6dd7a9b94f3dd72a";
    [ShareSDK connectWeChatSessionWithAppId: appId wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:appId wechatCls:[WXApi class]];

    //TODO: 2. 在info.plist文件里面配置微信的url scheme，以便系统能将微信的回调信息传给程序

    return YES;
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    //TODO: 3. 实现handleOpenUrl相关的两个方法，用来处理微信的回调信息
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


@end
