//
//  TypeDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TypeDetailViewController.h"
#import "TypeDetailView.h"
#import "TypeDetailTableViewCell.h"
#import "CommentViewController.h"
#import "InfoModel.h"
#import "CartModel.h"
#import "PlaceOrderViewController.h"
#import "PrintObject.h"
#import "NSString+DicArrToJson.h"
#import "ChatViewController.h"

@interface TypeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TypeDetailViewDelegate>

@property (nonatomic, strong) TypeDetailView *topView;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *imgUrl;

@end

@implementation TypeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(@150);
    }];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgViewSingelAction)];
    [self.topView.headImgView addGestureRecognizer:tapges];
    
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-89);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-54);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-40, 40));
    }];
    [self.callBtn addTarget:self action:@selector(clickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-54);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-40, 40));
    }];
    [self.orderBtn addTarget:self action:@selector(clickOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailTableView registerClass:[TypeDetailTableViewCell class] forCellReuseIdentifier:@"detailCell"];
}

- (void)initializeDataSource{
    //token=serveAll&serve_id=203&lng=106.484686&lat=29.531369
    
    if (!_infoArray) {
        _infoArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSDictionary *paramDict = @{@"token":@"serveAll",
                                @"serve_id":_serve_id,
                                @"lng":USER_LNG,
                                @"lat":USER_LAT,};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDict andSuccessBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObj[@"data"]];
        [_topView setDetailDictionary:dic];
        
        NSArray *array= responseObj[@"data"][@"info"];
        for (NSDictionary *dict in array) {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dict1 setObject:@"NO" forKey:@"isSelect"];
            [dict1 setObject:@(0) forKey:@"count"];
            [_infoArray addObject:dict1];
        }
        
        _phoneStr = responseObj[@"data"][@"phone"];
        _imgUrl = responseObj[@"data"][@"image"];
        
        [self.detailTableView reloadData];
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
    if ([[CartModel sharedInstance] currentInfosCount] > 0) {
        [[CartModel sharedInstance] clearCart];
    }
    
}

- (void)headImgViewSingelAction{
    //创建一个黑色视图做背景
    ImgBgView *bgView = [[ImgBgView alloc]initWithFrame:self.view.bounds andImgUrl:_imgUrl];
    bgView.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
    [self.view addSubview:bgView];
}

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
                chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
                [self.navigationController pushViewController:chatController animated:YES];
            }
            
            //            NSDictionary *dict = ;
            
            
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
    if (ISLOGIN) {
        if ([CartModel sharedInstance].infosArr.count <1) {
            [PublicMethod showAlert:self message:@"您还未确定添加服务"];
        } else {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
            [dict setObject:USER_UID forKey:@"uid"];
            [dict setObject:_serve_id forKey:@"serve_id"];
            [dict setObject:[[CartModel sharedInstance] currentInfosAmount] forKey:@"pay_moeny"];
            
            //将产品对象转化为字典
            NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
            for (InfoModel *infoM in [CartModel sharedInstance].infosArr) {
                NSDictionary *dictInfo = [PrintObject getObjectData:infoM];
                NSString *count = [NSString stringWithFormat:@"%.2f",infoM.product_count];
                [dictInfo setValue:count forKey:@"product_count"];
                [infoArray addObject:dictInfo];
            }
            NSString *aqeq  = [NSString jsonStringWithObject:infoArray];
            [dict setObject:aqeq forKey:@"info"];
            
            PlaceOrderViewController *placeOrderVC = [[PlaceOrderViewController alloc] init];
            placeOrderVC.orderDict = dict;
            placeOrderVC.serviceName = self.topView.nameLbl.text;
            [self.navigationController pushViewController:placeOrderVC animated:YES];
        }
    } else {
        [PublicMethod showAlert:self message:@"您还未登录，请先去登录"];
    }
    
}

