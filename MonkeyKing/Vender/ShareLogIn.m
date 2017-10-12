//
//  ShareLogIn.m
//  SCHClient
//
//  Created by SCH_YUH on 2016/10/24.
//  Copyright © 2016年 zqc. All rights reserved.
//

#import "ShareLogIn.h"
//other
#import <ShareSDK/ShareSDK.h>
@implementation ShareLogInSuccModel

@end
@implementation ShareLogIn
-(void)shareLogInWithType:(ShareformType)type selectCancleBlock:(void (^)())cancleBlock succBlock:(void (^)(ShareLogInSuccModel *model))succBlock errorBlock:(void (^)(NSError *error))errorBlock{
    SSDKPlatformType shareType;
    switch (type) {
//        case ShareformTypeSinaWeibo:
//            shareType=SSDKPlatformTypeSinaWeibo;
//            break;
        case ShareformTypeWechat:
            shareType=SSDKPlatformTypeWechat;
            break;
        case ShareformTypeQQ:
            shareType=SSDKPlatformTypeQQ;
            break;
        default:
            shareType=SSDKPlatformTypeUnknown;
            break;
    }
    
    [ShareSDK getUserInfo:shareType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            
            ShareLogInSuccModel *model=[ShareLogInSuccModel new];
            model.openid=user.uid;
            model.nickname=user.nickname;
            model.photo=user.icon;
            switch (type) {
//                case ShareformTypeSinaWeibo:
//                    model.usertype=3;
//                    break;
                case ShareformTypeWechat:
                    model.usertype=1;
                    break;
                case ShareformTypeQQ:
                    model.usertype=2;
                    break;
                default:
                    model.usertype=-1;
                    break;
            }
            succBlock(model);
        }
        else
        {
            errorBlock(error);
        }
    }];

}
@end
