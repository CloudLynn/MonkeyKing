//
//  AppMacro.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

///APPURL=======
#define USERURL @"http://api.swktcx.com/A1/user.php?"
#define SERVEURL @"http://api.swktcx.com/A1/serve.php?"
#define SORTURL @"http://api.swktcx.com/A1/sort.php?"
#define ORDERURL @"http://api.swktcx.com/A1/order.php?"
#define PROMPTURL @"http://api.swktcx.com/A1/global.php?token=getText&id="
#define ALIPAYURL @"http://api.swktcx.com/A1/alipayPay.php?"
#define WEPAYURL @"http://api.swktcx.com/A1/wePay.php?"
#define MESSAGEURL @"http://api.swktcx.com/A1/message.php?token="


///USERINFORMATION============
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
///登录状态
#define ISLOGIN [USER_DEFAULTS boolForKey:@"isLogin"]
///版本号
#define VERSION_CODE [USER_DEFAULTS objectForKey:@"versionCode"]
///用户信息
///用户电话号码
#define USER_USER [USER_DEFAULTS objectForKey:@"user"]
///登录密码
#define USER_PWD [USER_DEFAULTS objectForKey:@"pwd"]
///用户昵称
#define USER_NICKNAME [USER_DEFAULTS objectForKey:@"nickname"]
///真实姓名
#define USER_REALNAME [USER_DEFAULTS objectForKey:@"realname"]
///用户id
#define USER_UID [USER_DEFAULTS objectForKey:@"uid"]
///用户工号
#define USER_WORKNUMBER [USER_DEFAULTS objectForKey:@"worknumber"]

///userLat
#define USER_LAT [USER_DEFAULTS objectForKey:@"userLat"]//用户经纬度
#define USER_LNG [USER_DEFAULTS objectForKey:@"userLng"]

///微信
//#define WX_OPEN_ID @"4f8211338db2c83bf5d36929ae5107a2"
//#define WX_BASE_URL @"https://api.weixin.qq.com/sns"
//#define WX_ACCESS_TOKEN @"https://api.weixin.qq.com/sns/oauth2/access_token?"
//#define WX_REFRESH_TOKEN @"https://api.weixin.qq.com/sns/oauth2/refresh_token?"
//#define WXPatient_App_ID @"4f8211338db2c83bf5d36929ae5107a2"
//#define WXPatient_App_Secret @"5716a1cad311a6c76f779daf0a2084ce"


#define WXDoctor_App_ID @"4f8211338db2c83bf5d36929ae5107a2"  // 注册微信时的AppID
#define WXDoctor_App_Secret @"5716a1cad311a6c76f779daf0a2084ce" // 注册时得到的AppSecret
#define WXPatient_App_ID @"4f8211338db2c83bf5d36929ae5107a2"//"wx877078c2396c6508"
#define WXPatient_App_Secret @"5716a1cad311a6c76f779daf0a2084ce"
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

///极光
#define K_Regid @"regid"



#endif /* AppMacro_h */
