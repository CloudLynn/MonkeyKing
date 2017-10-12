//
//  ViewController.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "MainViewController.h"//主页
#import "PersonViewController.h"//个人主页
//环信的
#import "ConversationListController.h"//消息
#import "ContactListViewController.h"//联系人
#import <Hyphenate/Hyphenate.h>

@interface ViewController : UITabBarController

@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, strong) PersonViewController *personVC;
@property (nonatomic, strong) ConversationListController *chatListVC;
@property (nonatomic, strong) ContactListViewController *contactsVC;


+ (ViewController *)shareVC;

-(void)addNotificationMessage:(id)message;
-(void)Jpush;


///环信
- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;


@end