- (TypeDetailView *)topView{
    if (!_topView) {
        _topView = [[TypeDetailView alloc] initWithFrame:CGRectZero];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (void)clickCommentBtn{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.title = @"评论";
    commentVC.serve_id = _serve_id;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(UITableView *)detailTableView{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] init];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        [self.view addSubview:_detailTableView];
    }
    return _detailTableView;
}

- (UIButton *)callBtn{
    if (!_callBtn) {
        _callBtn = [UIButton new];
        [_callBtn setImage:[UIImage imageNamed:@"callImg"] forState:UIControlStateNormal];
        [self.view addSubview:_callBtn];
    }
    return _callBtn;
}
- (UIButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [UIButton new];
        [_orderBtn setTitle:@"下单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _orderBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _orderBtn.layer.borderWidth = 1.0f;
        _orderBtn.layer.cornerRadius = 5.0f;
        _orderBtn.layer.masksToBounds = YES;
        [self.view addSubview:_orderBtn];
    }
    return _orderBtn;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeDetailTableViewCell *cell = (TypeDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (!cell) {
        cell = [[TypeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    }
    NSDictionary *dict = _infoArray[indexPath.row];
    [cell setContentDict:dict];
    
    __weak __typeof(&*self)weakSelf = self;
    [cell clickSelectBlock:^(UIButton *btn) {
        NSIndexPath *index = [tableView indexPathForView:btn andTabelView:tableView];
        NSDictionary *dic = _infoArray[index.row];
        InfoModel *info = [[InfoModel alloc]init];
        if (!info) {
            info = [[InfoModel alloc] init];
            info.info_id = dic[@"info_id"];
            info.product_count = 0;
            info.product_name = dic[@"name"];
            info.product_cost = dic[@"money"];
        }
        if ([dict[@"isSelect"] isEqualToString:@"NO"]) {
            cell.countTxt.enabled = NO;
            [[CartModel sharedInstance] addInfo:info andCount:[cell.countTxt.text doubleValue]];
            cell.countTxt.text = [NSString stringWithFormat:@"%.2f",[[CartModel sharedInstance] infoAddCartNum:info.info_id]];
            [weakSelf changeClickDatasource:dic];
        }else{
            cell.countTxt.enabled = YES;
            //减去该类商品
            [[CartModel sharedInstance] reduceAllWithInfo:info];
            cell.countTxt.text = [NSString stringWithFormat:@"%.2f",[[CartModel sharedInstance] infoAddCartNum:info.info_id]];
            [weakSelf changeRemoveDatasource:dic];
        }
    }];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImgViewSingelAction:)];
    //给图片添加手势
    cell.proImgView.userInteractionEnabled = YES;
    [cell.proImgView addGestureRecognizer:tapges];
    cell.proImgView.tag = indexPath.row;
    
    return cell;
}

-(void)changeClickDatasource:(NSDictionary *)model{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSMutableDictionary *dict in _infoArray) {
        if ([dict[@"info_id"] isEqualToString:model[@"info_id"]]) {
            [dict setObject:@"YES" forKey:@"isSelect"];
        }
        [arr addObject:dict];
    }
    [_infoArray removeAllObjects];
    [_infoArray addObjectsFromArray:arr];
    [self.detailTableView reloadData];
}

-(void)changeRemoveDatasource:(NSDictionary *)model{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSMutableDictionary *dict in _infoArray) {
        if ([dict[@"info_id"] isEqualToString:model[@"info_id"]]) {
            [dict setObject:@"NO" forKey:@"isSelect"];
        }
        [arr addObject:dict];
    }
    [_infoArray removeAllObjects];
    [_infoArray addObjectsFromArray:arr];
    [self.detailTableView reloadData];
}

- (void)ImgViewSingelAction:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *v = (UIView *)[gestureRecognizer view];
    NSDictionary *detailDict = [_infoArray objectAtIndex:v.tag];
    NSString *url = detailDict[@"image"];
    //创建一个黑色视图做背景
    
    ImgBgView *bgView = [[ImgBgView alloc]initWithFrame:self.view.bounds andImgUrl:url];
    bgView.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
    [self.view addSubview:bgView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
