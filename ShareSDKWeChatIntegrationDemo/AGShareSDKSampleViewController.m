//
//  AGShareSDKSampleViewController.m
//  ShareSDKCustomActionSheetSample
//
//  Created by Nogard on 13-10-10.
//  Copyright (c) 2013年 ShareSDK. All rights reserved.
//

#import "AGShareSDKSampleViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UIView+Common.h>
#import "WXApi.h"


static NSString *WechatTimelineTitle = @"微信朋友圈分享";
static NSString *WechatSessionTitle  = @"微信好友分享";

@interface AGShareSDKSampleViewController ()

@end

@implementation AGShareSDKSampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:WechatSessionTitle forState:UIControlStateNormal];
    [button1 sizeToFit];
    [button1 addTarget:self
                action:@selector(buttonClicked:)
      forControlEvents:UIControlEventTouchDown];

    CGFloat x1 = (self.view.width - button1.width) /2;
    CGFloat y1 = self.view.height * 0.33333;
    CGFloat w1 = button1.width;
    CGFloat h1 = button1.height;
    button1.frame = CGRectMake(x1, y1, w1, h1);

    [self.view addSubview:button1];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:WechatTimelineTitle forState:UIControlStateNormal];
    [button2 sizeToFit];
    [button2 addTarget:self
                action:@selector(buttonClicked:)
      forControlEvents:UIControlEventTouchDown];

    CGFloat x2 = (self.view.width - button2.width) /2;
    CGFloat y2 = y1 + h1 + 10.0;
    CGFloat w2 = button2.width;
    CGFloat h2 = button2.height;
    button2.frame = CGRectMake(x2, y2, w2, h2);

    [self.view addSubview:button2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button Event Handle

- (void)buttonClicked:(id)sender
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *view =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"不能在模拟器上或没有安装微信的设备上正确运行！"
                                  delegate:nil
                         cancelButtonTitle:@"知道了"
                         otherButtonTitles: nil];
        [view show];
        return;
    }

    UIButton *button = (UIButton*)sender;
    ShareType shareType =
        ([button.titleLabel.text compare:WechatTimelineTitle] == NSOrderedSame)?
            ShareTypeWeixiTimeline : ShareTypeWeixiSession;

    id<ISSContent> publishContent = nil;

    NSString *contentString = @"使用 ShareSDK 分享到微信很容易！";
    NSString *titleString   = @"微信分享集成测试";
    NSString *urlString     = @"http://www.ShareSDK.cn";
    NSString *description   = @"Sample";

    //TODO: 4. 正确选择分享内容的 mediaType 以及填写参数，就能分享到微信
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:nil
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeText];

    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type,
                             SSResponseState state,
                             id<ISSPlatformShareInfo> statusInfo,
                             id<ICMErrorInfo> error,
                             BOOL end)
     {
         NSString *name = nil;
         switch (type)
         {
             case ShareTypeWeixiSession:
                 name = @"微信好友";
                 break;
             case ShareTypeWeixiTimeline:
                 name = @"微信朋友圈";
                 break;
             default:
                 name = @"某个平台";
                 break;
         }

         NSString *notice = nil;
         if (state == SSPublishContentStateSuccess)
         {
             notice = [NSString stringWithFormat:@"分享到%@成功！", name];
             NSLog(@"%@",notice);

             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
         else if (state == SSPublishContentStateFail)
         {
             notice = [NSString stringWithFormat:@"分享到%@失败,错误码:%d,错误描述:%@", name, [error errorCode], [error errorDescription]];
             NSLog(@"%@",notice);

             UIAlertView *view =
             [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:notice
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles: nil];
             [view show];
         }
     }];
}

@end
