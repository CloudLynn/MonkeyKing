//
//  MyProductViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MyProductViewController.h"
#import "CommonProductViewController.h"
#import "MyProductTableViewCell.h"

@interface MyProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *productTableView;

@property (nonatomic, strong) NSArray *productArray;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation MyProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNumber = 1;
    
    [self initiallizeUserInterface];
    
    [self initializeDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeDataSource) name:@"addProduct" object:nil];
    
}

- (void)initiallizeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"服务产品";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加产品" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _productTableView = [[UITableView alloc] init];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    [self.view addSubview:_productTableView];
    [self.productTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-49-64));
    }];
    [self.productTableView registerClass:[MyProductTableViewCell class] forCellReuseIdentifier:@"productCell"];
    
    //下拉刷新,上拉加载
    self.productTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self initializeDataSource];
        [self.productTableView.mj_header endRefreshing];
    }];
    
    self.productTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber = _pageNumber+1;
        [self initializeDataSource];
        [self.productTableView.mj_footer endRefreshing];
    }];
    
}

- (void)initializeDataSource{
    if (!_productArray) {
        _productArray = [NSArray array];
    }
    //http://api.swktcx.com/A1/serve.php?token=commonPageInfo&serve_id=241&page=1&uid=10007
    NSDictionary *paramDic = @{@"token":@"commonPageInfo",
                               @"serve_id":_serve_id,
                               @"page":@(_pageNumber),
                               @"uid":USER_UID};
//    NSString *strUrl = [NSString stringWithFormat:@"%@token=commonPageInfo&serve_id=%@&page=1&uid=%@",SERVEURL,_serve_id,USER_UID];
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _productArray = responseObj[@"data"];
            [self.productTableView reloadData];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"查询产品列表 error");
    } andIsHUD:NO];
}

- (void)clickRightItem{
    CommonProductViewController *productVC = [[CommonProductViewController alloc] init];
    productVC.serve_id = self.serve_id;
    productVC.type_two = self.type_two;
    productVC.actionType = @"add";
    [self.navigationController pushViewController:productVC animated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyProductTableViewCell *cell = (MyProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"productCell"];
    if (!cell) {
        cell = [[MyProductTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"productCell"];
    }
    
    NSDictionary *dic = _productArray[indexPath.row];
    
    cell.nameLbl.text = dic[@"name"];
    cell.moneyLbl.text = [NSString stringWithFormat:@"%@ 元",dic[@"money"]];
    [cell.imgView sd_setImageWithURLString:dic[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    cell.changeBtn.tag = indexPath.row;
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.changeBtn addTarget:self action:@selector(clickChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)clickChangeBtn:(UIButton *)sender{
     //修改产品
    NSDictionary *dict = _productArray[sender.tag];
    CommonProductViewController *productVC = [[CommonProductViewController alloc] init];
    productVC.serve_id = dict[@"info_id"];
    productVC.type_two = self.type_two;
    productVC.actionType = @"update";
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void)clickDelBtn:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否真的要删除该产品？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //http://api.swktcx.com/A1/serve.php?token=removeInfo&uid=10000&info_id=22
        NSDictionary *dict = _productArray[sender.tag];
        NSDictionary *paramDict = @{@"token":@"removeInfo",
                                    @"uid":USER_UID,
                                    @"info_id":dict[@"info_id"],};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDict andSuccessBlock:^(id responseObj) {
            if ([responseObj[@"data"] isEqualToString:@"操作成功"]) {
                [PublicMethod showAlert:self message:@"已删除"];
                [self initializeDataSource];
            } else {
                [PublicMethod showAlert:self message:@"删除失败，请稍后重试"];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"删除失败error");
        } andIsHUD:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:delAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
