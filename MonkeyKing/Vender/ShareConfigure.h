//
//  ShareConfigure.h
//  SCHClient
//
//  Created by SCH_YUH on 2016/10/24.
//  Copyright © 2016年 zqc. All rights reserved.
//

#ifndef ShareConfigure_h
#define ShareConfigure_h
/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, ShareformType){
//    /**
//     *  新浪微博
//     */
//    ShareformTypeSinaWeibo           = 0,
    /**
     *  微信好友
     */
    ShareformTypeWechatSession    = 0,
    /**
     *  微信朋友圈
     */
    ShareformTypeWechatTimeline   = 1,
    /**
     *  QQ好友
     */
    ShareformTypeQQFriend         = 2,
    /**
     *  QQ空间
     */
    ShareformTypeQZone            = 3,
    /**
     *  支付宝 SSDKPlatformTypeAliPaySocial
     */
    ShareformTypeAliPaySocial     = 5,
    /**
     *  拷贝
     */
    ShareformTypeCopy                = 6,
    /**
     *  未知
     */
    ShareformTypeUnknown             = 7,
    /**
     *  QQ平台
     */
    ShareformTypeQQ             = 8,
    /**
     *  微信平台
     */
    ShareformTypeWechat             = 9,
    
};

#endif /* ShareConfigure_h */
