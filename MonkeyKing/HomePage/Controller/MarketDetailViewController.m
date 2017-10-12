//
//  MarketDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MarketDetailViewController.h"
//#import "PaymentViewController.h"
#import "TalentOrderViewController.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"

#define FONTSIZE [UIFont systemFontOfSize:15.0f]
@interface MarketDetailViewController ()
///滚动视图(覆盖整个CV)
@property (nonatomic, strong) UIScrollView *mainScrollView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///性别
@property (nonatomic, strong) UILabel *sexLbl;
///年龄
@property (nonatomic, strong) UILabel *ageLbl;
///户籍
@property (nonatomic, strong) UILabel *householdLbl;
///现居地址
@property (nonatomic, strong) UILabel *addressLbl;
///学历
@property (nonatomic, strong) UILabel *educationLbl;
///期望薪资
@property (nonatomic, strong) UILabel *salaryaLbl;
///职位类别
@property (nonatomic, strong) UILabel *jobCategoryLbl;
///工作年限
@property (nonatomic, strong) UILabel *workYearLbl;
///工作经历（textView）
@property (nonatomic, strong) UITextView *workExperienceTxt;
///技能专长
@property (nonatomic, strong) UILabel *expertiseLbl;
///所受奖惩
@property (nonatomic, strong) UILabel *rewardOrPunishmentLbl;
///自我评价
 @property (nonatomic, strong) UITextView *assessmentTxt;
///拨打电话
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, strong) NSString *phoneStr;
///下单
@property (nonatomic, strong) UIButton *orderBtn;

///buyer——address
@property (nonatomic, strong) NSString *buyerAddressStr;

@end

@implementation MarketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeDataSource{
    //http://api.swktcx.com/A1/serve.php?token=recrOne&uid=1&serve_id=319
    NSDictionary *paramDic = @{@"token":@"recrOne",
                               @"uid":USER_UID,
                               @"serve_id":_serve_id};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDic andSuccessBlock:^(id responseObj) {
        
        if (kStringIsEmpty(responseObj[@"error"])) {
            
            NSDictionary *dic = responseObj[@"data"];
//            NSLog(@"%@",dic);
            self.nameLbl.text = dic[@"realname"];
            self.ageLbl.text = dic[@"age"];
            self.sexLbl.text = dic[@"sex"];
            self.householdLbl.text = dic[@"first_address"];
            self.addressLbl.text = dic[@"now_address"];
            self.educationLbl.text = dic[@"education"];
            self.salaryaLbl.text = dic[@"wage"];
            self.workYearLbl.text = dic[@"job_year"];
            self.workExperienceTxt.text = dic[@"undergo"];
            self.expertiseLbl.text = dic[@"appraise"];
            self.rewardOrPunishmentLbl.text = dic[@"gain"];
            self.assessmentTxt.text = dic[@"my_appraise"];
            self.jobCategoryLbl.text = dic[@"type"];
            self.phoneStr = dic[@"phone"];
            
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@token=get_user&uid=%@",USERURL,USER_UID];
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
//            NSLog(@"%@",responseObj);
            self.buyerAddressStr = responseObj[@"data"][@"address"];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"简历";
    
    //初始化滚动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.autoresizesSubviews = NO;
    [self.view addSubview:_mainScrollView];
    
    //title
    
    UILabel *nameLbl = [UILabel new];
    UILabel *sexLbl = [UILabel new];//性别
    UILabel *ageLbl = [UILabel new];
    UILabel *householdLbl = [UILabel new];//户籍
    UILabel *addressLbl = [UILabel new];
    UILabel *schoolingLbl = [UILabel new];
    UILabel *salaryLbl = [UILabel new];//期望薪资
    UILabel *jobCategoryLbl = [UILabel new];
    UILabel *workingYearsLbl = [UILabel new];
    UILabel *workExperienceLbl = [UILabel new];//9
    UILabel *expertiseLbl = [UILabel new];
    UILabel *rewardOrPunishmentLbl = [UILabel new];
    UILabel *assessmentLbl = [UILabel new];    //12
    
    NSArray *strArray = @[@"姓       名",@"年      龄",@"现居地址",@"学      历",@"职位类别",@"工作年限",@"工作经历",@"技能专长",@"所受奖惩",@"自我评价"];
    NSArray *lblArray = [NSArray arrayWithObjects:nameLbl,ageLbl,addressLbl,schoolingLbl,jobCategoryLbl,workingYearsLbl,workExperienceLbl,expertiseLbl,rewardOrPunishmentLbl,assessmentLbl, nil];
    
    
    for (int i = 0; i < strArray.count; i ++) {
        
        if(i >= 7) {
            UILabel *lbl = lblArray[i];
            [lbl setText:strArray[i]];
            [lbl setFont:FONTSIZE];
            [self.mainScrollView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(70, 30));
                make.top.equalTo(self.mainScrollView.mas_top).offset(110+i*44);
                make.left.equalTo(self.mainScrollView.mas_left).offset(0);
            }];
        } else {
            UILabel *lbl = lblArray[i];
            [lbl setText:strArray[i]];
            [lbl setFont:FONTSIZE];
            [self.mainScrollView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(70, 30));
                make.top.equalTo(self.mainScrollView.mas_top).offset(7+i*44);
                make.left.equalTo(self.mainScrollView.mas_left).offset(0);
            }];
        }
    }
    
    
    NSInteger halfW = SCREEN_WIDTH/2;
    
    _nameLbl = [UILabel new];
    _nameLbl.font = FONTSIZE;
