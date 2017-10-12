//
//  CommentViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) UITextField *addView;
//@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"评论";
    
    [self.commentTableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    
//    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(5);
//        make.top.equalTo(self.commentTableView.mas_bottom).offset(8);
//        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH-10, 40));
//    }];
//    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.top.equalTo(self.addView.mas_bottom).offset(5);
//        make.size.sizeOffset(CGSizeMake(50, 30));
//    }];
//    
//    [self.addBtn addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initializeDataSource{
    if (!_commentArray) {
        _commentArray = [NSMutableArray arrayWithCapacity:0];
    }
    //http://api.swktcx.com/A1/order.php?token=getRemark&uid=10000&serve_id=103
//    @"uid":USER_UID,
    NSDictionary *paramDic = @{@"token":@"getRemark",
                               @"serve_id":_serve_id,};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (!kStringIsEmpty(responseObj[@"error"])) {
            
            [PublicMethod showAlert:self message:@"暂无评论"];
            
        } else {
            _commentArray = responseObj[@"data"];
            [self.commentTableView reloadData];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"查看评论 error");
    } andIsHUD:NO];
}

//- (void)clickAddButton{
//    NSLog(@"我要添加评论");
//}

//- (UITextField *)addView{
//    if (!_addView) {
//        _addView = [[UITextField alloc] init];
//        _addView.placeholder = @"添加评论";
//        _addView.layer.borderColor = [[UIColor orangeColor] CGColor];
//        _addView.layer.borderWidth = 1.0f;
//        _addView.layer.cornerRadius = 8.0f;
//        _addView.layer.masksToBounds = YES;
//        [self.view addSubview:_addView];
//    }
//    return _addView;
//}
//
//- (UIButton *)addBtn{
//    if (!_addBtn) {
//        _addBtn = [UIButton new];
//        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
//        _addBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
//        [_addBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        _addBtn.layer.borderWidth = 1.0f;
//        _addBtn.layer.cornerRadius = 8.0f;
//        _addBtn.layer.masksToBounds = YES;
//        [self.view addSubview:_addBtn];
//    }
//    return _addBtn;
//}

- (UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-139)];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [self.view addSubview:_commentTableView];
    }
    return _commentTableView;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"commentCell"];
    }
    [cell setCommentDict:_commentArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
