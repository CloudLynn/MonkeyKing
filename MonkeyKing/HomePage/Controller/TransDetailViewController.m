//
//  TransDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransDetailViewController.h"
#import "CommentViewController.h"
#import "TransMapViewController.h"
//#import "XJLStarView.h"
#import "EvaluateView.h"

@interface TransDetailViewController ()

///头像
@property (nonatomic, strong) UIImageView *headImgView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///性别
@property (nonatomic, strong) UILabel *sexLbl;
///接单次数
@property (nonatomic, strong) UILabel *orderTimesLbl;
///星级
@property (nonatomic, strong) EvaluateView *starView;
///查看评论
@property (nonatomic, strong) UIButton *commentBtn;
///工号
@property (nonatomic, strong) UILabel *workNumLbl;
///去哪儿
@property (nonatomic, strong) UIButton *goBtn;
///起步价
@property (nonatomic, strong) UILabel *startLbl;
///乘运价
@property (nonatomic, strong) UILabel *transLbl;
///车内照片
@property (nonatomic, strong) UIImageView *incarImgView;
///车位照片
@property (nonatomic, strong) UIImageView *outcarImgView;
///说明
@property (nonatomic, strong) UITextView *noteTxt;

@property (nonatomic, strong) NSDictionary *dataDictionary;


@end

