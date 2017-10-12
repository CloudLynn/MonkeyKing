//
//  AppDelegate.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
//#import "CartModel.h"
#import "ViewController.h"
//支付宝头文件
#import <AlipaySDK/AlipaySDK.h>
//shareSDK头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "WalletViewController.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

static NSString *appKey = @"bd8ad6112802f632aa7b9624";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

#define EaseMobAppKey @"1190170522115689#shengwukong"
//环信
#import <Hyphenate/Hyphenate.h>

//#import <HyphenateLite/EMSDK.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setShowType];
    if (ISLOGIN) {
        [self checkUserLoginStatus];
        //发起通知
        NSNotification *notice = [NSNotification notificationWithName:@"changeLocation" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
    
    ///===============地图========================================
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"1XIcqOs3quaY4VDevROtAN4ASHgjqM80"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    ///==================分享=====================================
    
    //向微信注册
    [WXApi registerApp:@"wx877078c2396c6508"];
    
    //初始化ShareSDK
    [ShareSDK registerApp:@"1dfd3263338c7"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2469251893"
                                           appSecret:@"303a0c657d4350ec260841db8508a381"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx877078c2396c6508"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106243050"
                                      appKey:@"4pOml9m4sAKfVenE"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
    ///============推送==============================================
    [self setXGPushWithOptions:launchOptions];
    
    ///============环信==============================================
    [self setEaseMobWithOptions:application withLaunchOptions:launchOptions];
    
    
    return YES;
}


//设置极光推送
-(void)setXGPushWithOptions:(NSDictionary *)launchOptions{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
//        else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
}

//环信
-(void)setEaseMobWithOptions:(UIApplication *)application withLaunchOptions:(NSDictionary *)launchOptions{
    
#warning Init SDK，detail in AppDelegate+EaseMob.m
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"MonkeyKingPush_Dev";
#else
    apnsCertName = @"MonkeyKingPush_Dis";
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = EaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:NO]}];//此bool值：是否打印环信日志
    

//    //AppKey:注册的AppKey，详细见下面注释。
//    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
//    EMOptions *options = [EMOptions optionsWithAppkey:@"1190170522115689#shengwukong"];
//    options.apnsCertName = @"MonkeyKingPush_Dev";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    
//    //iOS8以上 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//    else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
    
}

///设置要统一的样式
- (void)setShowType{
    //去掉单元格的分割线
    UITableView *tableView = [UITableView appearance];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //取消选中行阴影
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置导航栏字体颜色
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
}

- (void)checkUserLoginStatus{
        //http://api.swktcx.com/A1/user.php?token=is_login
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:@"http://api.swktcx.com/A1/user.php?token=is_login" params:nil andSuccessBlock:^(id responseObj) {
            
            NSLog(@"%@",responseObj[@"data"]);
            BOOL islogin = [responseObj[@"is_login"] boolValue];
            if (!islogin && !kStringIsEmpty(responseObj[@"error"])) {
                [self userLogin];
            }
        } andFailedBlock:^(id responseObj) {
                NSLog(@"%@",responseObj);
        } andIsHUD:NO];
}

- (void)userLogin{
    NSLog(@"%@===%@",USER_USER,USER_PWD);
    NSDictionary *paramsDict = @{@"token": @"login",
                                 @"user":USER_USER,
                                 @"pass":USER_PWD,
                                 @"lat":USER_LAT,
                                 @"lng":USER_LNG
                                 };
//    NSDictionary *paramsDict = @{@"token":@"AUTOLOGIN"};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramsDict andSuccessBlock:^(id responseObj) {
        
        //登录成功
        if (!kStringIsEmpty(responseObj[@"error"])) {
            [USER_DEFAULTS setBool:NO forKey:@"isLogin"];
            [USER_DEFAULTS setObject:nil forKey:@"uid"];
            [USER_DEFAULTS setObject:nil forKey:@"nickname"];
            [USER_DEFAULTS setObject:nil forKey:@"realname"];
            [USER_DEFAULTS setObject:nil forKey:@"pwd"];
            [USER_DEFAULTS setObject:nil forKey:@"user"];
            [USER_DEFAULTS setObject:nil forKey:@"worknumber"];
            
            [USER_DEFAULTS synchronize];
            
            //退出环信
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
            }
            
        } else {//if ([responseObj[@"error"] isEqualToString:@"执行自动登录返回"]){
            [USER_DEFAULTS setBool:YES forKey:@"isLogin"];
            //发起通知
            NSNotification *notice = [NSNotification notificationWithName:@"changeLocation" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
}

//APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    //发起通知
    NSNotification *notice = [NSNotification notificationWithName:@"changeLocation" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ===========推送=============
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    [JPUSHService setTags:tags alias:USER_USER fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if(iResCode == 0){
            NSLog(@"registrationID获取成功：%@",iAlias);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",iResCode);
        }
    }];
    [JPUSHService registerDeviceToken:deviceToken];
    
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    
    
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}
// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [[ViewController  shareVC] addNotificationMessage:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    [[ViewController  shareVC] addNotificationMessage:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[ViewController  shareVC] addNotificationMessage:userInfo];
    }else{
        //本地通知
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[ViewController  shareVC] addNotificationMessage:userInfo];
    }else{
        //本地通知
        
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#pragma mark - 添加本地通知
- (void) LocalNotificationSleep:(NSDate *) date{
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    //设置开始时间
    noti.fireDate=date;
    //设置body
    noti.alertBody=@"你有一条消息提醒，请查收！";
    //设置action
    noti.alertAction=@"详情";
    //设置闹铃
    noti.soundName=@"4195.mp3";
#warning 注册完之后如果不删除，下次会继续存在，即使从模拟器卸载掉也会保留
    //注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

#endif


#pragma mark ---------支付宝------------

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSNotification * notice = [NSNotification notificationWithName:@"payAmountResult" object:nil userInfo:@{@"result":resultDic}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);NSNotification * notice = [NSNotification notificationWithName:@"payAmountResult" object:nil userInfo:@{@"result":resultDic}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    //微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSNotification * notice = [NSNotification notificationWithName:@"payAmountResult" object:nil userInfo:@{@"result":resultDic}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSNotification * notice = [NSNotification notificationWithName:@"payAmountResult" object:nil userInfo:@{@"result":resultDic}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    //微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - 微信支付 -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
//     WalletViewController* walletVC = [[WalletViewController alloc] init];
//    BOOL res = [WXApi handleOpenURL:url delegate:walletVC];
//    return res;
}

#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                NSLog(@"支付失败");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSLog(@"取消支付");
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
    }// 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
//        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXPatient_App_ID, WXPatient_App_Secret, temp.code];
        
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:accessUrlStr params:nil andSuccessBlock:^(id responseObj) {
            NSLog(@"请求access的response = %@", responseObj);
            NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObj];
            NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
            NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
            NSString *refreshToken = [accessDict objectForKey:WX_REFRESH_TOKEN];
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"获取access_token时出错 = %@", responseObj);
        } andIsHUD:NO];
        
        
//        [serializer GET:accessUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//            [self wechatLoginByRequestForUserInfo];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
    }
}



// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    // 请求用户数据
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:userUrlStr params:nil andSuccessBlock:^(id responseObj) {
        NSLog(@"请求用户信息的response = %@", responseObj);
    } andFailedBlock:^(id responseObj) {
        NSLog(@"获取用户信息时出错 = %@", responseObj);
    } andIsHUD:NO];
    
//    [manager GET:userUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        // NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

@end
