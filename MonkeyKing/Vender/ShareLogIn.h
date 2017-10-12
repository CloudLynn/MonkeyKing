//
//  ShareLogIn.h
//  SCHClient
//
//  Created by SCH_YUH on 2016/10/24.
//  Copyright © 2016年 zqc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareConfigure.h"

@interface ShareLogInSuccModel :NSObject
///openId 唯一标识码
@property (nonatomic,copy) NSString *openid;
///昵称
@property (nonatomic,copy) NSString *nickname;
///头像
@property (nonatomic,copy) NSString *photo;
///用户类型（1-微信，2-QQ，3-新浪微博），类型：NSInteger
@property (nonatomic,assign) NSInteger usertype;
@end

@interface ShareLogIn : NSObject
-(void)shareLogInWithType:(ShareformType)type selectCancleBlock:(void (^)())cancleBlock succBlock:(void (^)(ShareLogInSuccModel *model))succBlock errorBlock:(void (^)(NSError *error))errorBlock;
@end