@implementation TransDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialiseUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initialiseUserInterface{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat centerY = SCREEN_WIDTH/2;
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgView.mas_top);
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-centerY-4);
        make.height.mas_offset(@30);
    }];
    
    [self.sexLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImgView.mas_bottom);
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-centerY-4);
        make.height.mas_offset(@30);
    }];
    
    [self.orderTimesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(centerY+4);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@25);
    }];
    UILabel *star = [UILabel new];
    star.text = @"星级";
    star.font = FONT_15;
    [self.view addSubview:star];
    [star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(centerY+4);
        make.top.equalTo(self.orderTimesLbl.mas_bottom).offset(8);
        make.width.mas_offset(@50);
        make.height.mas_offset(@25);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(star.mas_right).offset(4);
        make.centerY.equalTo(star.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@20);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(centerY+4);
        make.top.equalTo(self.starView.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@25);
    }];
    
    for (int i = 0;  i<3; i++) {
        UILabel *line = [UILabel new];
        line.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_top).offset(170+40*i);
            make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 1));
        }];
    }
    
    [self.workNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(175);
        make.right.equalTo(self.view.mas_right).offset(centerY+4);
        make.height.mas_offset(@30);
    }];
    
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.workNumLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.startLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(215);
        make.right.equalTo(self.view.mas_right).offset(-centerY-40);
        make.height.mas_offset(@30);
    }];
    
    [self.transLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startLbl.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(215);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@30);
    }];
    UILabel *incar = [UILabel new];
    incar.text = @"车内照片";
    incar.font = FONT_15;
    [self.view addSubview:incar];
    [incar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(centerY/2-40);
        make.top.equalTo(self.startLbl.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    UILabel *outcar = [UILabel new];
    outcar.text = @"车外照片";
    outcar.font = FONT_15;
    [self.view addSubview:outcar];
    [outcar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-centerY/2+40);
        make.top.equalTo(self.startLbl.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    [self.incarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incar.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.sizeOffset(CGSizeMake(centerY-40, centerY-40));
    }];
    
    [self.outcarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incar.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.size.sizeOffset(CGSizeMake(centerY-40, centerY-40));
    }];
    
    [self.noteTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.incarImgView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH-40, centerY-40));
    }];
    // 头像 姓名 性别 接单次数/星级/查看评论/工号/去哪儿/起步价 乘运价 /车内照片//车位照片//说明
    
    [self.commentBtn addTarget:self action:@selector(clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [self.goBtn addTarget:self action:@selector(clickGoButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initializeDataSource{
    
    if (!_dataDictionary) {
        _dataDictionary = [NSDictionary new];
    }
    
    //http://api.swktcx.com/A1/serve.php?token=tourOne&serve_id=239
    NSString *strUrl = [NSString stringWithFormat:@"%@token=tourOne&serve_id=%@",SERVEURL,_serve_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            
            self.dataDictionary = responseObj;
            NSLog(@"%@",responseObj[@"data"]);
            [self.headImgView sd_setImageWithURLString:responseObj[@"data"][@"image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
            self.nameLbl.text = responseObj[@"data"][@"realname"];
            self.sexLbl.text = responseObj[@"data"][@"sex"];
            self.orderTimesLbl.text = [NSString stringWithFormat:@"本月接单次数：%@",responseObj[@"data"][@"current_number"]];
            CGFloat level = [responseObj[@"data"][@"level"] doubleValue];
            [self.starView showsStarsWithCounts:level];
//            self.starView.showStar = (level+1)*20;
            self.workNumLbl.text = [NSString stringWithFormat:@"工号：%@",responseObj[@"data"][@"worknumber"]];
            self.startLbl.text = [NSString stringWithFormat:@"起始价：￥%@",responseObj[@"data"][@"start"]];
            self.transLbl.text = [NSString stringWithFormat:@"乘运价：%@ 元/公里*小时",responseObj[@"data"][@"course"]];
            [self.incarImgView sd_setImageWithURLString:responseObj[@"data"][@"in_car"] placeholderImage:[UIImage imageNamed:@"appImg"]];
            [self.outcarImgView sd_setImageWithURLString:responseObj[@"data"][@"ex_car"] placeholderImage:[UIImage imageNamed:@"appImg"]];
            self.noteTxt.text = [NSString stringWithFormat:@"说明：%@",responseObj[@"data"][@"name"]];
        } else {
            
            [PublicMethod showAlert:self message:responseObj[@"error"]];
            
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"乘运详情查询 error");
    } andIsHUD:NO];
}

- (void)clickCommentButton{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.serve_id = _serve_id;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)clickGoButton{
    TransMapViewController *mapVC = [[TransMapViewController alloc] init];
    mapVC.title = @"详情";
    mapVC.startStr = _dataDictionary[@"data"][@"start"];
    mapVC.transStr = _dataDictionary[@"data"][@"course"];
    mapVC.phoneStr = _dataDictionary[@"data"][@"phone"];
    mapVC.serve_id = self.serve_id;
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - initUi -
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = 35;
        _headImgView.layer.masksToBounds = YES;
        [self.view addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.font = FONT_15;
        [self.view addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)sexLbl{
    if (!_sexLbl) {
        _sexLbl = [UILabel new];
        _sexLbl.font = FONT_15;
        [self.view addSubview:_sexLbl];
    }
    return _sexLbl;
}

- (UILabel *)orderTimesLbl{
    if (!_orderTimesLbl) {
        _orderTimesLbl = [UILabel new];
        _orderTimesLbl.font = FONT_15;
        [self.view addSubview:_orderTimesLbl];
    }
    return _orderTimesLbl;
}

- (EvaluateView *)starView{
    if (!_starView) {
        _starView = [[EvaluateView alloc]initWithFrame:CGRectZero count:5];
        [self.view addSubview:_starView];
    }
    return _starView;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
        [_commentBtn setTitle:@"查看评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _commentBtn.layer.borderWidth = 1.0f;
        _commentBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _commentBtn.layer.cornerRadius = 8;
        _commentBtn.layer.masksToBounds = YES;
        [self.view addSubview:_commentBtn];
    }
    return _commentBtn;
}

- (UILabel *)workNumLbl{
    if (!_workNumLbl) {
        _workNumLbl = [UILabel new];
        _workNumLbl.font = FONT_15;
        [self.view addSubview:_workNumLbl];
    }
    return _workNumLbl;
}

- (UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton new];
        [_goBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_goBtn setTitle:@"您要去哪里" forState:UIControlStateNormal];
        _goBtn.layer.borderWidth = 1.0f;
        _goBtn.layer.borderColor = [[UIColor redColor] CGColor];
        _goBtn.layer.cornerRadius = 8;
        _goBtn.layer.masksToBounds = YES;
        [self.view addSubview:_goBtn];
    }
    return _goBtn;
}

- (UILabel *)startLbl{
    if (!_startLbl) {
        _startLbl = [UILabel new];
        _startLbl.font = FONT_15;
        [self.view addSubview:_startLbl];
    }
    return _startLbl;
}

- (UILabel *)transLbl{
    if (!_transLbl) {
        _transLbl = [UILabel new];
        _transLbl.font = FONT_15;
        [self.view addSubview:_transLbl];
    }
    return _transLbl;
}

- (UIImageView *)incarImgView{
    if (!_incarImgView) {
        _incarImgView = [UIImageView new];
        [self.view addSubview:_incarImgView];
    }
    return _incarImgView;
}

- (UIImageView *)outcarImgView{
    if (!_outcarImgView) {
        _outcarImgView = [UIImageView new];
        [self.view addSubview:_outcarImgView];
    }
    return _outcarImgView;
}

- (UITextView *)noteTxt{
    if (!_noteTxt) {
        _noteTxt = [UITextView new];
        _noteTxt.font = FONT_15;
        _noteTxt.userInteractionEnabled = NO;
        [self.view addSubview:_noteTxt];
    }
    return _noteTxt;
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