//    _nameLbl.text = @"sghilg";
    [self.mainScrollView addSubview:_nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-halfW);
        make.centerY.equalTo(nameLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    //sex
    sexLbl.font = FONTSIZE;
    sexLbl.text = @"性       别";
    [self.mainScrollView addSubview:sexLbl];
    [sexLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).offset(0);
        make.size.sizeOffset(CGSizeMake(70, 30));
        make.centerY.equalTo(nameLbl.mas_centerY);
    }];
    
    _sexLbl = [UILabel new];
    _sexLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_sexLbl];
    [self.sexLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _ageLbl = [UILabel new];
    _ageLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_ageLbl];
    [self.ageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ageLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-halfW);
        make.centerY.equalTo(ageLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    //household
    householdLbl.font = FONTSIZE;
    householdLbl.text = @"户       籍";
    [self.mainScrollView addSubview:householdLbl];
    [householdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLbl.mas_right).offset(0);
        make.size.sizeOffset(CGSizeMake(70, 30));
        make.centerY.equalTo(ageLbl.mas_centerY);
    }];
    _householdLbl = [UILabel new];
    _householdLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_householdLbl];
    [self.householdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(householdLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.centerY.equalTo(self.ageLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _addressLbl = [UILabel new];
    _addressLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_addressLbl];
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(addressLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _educationLbl = [UILabel new];
    _educationLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_educationLbl];
    [self.educationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(schoolingLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-halfW);
        make.centerY.equalTo(schoolingLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    //salarya
    salaryLbl.font = FONTSIZE;
    salaryLbl.text = @"期望薪资";
    [self.mainScrollView addSubview:salaryLbl];
    [salaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.educationLbl.mas_right).offset(0);
        make.size.sizeOffset(CGSizeMake(70, 30));
        make.centerY.equalTo(schoolingLbl.mas_centerY);
    }];
    _salaryaLbl = [UILabel new];
    _salaryaLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_salaryaLbl];
    [self.salaryaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(salaryLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.centerY.equalTo(salaryLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _jobCategoryLbl = [UILabel new];
    _jobCategoryLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_jobCategoryLbl];
    [self.jobCategoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jobCategoryLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(jobCategoryLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _workYearLbl = [UILabel new];
    _workYearLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_workYearLbl];
    [self.workYearLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workingYearsLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(workingYearsLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _workExperienceTxt = [UITextView new];
    _workExperienceTxt.editable = NO;
    _workExperienceTxt.tag = 200;
    _workExperienceTxt.font = FONTSIZE;
    _workExperienceTxt.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _workExperienceTxt.layer.masksToBounds = YES;
    _workExperienceTxt.layer.cornerRadius = 5;
    [self.mainScrollView addSubview:_workExperienceTxt];
    [self.workExperienceTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workExperienceLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.top.equalTo(workExperienceLbl.mas_top);
        make.height.mas_offset(125);
    }];
    
    _expertiseLbl = [UILabel new];
    _expertiseLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_expertiseLbl];
    [self.expertiseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expertiseLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(expertiseLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _rewardOrPunishmentLbl = [UILabel new];
    _rewardOrPunishmentLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:_rewardOrPunishmentLbl];
    [self.rewardOrPunishmentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardOrPunishmentLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(rewardOrPunishmentLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _assessmentTxt = [UITextView new];
    _assessmentTxt.editable = NO;
    _assessmentTxt.tag = 300;
    _assessmentTxt.font = FONTSIZE;
    _assessmentTxt.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _assessmentTxt.layer.masksToBounds = YES;
    _assessmentTxt.layer.cornerRadius = 5;
    [self.mainScrollView addSubview:_assessmentTxt];
    [self.assessmentTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(assessmentLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.top.equalTo(assessmentLbl.mas_top);
        make.height.mas_offset(125);
    }];
    
    _callBtn = [UIButton new];
    [_callBtn setImage:[UIImage imageNamed:@"callImg"] forState:UIControlStateNormal];
    _callBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _callBtn.layer.borderWidth = 1.0f;
    _callBtn.layer.cornerRadius = 8.0f;
    _callBtn.layer.masksToBounds = YES;
    [self.view addSubview:_callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.top.equalTo(self.assessmentTxt.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(120, 40));
    }];
    [self.callBtn addTarget:self action:@selector(clickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderBtn = [UIButton new];
    [_orderBtn setTitle:@"下单" forState:UIControlStateNormal];
    [_orderBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _orderBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _orderBtn.layer.borderWidth = 1.0f;
    _orderBtn.layer.cornerRadius = 8.0f;
    _orderBtn.layer.masksToBounds = YES;
    [self.view addSubview:_orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.top.equalTo(self.assessmentTxt.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(120, 40));
    }];
    [self.orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:UIControlEventTouchUpInside];

}

//联系商家
- (void)clickCallBtn:(UIButton *)button{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系商家" message:@"选择联系方式" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //直接拨打电话
        
        NSMutableString *strPhone = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.phoneStr];
        UIWebView *callWebView = [[UIWebView alloc]init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strPhone]]];
        [self .view addSubview:callWebView];
    }];
    
    UIAlertAction *msgAction = [UIAlertAction actionWithTitle:@"发送消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ue14&user_name=%@",MESSAGEURL,self.phoneStr];
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
            
            if (!kStringIsEmpty(responseObj[@"error"])){
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            } else  {
                EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:responseObj[@"data"][@"username"]];
                model.nickname = responseObj[@"data"][@"nickname"];
                model.avatarURLPath = [NSString stringWithFormat:@"http://%@",responseObj[@"data"][@"image"]];
                UIViewController *chatController = nil;
                chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
                NSString *nickName = model.nickname.length > 0 ? model.nickname : model.buddy;
                
                chatController.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:nickName];
                [self.navigationController pushViewController:chatController animated:YES];
            }
            
            
            
        } andFailedBlock:^(id responseObj) {
            
        } andIsHUD:NO];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:telAction];
    [alertController addAction:msgAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)clickOrderBtn:(UIButton *)button{
    /*/下单
//    //http://api.swktcx.com/A1/order.php?token=addOrderRecr&uid=10000&serve_id=210&buyer_address=重庆渝北&pay_moeny=100
//    NSDictionary *paramsDict = @{@"token":@"addOrderRecr",
//                                 @"uid":USER_UID,
//                                 @"serve_id":_serve_id,
//                                 @"buyer_address":self.buyerAddressStr,
//                                 @"pay_moeny":@"100"};
//    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramsDict andSuccessBlock:^(id responseObj) {
        
//
//        }
//    } andFailedBlock:^(id responseObj) {
//        
//    } andIsHUD:NO];*/
    TalentOrderViewController *orderVC = [[TalentOrderViewController alloc] init];
    orderVC.serve_id = self.serve_id;
    orderVC.serve_note = self.jobCategoryLbl.text;
    [self.navigationController pushViewController:orderVC animated:YES];
    
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
