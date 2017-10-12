//
//  ViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ViewController.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "JPUSHService.h"
#import "MyOrderViewController.h"


#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "ChatDemoHelper.h"
#import <UserNotifications/UserNotifications.h>

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface ViewController ()<BMKLocationServiceDelegate,UIAlertViewDelegate, EMCallManagerDelegate>{
    NSMutableArray *_viewControllers;
    NSTimer *_orderTimer;//检测订单的计时器
    NSInteger _lastOrderCount;//定位获取的订单数
    NSTimer *_timer;//定位的计数器
    BMKLocationService *_locService;//定位
    
    //推送
    NSMutableArray *_messageContents;
    int _messageCount;
    int _notificationCount;
    NSDictionary *_mesageDic;
    
    EMConnectionState _connectionState;
    
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;


@end

@implementation ViewController

+ (ViewController *)shareVC {
    static ViewController *viewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewController = [[ViewController alloc] init];
    });
    return viewController;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //通知检测
//    UIUserNotificationType type = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
//    NSLog(@"type = %lu",(unsigned long)type);
    
    
    
    self.tabBarController.tabBar.delegate = self;
    //获取版本号
    [self getVisionCode];
    
    //加载页面
    [self initializeUserInterface];
//    [self setupSubviews];
//    self.selectedIndex = 0;
    
    //用户定位
    [self loadLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToTimeOut) name:@"changeLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToTimeOut) name:@"changeLocation" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
//
    if (ISLOGIN) {
        //更新用户位置信息
//        _timer = [NSTimer scheduledTimerWithTimeInterval:299.0f target:self selector:@selector(respondsToTimeOut) userInfo:nil repeats:YES];
        //更新订单数
//        _orderTimer = [NSTimer scheduledTimerWithTimeInterval:19.0f target:self selector:@selector(respondsToOrderTimeOut) userInfo:nil repeats:YES];
    }
    
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
    [ChatDemoHelper shareHelper].contactViewVC = _contactsVC;
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
    
    self.navigationItem.title = @"生务空";
    
}


#pragma mark - 更新订单和位置 - Pravite
- (void)respondsToOrderTimeOut {
    if (ISLOGIN) {
        //检查订单数量
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:@"http://api.swktcx.com/A1/order.php?token=getOrderSum" params:nil andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            
            NSInteger nowOrderCount = [responseObj[@"data"][@"number"] integerValue];
            
            NSInteger lastOrderCount = [USER_DEFAULTS integerForKey:@"lastOrderCount"];
            
            if (nowOrderCount > lastOrderCount) {
                //            NSLog(@"有新订单");
                // 初始化并配置本地通知
                UILocalNotification *notification = [[UILocalNotification alloc]init];
                // 设置标题
                notification.alertTitle = @"生务空";
                // 设置提示声音
                notification.soundName = UILocalNotificationDefaultSoundName;
                // 设置显示内容
                notification.alertBody = @"您有新订单啦！请注意查看";
                // 3.添加通知
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                [USER_DEFAULTS setInteger:nowOrderCount forKey:@"lastOrderCount"];
                self.viewControllers[3].tabBarItem.badgeValue = @"1";
                
                [self pushProductDetail];
            }
            
        } andFailedBlock:^(id responseObj) {
            
        } andIsHUD:NO];
    }
    
    
} 

- (void)respondsToTimeOut {
    //    NSLog(@"跟新用户位置");
    [_locService startUserLocationService];
}

#pragma mark - 用户位置信息处理 - Pravite

