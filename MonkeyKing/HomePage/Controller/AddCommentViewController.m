 //
//  AddCommentViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

@property (nonatomic, strong) UITextView *commentView;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加评论";
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@100);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.top.equalTo(self.commentView.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.mas_offset(@30);
    }];
    
    [self.submitBtn addTarget:self action:@selector(clickAddCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickAddCommentBtn{
    //http://api.swktcx.com/A1/order.php?token=remark&uid=10000&text=ok&level=1&order_id=103
    if (self.commentView.text.length < 10) {
        [PublicMethod showAlert:self message:@"请至少评价十个字"];
    } else {
        NSDictionary *paramDict = @{@"token":@"remark",
                                    @"uid":USER_UID,
                                    @"text":self.commentView.text};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"state"] boolValue] == true && [responseObj[@"data"] isEqualToString:@"评论成功"]) {
                [PublicMethod showAlert:self message:@"评论成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"添加评论");
        } andIsHUD:NO];
    }
}


#pragma mark - initUI -
- (UITextView *)commentView{
    if (!_commentView) {
        _commentView = [UITextView new];
        [self.view addSubview:_commentView];
    }
    return _commentView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        _submitBtn.layer.cornerRadius = 12.0f;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _submitBtn.layer.borderWidth = 1.0f;
        _submitBtn.titleLabel.textColor = [UIColor orangeColor];
        [_submitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
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
