//
//  AgreementViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/9.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (nonatomic, strong) UITextView *agreementTxt;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    self.navigationItem.title = @"用户协议";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _agreementTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_agreementTxt];
}

- (void)initializeDataSource{
    NSString *urlStr = @"http://api.swktcx.com/A1/global.php?token=protocol";
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
        self.agreementTxt.text = responseObj[@"data"][@"text"];
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
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