- (void)loadLocation{
    /*定位*/
    if ([CLLocationManager locationServicesEnabled] &&([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
        
    } else {
        [PublicMethod showAlert:self message:@"未开启定位，部分功能不可用"];
    }
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //结束定位
    [_locService stopUserLocationService];
    NSString *lat = [NSString stringWithFormat:@"%.6f",userLocation.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%.6f",userLocation.location.coordinate.longitude];
    
    NSLog(@"位置坐标更新didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [USER_DEFAULTS setObject:lat forKey:@"userLat"];
    [USER_DEFAULTS setObject:lng forKey:@"userLng"];
    //http://api.swktcx.com/A1/user.php?token=set_gps&lat=23.4616546&lng=103.5444654
    NSString *urlString = [NSString stringWithFormat:@"http://api.swktcx.com/A1/user.php?token=set_gps&lat=%@&lng=%@",lat,lng];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlString params:nil andSuccessBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andFailedBlock:^(id responseObj) {
        
    } andIsHUD:NO];
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@",error);
}

#pragma mark - 加载页面 - Pravite

- (void)initializeUserInterface {
    _viewControllers = [NSMutableArray array];
    NSArray *className = @[@"MainViewController",@"ConversationListController",@"ContactListViewController",@"PersonViewController"];
    NSArray *title = @[@"生务空",@"消息",@"联系人",@"个人中心"];
    NSArray *imageArr = @[@"homeImg",@"messageImg",@"contactImg",@"personImg"];
    
    [className enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString(obj);
        UIViewController *viewController = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        viewController.title = title[idx];
        NSLog(@"%@",viewController.title);
        UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:title[idx] image:[UIImage imageNamed:imageArr[idx]] selectedImage:[UIImage imageNamed:imageArr[idx]]];
        tabbarItem.tag = 200 + idx;
        viewController.tabBarItem= tabbarItem;
        [_viewControllers addObject:nav];
    }];
    self.viewControllers = _viewControllers;
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor blackColor];
}
- (void)setupSubviews
{
    self.tabBar.accessibilityIdentifier = @"tabbar";
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    _mainVC = [[MainViewController alloc] init];
    _mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"生务空"
                                                           image:[UIImage imageNamed:@"homeImg"]
                                                   selectedImage:[UIImage imageNamed:@"homeImg"]];
    _mainVC.tabBarItem.tag = 0;
    _mainVC.tabBarItem.accessibilityIdentifier = @"homepage";
    _mainVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self unSelectedTapTabBarItems:_mainVC.tabBarItem];
    [self selectedTapTabBarItems:_mainVC.tabBarItem];
    
    
    _chatListVC = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
    [_chatListVC networkChanged:_connectionState];
    _chatListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                           image:[UIImage imageNamed:@"messageImg"]
                                                   selectedImage:[UIImage imageNamed:@"messageImg"]];
    _chatListVC.tabBarItem.tag = 1;
    _chatListVC.tabBarItem.accessibilityIdentifier = @"conversation";
    [self unSelectedTapTabBarItems:_chatListVC.tabBarItem];
    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
    
    _contactsVC = [[ContactListViewController alloc] initWithNibName:nil bundle:nil];
    _contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人"
                                                           image:[UIImage imageNamed:@"contactImg"]
                                                   selectedImage:[UIImage imageNamed:@"comtactImg"]];
    _contactsVC.tabBarItem.tag = 2;
    _contactsVC.tabBarItem.accessibilityIdentifier = @"contact";
    [self unSelectedTapTabBarItems:_contactsVC.tabBarItem];
    [self selectedTapTabBarItems:_contactsVC.tabBarItem];
    
    _personVC = [[PersonViewController alloc] init];
    _personVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心"
                                                           image:[UIImage imageNamed:@"personImg"]
                                                   selectedImage:[UIImage imageNamed:@"personImg"]];
    _personVC.tabBarItem.tag = 3;
    _personVC.tabBarItem.accessibilityIdentifier = @"person";
    _personVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self unSelectedTapTabBarItems:_personVC.tabBarItem];
    [self selectedTapTabBarItems:_personVC.tabBarItem];
    
    self.viewControllers = @[_mainVC,_chatListVC, _contactsVC, _personVC];
    [self selectedTapTabBarItems:_mainVC.tabBarItem];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], NSFontAttributeName,
                                        [UIColor whiteColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],NSFontAttributeName,
                                        RGBACOLOR(0x00, 0xac, 0xff, 1),NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

