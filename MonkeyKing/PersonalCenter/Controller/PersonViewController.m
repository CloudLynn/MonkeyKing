//
//  PersonViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PersonViewController.h"
#import "ContactTopTableViewCell.h"
#import "PersonDetailViewController.h"
#import "WalletViewController.h"
#import "MyOrderViewController.h"
#import "MyServiceViewController.h"
#import "ReleaseViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSString *imgUrlString;

@end

@implementation PersonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoad) name:@"changeLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoad) name:@"changePersonDetail" object:nil];
    
}

- (void)refreshLoad{
    [self initializeUserInterface];
    
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *title;
    if (ISLOGIN) {
        title = @"立即发布";
    } else {
        title = @"立即登录";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.tableView registerClass:[ContactTopTableViewCell class] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)initializeDataSource{
    _tableArray = @[@"我的钱包",@"我的订单",@"我的发布",@"分享"];
    //http://api.swktcx.com/A1/user.php?token=get_user&uid=10000
    
    NSString *urlStr = [NSString stringWithFormat:@"%@token=get_user&uid=%@",USERURL,USER_UID];
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            
            _imgUrlString = responseObj[@"data"][@"image"];
            [USER_DEFAULTS setObject:responseObj[@"data"][@"user"] forKey:@"user"];
            [USER_DEFAULTS setObject:responseObj[@"data"][@"nickname"] forKey:@"nickname"];
            [USER_DEFAULTS setObject:responseObj[@"data"][@"realname"] forKey:@"realname"];
            [USER_DEFAULTS setObject:responseObj[@"data"][@"worknumber"] forKey:@"worknumber"];
            [USER_DEFAULTS synchronize];
            
            [self.tableView reloadData];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
}

#pragma mark - 点击事件 -
- (void)clickRightItem{
    if (ISLOGIN) {
        NSLog(@"已经登录");
        ReleaseViewController *releaseVC = [[ReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    } else {
        NSLog(@"没有登录");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)clickLoginBtn{
    if (ISLOGIN) {
        NSLog(@"已经登录");
    } else {
        NSLog(@"没有登录");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            ContactTopTableViewCell *cell = (ContactTopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"topCell"];
            if (!cell) {
                cell = [[ContactTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
            }
            
            [cell setIslogin:ISLOGIN];
            if (ISLOGIN) {
                [cell.headImgView sd_setImageWithURLString:_imgUrlString placeholderImage:[UIImage imageNamed:@"user_headImg"]];
            }else{
                [cell.headImgView setImage:[UIImage imageNamed:@"user_headImg"]];
            }
            
            [cell.loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            cell.textLabel.text = _tableArray[indexPath.row];
            UIImageView *nextImgView;
            if (!nextImgView) {
                nextImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
                [cell addSubview:nextImgView];
                [nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.sizeOffset(CGSizeMake(15, 15));
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.right.equalTo(cell.mas_right).offset(-8);
                }];
            }
            
            return cell;
            
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            cell.textLabel.text = @"退出登录";
            UIImageView *nextImgView;
            if (!nextImgView) {
                nextImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
                [cell addSubview:nextImgView];
                [nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.sizeOffset(CGSizeMake(15, 15));
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.right.equalTo(cell.mas_right).offset(-8);
                }];
            }
            if (ISLOGIN) {
                cell.hidden = NO;
            } else {
                cell.hidden = YES;
            }
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ISLOGIN) {
        switch (indexPath.section) {
            case 0:
            {
                PersonDetailViewController *detailVC = [[PersonDetailViewController alloc] init];
                detailVC.actionType = @"update";
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
            case 1:{
                if (indexPath.row == 0) {
                    NSLog(@"我的钱包");
                    WalletViewController *walletVC = [[WalletViewController alloc] init];
                    [self.navigationController pushViewController:walletVC animated:YES];
                } else if (indexPath.row == 1) {
                    NSLog(@"我的订单");
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    [self.navigationController pushViewController:myOrderVC animated:YES];
                } else if (indexPath.row == 2) {
                    NSLog(@"我的发布");
                    MyServiceViewController *myServiceVC = [[MyServiceViewController alloc] init];
                    [self.navigationController pushViewController:myServiceVC animated:YES];
                } else {
                    NSLog(@"分享");
                    
                    //1、创建分享参数
                    NSArray* imageArray = @[[UIImage imageNamed:@"appImg"]];
                    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
                    if (imageArray) {
                        
                        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                        [shareParams SSDKSetupShareParamsByText:@"生务空"
                                                         images:nil
                                                            url:[NSURL URLWithString:@"http://mob.com"]
                                                          title:@"生务空"
                                                           type:SSDKContentTypeAuto];
                        [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor orangeColor]];
                        [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor orangeColor]];
                        
                        //2、分享（可以弹出我们的分享菜单和编辑界面）
                        [ShareSDK showShareActionSheet:nil
                                                 items:nil
                                           shareParams:shareParams
                                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                       
                                       switch (state) {
                                           case SSDKResponseStateSuccess:
                                           {
                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                   message:nil
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:@"确定"
                                                                                         otherButtonTitles:nil];
                                               [alertView show];
                                               break;
                                           }
                                           case SSDKResponseStateFail:
                                           {
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:@"OK"
                                                                                     otherButtonTitles:nil, nil];
                                               [alert show];
                                               break;
                                           }
                                           default:
                                               break;
                                       }
                                   }  
                         ];
                                   
                         }
                        
                    
                }
                
                
                
            }
                break;
            case 2:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出登录状态？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self userLogout];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:sureAction];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 44;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
#pragma mark- 用户退出登录
- (void)userLogout{
    
   // http://api.swktcx.com/A1/user.php?token=quit
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:[NSString stringWithFormat:@"%@token=quit",USERURL] params:nil andSuccessBlock:^(id responseObj) {
        if ([responseObj[@"data"] isEqualToString:@"已退出登录"]) {
            [USER_DEFAULTS setBool:NO forKey:@"isLogin"];
            
            //发起通知
            NSNotification *notice = [NSNotification notificationWithName:@"changeLogin" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
            //    [USER_DEFAULTS setObject:nil forKey:@"userAllInfo"];
            [USER_DEFAULTS setObject:nil forKey:@"uid"];
            [USER_DEFAULTS setObject:nil forKey:@"nickname"];
            [USER_DEFAULTS setObject:nil forKey:@"realname"];
            [USER_DEFAULTS setObject:nil forKey:@"pwd"];
            [USER_DEFAULTS setObject:nil forKey:@"user"];
            [USER_DEFAULTS setObject:nil forKey:@"worknumber"];
            
            [USER_DEFAULTS synchronize];
            //退出登录
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
            }
            
            [self initializeUserInterface];
            [self.tableView reloadData];
            
        } else {
            
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLogin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePersonDetail" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
