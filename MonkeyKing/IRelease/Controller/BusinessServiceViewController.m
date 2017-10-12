//
//  BusinessServiceViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/1.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "BusinessServiceViewController.h"

@interface BusinessServiceViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *_pickerView;
    NSArray *_typeArray;
}
///手机
@property (nonatomic, strong) InputTextView *phoneView;
///价格
@property (nonatomic, strong) InputTextView *priceView;
///价格单位
@property (nonatomic, strong) InputTextView *unitPriceView;
///服务类型
@property (nonatomic, strong) InputTextView *typeView;
///服务范围
@property (nonatomic, strong) InputTextView *serviceScopeView;
///工作区域
@property (nonatomic, strong) InputTextView *workAreaView;
///说明
@property (nonatomic, strong) UITextView *noteView;
///提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation BusinessServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"商务服务";
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.phoneView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.unitPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.priceView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.unitPriceView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.serviceScopeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.typeView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.workAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.serviceScopeView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.workAreaView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@100);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.mas_offset(@40);
    }];
    
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init PickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    self.typeView.contentTxt.inputView = _pickerView;
}

- (void)initializeDataSource{
    
    if (!_typeArray) {
        _typeArray = [NSArray new];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@token=getNowSort&id=%@",SORTURL,_type_one];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _typeArray = responseObj[@"data"];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类ClassVC error====%@",responseObj);
    } andIsHUD:NO];
    
}

- (void)clickSubmitBtn:(UIButton *)sender{
    
    if ([self checkTxtNotNull]) {
        
        [PublicMethod showAlert:self message:@"请填写完整信息"];
    } else {
        
        NSLog(@"提交");
    }
}

- (BOOL)checkTxtNotNull{
    BOOL flag = NO;
    if (kStringIsEmpty(self.phoneView.contentTxt.text) || kStringIsEmpty(self.priceView.contentTxt.text) || kStringIsEmpty(self.unitPriceView.contentTxt.text) || kStringIsEmpty(self.typeView.contentTxt.text) || kStringIsEmpty(self.serviceScopeView.contentTxt.text) || kStringIsEmpty(self.workAreaView.contentTxt.text) || kStringIsEmpty(self.noteView.text)) {
        
        flag = YES;
        
    }
    return flag;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneView.contentTxt resignFirstResponder];
    [self.priceView.contentTxt resignFirstResponder];
    [self.unitPriceView.contentTxt resignFirstResponder];
    [self.typeView.contentTxt resignFirstResponder];
    [self.serviceScopeView.contentTxt resignFirstResponder];
    [self.workAreaView.contentTxt resignFirstResponder];
    [self.noteView resignFirstResponder];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _typeArray.count;
}

#pragma Mark -- UIPickerViewDelegate
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _typeArray[row][@"state"];
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.typeView.contentTxt.text = _typeArray[row][@"state"];
}

#pragma mark - initUI -
- (InputTextView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"手机"];
        _phoneView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_phoneView];
    }
    return _phoneView;
}

- (InputTextView *)priceView{
    if (!_priceView) {
        _priceView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"价格 ￥"];
        _priceView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_priceView];
    }
    return _priceView;
}

- (InputTextView *)unitPriceView{
    if (!_unitPriceView) {
        _unitPriceView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"价格单位"];
        _unitPriceView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_unitPriceView];
    }
    return _unitPriceView;
}

- (InputTextView *)typeView{
    if (!_typeView) {
        _typeView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"服务类型"];
        _typeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_typeView];
    }
    return _typeView;
}

- (InputTextView *)serviceScopeView{
    if (!_serviceScopeView) {
        _serviceScopeView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"服务范围"];
        _serviceScopeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_serviceScopeView];
    }
    return _serviceScopeView;
}

- (InputTextView *)workAreaView{
    if (!_workAreaView) {
        _workAreaView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"工作区域"];
        _workAreaView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_workAreaView];
    }
    return _workAreaView;
}

- (UITextView *)noteView{
    if (!_noteView) {
        _noteView = [UITextView new];
        _noteView.text = @"说明：";
        [self.view addSubview:_noteView];
    }
    return _noteView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:COLOR_RGB(0, 174, 249, 1.0)];
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