#pragma mark -- Pravite
//获取版本号
- (void)getVisionCode {
//    NSString *str = @"ver/";
//    NSString *midStr = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:midStr,@"id", nil];
//    [NetworkingManager getWithModelURL:str praviteParams:dic successHandle:^(id responderObject) {
//        //        NSLog(@"版本号：%@",responderObject);
//        NSString *versionCode = responderObject[@"str"];
//        [USER_DEFAULTS setObject:versionCode forKey:@"versionCode"];
//    } failHandle:^(NSError *error) {
//        //        NSLog(@"%@",error.localizedDescription);
//    }];
}

#pragma mark -- UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (item.tag == 0) {
        self.title = @"生务空";//NSLocalizedString(@"title.conversation", @"Conversations");
//        self.navigationItem.rightBarButtonItem = nil;
    }else if (item.tag == 1){
        self.title = @"消息";//NSLocalizedString(@"title.addressbook", @"AddressBook");
//        self.navigationItem.rightBarButtonItem = _addFriendItem;
    }else if (item.tag == 2){
        self.title = @"联系人";//NSLocalizedString(@"title.setting", @"Setting");
//        self.navigationItem.rightBarButtonItem = nil;
//        [_settingsVC refreshConfig];
    } else if (item.tag == 3){
        self.title = @"个人中心";
    }
    
    
    item.badgeValue = nil;
}


#pragma mark - 环信的方法 - Public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark ===================Jpush===========
-(void)Jpush{
    _messageCount = 0;
    _notificationCount = 0;
    _messageContents = [[NSMutableArray alloc] initWithCapacity:6];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}
- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    [[notification userInfo] valueForKey:@"RegistrationID"];
    NSLog(@"已注册");
    
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[notification userInfo] valueForKey:@"RegistrationID"];
            NSLog(@"已注册");
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
#endif
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID %@",[JPUSHService registrationID]);
        [[NSUserDefaults standardUserDefaults]setObject:[JPUSHService registrationID] forKey:K_Regid];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
-(void)addNotificationMessage:(id)message{
    NSLog(@"收到通知:%@", [self logDic:message]);
    _mesageDic=message;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //        //        [SCHPSetUp alerWith:@"未知网络"];
//                NSString *title = NSLocalizedString(@"温馨提示", nil);
//                NSString *message = NSLocalizedString(_mesageDic[@"aps"][@"alert"][@"message"][@"msg_content"], nil);
//                NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
//                NSString *otherButtonTitle = NSLocalizedString(@"去看看", nil);
//        
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        
//                // Create the actions.
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                    NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
//                }];
//        
//                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        
//                }];
//        
//        
//                // Add the actions.
//                [alertController addAction:cancelAction];
//                [alertController addAction:otherAction];
//        
//                [[[UIApplication sharedApplication].delegate window] .rootViewController presentViewController:alertController animated:YES completion:nil];
        // 初始化并配置本地通知
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        // 设置标题
        notification.alertTitle = @"生务空";
        // 设置提示声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 设置显示内容
        notification.alertBody = @"您有新订单啦！请注意查看";
        // 3.添加通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        self.viewControllers[3].tabBarItem.badgeValue = @"1";
        
        [self pushProductDetail];
        
    }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:_mesageDic[@"aps"][@"aler"][@"message"][@"msg_content"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
                [alert show];
        
    }
    
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:[self logDic:message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    
    
}

-(void)pushProductDetail{
    NSLog(@"从此处跳转到订单");
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
//    UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:myOrderVC];
//    nac.navigationBar.backgroundColor = [UIColor blackColor];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(clickBack)];
//    nac.navigationItem.leftBarButtonItem = left;
//    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    /* viewController.presentedViewController只有present才有值，push的时候为nil
     */
    
//    //防止重复弹
//    if ([viewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navigation = (id)viewController.presentedViewController;
//        if ([navigation.topViewController isKindOfClass:[ViewController class]]) {
//            return;
//        }
//    }
//    if (viewController.presentedViewController) {
//        //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
//        [viewController.presentedViewController dismissViewControllerAnimated:false completion:^{
//            [viewController presentViewController:nac animated:true completion:nil];
//        }];
//    }else {
//        [viewController presentViewController:nac animated:true completion:nil];
//    }
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

-(void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}


// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
    
    [self.contactsVC reloadApplyView];
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //             [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}




@end
