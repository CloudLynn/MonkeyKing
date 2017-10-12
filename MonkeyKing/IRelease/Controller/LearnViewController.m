//
//  LearnViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "LearnViewController.h"

@interface LearnViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *_pickerView;
    NSArray *_typeArray;
}
///姓名
@property (nonatomic, strong) InputTextView *nameView;
///性别
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;
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

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"学习辅助";
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.right.equalTo(self.view.mas_right).offset(-120);
        make.height.mas_offset(@40);
    }];
    
    UILabel *manLbl = [UILabel new];
    manLbl.text = @"男";
    manLbl.font = FONT_15;
    [self.view addSubview:manLbl];
    UILabel *womanLbl = [UILabel new];
    womanLbl.text = @"女";
    womanLbl.font = FONT_15;
    [self.view addSubview:womanLbl];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_right).offset(5);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [manLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manBtn.mas_right).offset(5);
        make.centerY.equalTo(self.manBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manLbl.mas_right).offset(5);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [womanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.womanBtn.mas_right).offset(5);
        make.centerY.equalTo(self.womanBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.nameView.mas_bottom).offset(10);
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

- (BOOL)checkTxtNotNull{
    BOOL flag = NO;
    return flag;
}

- (void)clickSubmitBtn:(UIButton *)sender{
    
    if ([self checkTxtNotNull]) {
        
        [PublicMethod showAlert:self message:@"请填写完整信息"];
    } else {
        
        NSLog(@"提交");
    }
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

- (InputTextView *)nameView{
    if (!_nameView) {
        _nameView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"姓名"];
        _nameView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_nameView];
    }
    return _nameView;
}

- (UIButton *)manBtn{
    if (!_manBtn) {
        _manBtn = [UIButton new];
        [_manBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
        [self.view addSubview:_manBtn];
    }
    return _manBtn;
}

- (UIButton *)womanBtn{
    if (!_womanBtn) {
        _womanBtn = [UIButton new];
        [_womanBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
        [self.view addSubview:_womanBtn];
    }
    return _womanBtn;
}

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
