//
//  ReceivedOrderViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ReceivedOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "CommentViewController.h"
#import "ChatViewController.h"

@interface ReceivedOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, assign) NSInteger pageNumber;


@end

@implementation ReceivedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNumber = 1;
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"收到的订单";
    
    _orderTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_orderTableView];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    
    [self.orderTableView registerClass:[MyOrderTableViewCell class] forCellReuseIdentifier:@"myOrderCell"];
    
    //下拉刷新,上拉加载
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self initializeDataSource];
        [self.orderTableView.mj_header endRefreshing];
    }];
    
    self.orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber = _pageNumber+1;
        [self initializeDataSource];
        [self.orderTableView.mj_footer endRefreshing];
    }];
}

- (void)initializeDataSource{
    //http://api.swktcx.com/A1/order.php?token=getMyOrderSeller&uid=10000&page=1
    //http://api.swktcx.com/A1/order.php?token=getMyOrderSeller&uid=10000&page=1
    if (!_orderArray) {
        _orderArray = [NSArray array];
    }
    
    NSDictionary *paramDict = @{@"token":@"getMyOrderSeller",
                                @"uid":USER_UID,
                                @"page":@(_pageNumber),};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        
        
        if (kStringIsEmpty(responseObj[@"error"])) {
            _orderArray = [responseObj objectForKey:@"data"];
            [self.orderTableView reloadData];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
}

- (void)clickRightItem{
    ReceivedOrderViewController *receiveVC = [[ReceivedOrderViewController alloc] init];
    [self.navigationController pushViewController:receiveVC animated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myOrderCell"];
    if (!cell) {
        cell = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myOrderCell"];
    }
    [cell.callSellerBtn setTitle:@"联系买家" forState:UIControlStateNormal];
    NSDictionary *detailDict = [_orderArray objectAtIndex:indexPath.row];
    [cell setDetailDict:detailDict];
    
    
    //给图片添加手势
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImgViewSingelAction:)];
    cell.proImgView.userInteractionEnabled = YES;
    [cell.proImgView addGestureRecognizer:tapges];
    cell.proImgView.tag = indexPath.row;
    
    //按钮点击事件
    cell.firstBtn.tag = indexPath.row;
    cell.secondBtn.tag = indexPath.row;
    NSInteger saleType = [detailDict[@"sale_type"] integerValue];
    switch (saleType) {
//        case 0:{
//            //未付款
//            [cell.firstBtn setTitle:@"确认付款" forState:UIControlStateNormal];
//            cell.secondBtn.hidden = YES;
//            [cell.firstBtn addTarget:self action:@selector(paymentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
        case 1:{
            //对方已付款，商家是否接单
            [cell.firstBtn setTitle:@"确认接单" forState:UIControlStateNormal];
            cell.secondBtn.hidden = NO;
            [cell.secondBtn setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [cell.firstBtn addTarget:self action:@selector(confirmOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.secondBtn addTarget:self action:@selector(refuseOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2:{
            //等待对方确认完成
            cell.firstBtn.hidden = YES;
            cell.secondBtn.hidden = YES;
        }
            break;
        case 3:{
            //交易成功
            cell.firstBtn.hidden = YES;
            cell.secondBtn.hidden = YES;
        }
            break;
        case 4:{
            //对方已作评价
            [cell.firstBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            [cell.secondBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.firstBtn addTarget:self action:@selector(lookCommentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.secondBtn addTarget:self action:@selector(delOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case -1:{
            //对方申请退款
            [cell.firstBtn setTitle:@"同意退款" forState:UIControlStateNormal];
            [cell.secondBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
            [cell.firstBtn addTarget:self action:@selector(agreeRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.secondBtn addTarget:self action:@selector(refusedRefundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case -2:{
            //退款成功
            [cell.firstBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            cell.secondBtn.hidden = YES;
            [cell.firstBtn addTarget:self action:@selector(delOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case -9:{
            //退款失败
        }
            break;
            
        default:
            break;
    }
    
    //联系商家
    cell.callSellerBtn.tag = indexPath.row;
    [cell.callSellerBtn addTarget:self action:@selector(clickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)ImgViewSingelAction:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *v = (UIView *)[gestureRecognizer view];
    NSDictionary *detailDict = [_orderArray objectAtIndex:v.tag];
    NSString *url = detailDict[@"image"];
    //创建一个黑色视图做背景
    
    ImgBgView *bgView = [[ImgBgView alloc]initWithFrame:self.view.bounds andImgUrl:url];
    bgView.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
    [self.view addSubview:bgView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSDictionary *detailDict = [_orderArray objectAtIndex:indexPath.row];
    
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.order_id = detailDict[@"order_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
 
#pragma mark - 按钮点击事件 -

//联系商家
- (void)clickCallBtn:(UIButton *)button{
    
    NSDictionary *dict = [_orderArray objectAtIndex:button.tag];
    NSMutableString *strPhone = [[NSMutableString alloc]initWithFormat:@"tel:%@",dict[@"phone"]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系买家" message:@"选择联系方式" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //直接拨打电话
        
        UIWebView *callWebView = [[UIWebView alloc]init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strPhone]]];
        [self.view addSubview:callWebView];
    }];
    
    UIAlertAction *msgAction = [UIAlertAction actionWithTitle:@"发送消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ue14&user_name=%@",MESSAGEURL,dict[@"phone"]];
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

//确认接单
- (void)confirmOrderBtnAction:(UIButton *)sender {
    NSLog(@"确认接单");
    //http://api.swktcx.com/A1/order.php?token=sellerVerify&uid=10001&order_id=122
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    NSDictionary *paramDict = @{@"token":@"sellerVerify",
                                @"uid":USER_UID,
                                @"order_id":dict[@"order_id"]};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        
        if ([responseObj[@"state"] boolValue] == true) {
            [PublicMethod showAlert:self message:responseObj[@"data"]];
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@", responseObj);
        NSLog(@"确认接单");
    } andIsHUD:NO];
}
//拒绝接单
- (void)refuseOrderBtnAction:(UIButton *)sender{
    NSLog(@"商家拒绝接单");
    //http://api.swktcx.com/A1/order.php?token=sellerReject&uid=10001&order_id=122
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    NSDictionary *paramDict = @{@"token":@"sellerReject",
                                @"uid":USER_UID,
                                @"order_id":dict[@"order_id"]};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        
        if ([responseObj[@"state"] boolValue] == true) {
            [PublicMethod showAlert:self message:responseObj[@"data"]];
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@", responseObj);
        NSLog(@"确认接单");
    } andIsHUD:NO];
}

//删除订单
- (void)delOrderBtnAction:(UIButton *)sender{
    //http://api.swktcx.com/A1/order.php?token=remove_seller&uid=10000&order_id=81
    NSLog(@"删除");
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    NSDictionary *paramDict = @{@"token":@"remove_seller",
                                @"uid":USER_UID,
                                @"order_id":dict[@"order_id"]};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        
        if ([responseObj[@"data"] isEqualToString:@"删除成功"]) {
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@", responseObj);
        NSLog(@"删除订单");
    } andIsHUD:NO];
    
}

//查看评价
- (void)lookCommentBtnAction:(UIButton *)sender{
    NSLog(@"查看评价");
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.serve_id = dict[@"serve_id"];
    [self.navigationController pushViewController:commentVC animated:YES];
}


//同意退款
- (void)agreeRefundBtn:(UIButton *)sender {
    //确定退款
    NSLog(@"退款");
    //http://api.swktcx.com/A1/order.php?token=sellerQuit&uid=10001&order_id=123&choose=1
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    NSDictionary *paramDict = @{@"token":@"sellerQuit",
                                @"uid":USER_UID,
                                @"order_id":dict[@"order_id"],
                                @"choose":@"1"};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
    
        if (kStringIsEmpty(responseObj[@"error"]) && [responseObj[@"state"] boolValue] == true) {
            [PublicMethod showAlert:self message:responseObj[@"data"]];
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
            [self initializeDataSource];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"卖家退款error");
    } andIsHUD:NO];
    
}
//拒绝退款
- (void)refusedRefundBtnAction:(UIButton *)sender{
    NSLog(@"拒绝退款");
    //http://api.swktcx.com/A1/order.php?token=sellerQuit&uid=10001&order_id=123&choose=0
    NSDictionary *dict = [_orderArray objectAtIndex:sender.tag];
    NSDictionary *paramDict = @{@"token":@"sellerQuit",
                                @"uid":USER_UID,
                                @"order_id":dict[@"order_id"],
                                @"choose":@"1"};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        
        if (kStringIsEmpty(responseObj[@"error"]) && [responseObj[@"state"] boolValue] == true) {
            [PublicMethod showAlert:self message:responseObj[@"data"]];
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
            [self initializeDataSource];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"卖家退款error");
    } andIsHUD:NO];
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
