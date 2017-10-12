//
//  SendResumeViewController.m
//  MonkeyKing2
//
//  Created by Apple on 2017/1/13.
//  Copyright © 2017年 zuoBao. All rights reserved.
//

#import "SendResumeViewController.h"

#define FONTSIZE [UIFont systemFontOfSize:15.0f]

@interface SendResumeViewController ()<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *typePicker;
@property (nonatomic, strong) UIPickerView *yearsPicker;
@property (nonatomic, strong) UIPickerView *salaryPicker;

@property (nonatomic, strong) NSArray *typeTwoArray;
@property (nonatomic, strong) NSArray *workYearsArray;
@property (nonatomic, strong) NSArray *salaryArray;

@property (nonatomic, strong) NSString *jobTwoStr;


//注意:定义一个成员变量,记录选中了第0列的哪一行.解决两列同时滚动脚标越界的问题.
@property(nonatomic,assign) NSInteger typeIndex;

@end

@implementation SendResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUserInterface];
    [self initializeDataSource];
}

- (void)initializeDataSource{
    if (!_typeTwoArray) {
        _typeTwoArray = [NSArray array];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@token=getNowSort&id=%@",SORTURL,self.type_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _typeTwoArray = responseObj[@"data"];
            [self.typePicker reloadAllComponents];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"人才超市error====%@",responseObj);
    } andIsHUD:NO];
    
    _workYearsArray = [NSArray arrayWithObjects:@"0-1年",@"1-2年",@"2-5年",@"5-10年", nil];
    _salaryArray = [NSArray arrayWithObjects:@"1-2k",@"2-3k",@"3-4k",@"4-6k",@"6-10k",@"10-15k",@">15k", nil];
    
    _typePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    self.typePicker.delegate = self;
    self.typePicker.dataSource = self;
    self.typePicker.tag = 201;
    self.jobCategoryTxt.inputView = self.typePicker;
    
    _yearsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    self.yearsPicker.delegate = self;
    self.yearsPicker.dataSource = self;
    self.yearsPicker.tag = 201;
    self.workingYearsTxt.inputView = self.yearsPicker;
    
    _salaryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    self.salaryPicker.delegate = self;
    self.salaryPicker.dataSource = self;
    self.salaryPicker.tag = 301;
    self.salaryatxt.inputView = self.salaryPicker;
    
    if ([_actionType isEqualToString:@"update"]) {
        //修改简历
        //http://api.swktcx.com/A1/serve.php?token=getRecr&serve_id=241
        NSString *urlStr = [NSString stringWithFormat:@"%@token=getRecr&serve_id=%@",SERVEURL,_serve_id];
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
            if (kStringIsEmpty(responseObj[@"error"])) {
                NSDictionary *dict = responseObj[@"data"];
                self.nameTxt.text = [NSString stringWithFormat:@"%@",dict[@"realname"]];
                if ([dict[@"sex"] isEqualToString:@"man"]) {
                    self.manBtn.selected = YES;
                }else{
                    self.womanBtn.selected = YES;
                }
                self.ageTxt.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
                self.householdTxt.text = [NSString stringWithFormat:@"%@",dict[@"first_address"]];
                self.addressTxt.text = [NSString stringWithFormat:@"%@",dict[@"now_address"]];
                self.schoolingTxt.text = [NSString stringWithFormat:@"%@",dict[@"education"]];
                self.salaryatxt.text = [NSString stringWithFormat:@"%@",dict[@"wage"]];
                for (NSDictionary *typeDict in _typeTwoArray) {
                    NSArray *twoarray = typeDict[@"down"];
                    if (twoarray.count == 0) {
                        if ([typeDict[@"type_two"] isEqualToString:dict[@"type_two"]]) {
                            _jobTwoStr = typeDict[@"id"];
                            self.jobCategoryTxt.text = [NSString stringWithFormat:@"%@",typeDict[@"state"]];
                        }
                    } else {
                        for (NSDictionary *typetwoDict in typeDict[@"down"]) {
                            if ([typetwoDict[@"id"] isEqualToString:dict[@"type_two"]]) {
                                _jobTwoStr = typeDict[@"id"];
                                self.jobCategoryTxt.text = [NSString stringWithFormat:@"%@ %@",typeDict[@"state"],typetwoDict[@"state"]];
                            }
                        }
                    }
                }
//                self.jobCategoryTxt.text = [NSString stringWithFormat:@"%@",dict[@"education"]];type
                self.workingYearsTxt.text = [NSString stringWithFormat:@"%@",dict[@"job_year"]];
                self.workExperienceTxt.text = [NSString stringWithFormat:@"%@",dict[@"undergo"]];
                self.expertiseTxt.text = [NSString stringWithFormat:@"%@",dict[@"appraise"]];
                self.rewardOrPunishmentTxt.text = [NSString stringWithFormat:@"%@",dict[@"gain"]];
                self.assessmentTxt.text = [NSString stringWithFormat:@"%@",dict[@"my_appraise"]];
                
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@/n简历查询error",responseObj);
        } andIsHUD:NO];
    }
    
}

- (void)keyboardWillHidden{
        [self.nameTxt resignFirstResponder];
        [self.ageTxt resignFirstResponder];
        [self.householdTxt resignFirstResponder];
        [self.addressTxt resignFirstResponder];
        [self.schoolingTxt resignFirstResponder];
        [self.salaryatxt resignFirstResponder];
        [self.jobCategoryTxt resignFirstResponder];
        [self.workingYearsTxt resignFirstResponder];
        [self.workExperienceTxt resignFirstResponder];
        [self.expertiseTxt resignFirstResponder];
        [self.rewardOrPunishmentTxt resignFirstResponder];
        [self.assessmentTxt resignFirstResponder];
}

#pragma mark - UIButtonTouchUpInside
- (void)clickManBtn:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.womanBtn.selected = NO;
    [_manBtn setImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
}

- (void)clickWomanBtn:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.manBtn.selected = NO;
    [_womanBtn setImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
    [_manBtn setImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
}

- (void)clickSubmitBtn:(UIButton *)sender{
    
    
    if ([self checkInputMessage]) {
        NSString *sex;
        if (self.manBtn.isSelected == YES) {
            sex = @"男";
        } else {
            sex = @"女";
        }
        /*发布token=recr&realname=真实姓名&sex=男&age=20&first_address=户籍地&now_address=现居地&education=学历&wage=1000&job_year=10&undergo=工作经历&appraise=技能专长&gain=所受奖惩&my_appraise=自我评价&type_one=294&type_two=319*/
        
       //修改token=setRecr&realname=SE真实姓名&sex=女&age=21&first_address=SET户籍地&now_address=SET现居地&education=博士&wage=10000~20000&job_year=3以上&undergo=SET工作经历&appraise=SET技能专长&gain=SET所受奖惩&my_appraise=SET自我评价&job_type =QW 保姆方面&type_two=319&serve_id=243
        
        NSDictionary *paramsDic;
        
        if ([_actionType isEqualToString:@"add"]) {
            paramsDic = @{@"token":@"recr",
                          @"uid":USER_UID,
                          @"realname":self.nameTxt.text,
                          @"sex":sex,
                          @"age":@([self.ageTxt.text integerValue]),
                          @"first_address":self.householdTxt.text,
                          @"now_address":self.addressTxt.text,
                          @"education":self.schoolingTxt.text,
                          @"wage":self.salaryatxt.text,
                          @"job_year":self.workingYearsTxt.text,
                          @"undergo":self.workExperienceTxt.text,
                          @"appraise":self.expertiseTxt.text,
                          @"gain":self.rewardOrPunishmentTxt.text,
                          @"my_appraise":self.assessmentTxt.text,
                          @"type_one":_type_id,
                          @"type_two":_jobTwoStr,
                          };
        } else if ([_actionType isEqualToString:@"update"]){
            paramsDic = @{@"token":@"setRecr",
                          @"uid":USER_UID,
                          @"realname":self.nameTxt.text,
                          @"sex":sex,
                          @"age":@([self.ageTxt.text integerValue]),
                          @"first_address":self.householdTxt.text,
                          @"now_address":self.addressTxt.text,
                          @"education":self.schoolingTxt.text,
                          @"wage":self.salaryatxt.text,
                          @"job_year":self.workingYearsTxt.text,
                          @"undergo":self.workExperienceTxt.text,
                          @"appraise":self.expertiseTxt.text,
                          @"gain":self.rewardOrPunishmentTxt.text,
                          @"my_appraise":self.assessmentTxt.text,
                          @"job_type":_type_id,
                          @"type_two":_jobTwoStr,
                          @"serve_id":_serve_id
                          };
        }
        
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramsDic andSuccessBlock:^(id responseObj) {
            
            NSLog(@"%@",responseObj);
            if (!kStringIsEmpty(responseObj[@"error"])) {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }else {
                [PublicMethod showAlert:self message:@"成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"发布简历error===%@",responseObj);
        } andIsHUD:NO];
    }
    
    
}

- (BOOL)checkInputMessage{
    
    BOOL flag = YES;
    
    if (kStringIsEmpty(self.nameTxt.text)) {
        [PublicMethod showAlert:self message:@"姓名不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.ageTxt.text)) {
        [PublicMethod showAlert:self message:@"年龄不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.householdTxt.text)) {
        [PublicMethod showAlert:self message:@"户籍不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.addressTxt.text)) {
        [PublicMethod showAlert:self message:@"现居地址不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.schoolingTxt.text)) {
        [PublicMethod showAlert:self message:@"学历不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.salaryatxt.text)) {
        [PublicMethod showAlert:self message:@"期望薪资不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.jobCategoryTxt.text)) {
        [PublicMethod showAlert:self message:@"职位类别不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.workingYearsTxt.text)) {
        [PublicMethod showAlert:self message:@"工作年限不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.workExperienceTxt.text)) {
        [PublicMethod showAlert:self message:@"工作经历不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.expertiseTxt.text)) {
        [PublicMethod showAlert:self message:@"技能专长不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.rewardOrPunishmentTxt.text)) {
        [PublicMethod showAlert:self message:@"所受奖惩不能为空"];
        flag = NO;
    } else if (kStringIsEmpty(self.assessmentTxt.text)) {
        [PublicMethod showAlert:self message:@"自我评价不能为空"];
        flag = NO;
    } else if (self.workExperienceTxt.text.length > 500) {
        [PublicMethod showAlert:self message:@"工作经历不能超过500字"];
        flag = NO;
    } else if (self.assessmentTxt.text.length > 500) {
        [PublicMethod showAlert:self message:@"自我评价不能超过500字"];
    }
    return flag;
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.typePicker) {
        return 2;
    } else {
        return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.salaryPicker) {
        
        return [self.salaryArray count];
        
    } else if (pickerView == self.typePicker){
        
        if (component == 0) {
            return self.typeTwoArray.count;
        }else{
            //取出选中的
            NSArray *downarray = self.typeTwoArray[_typeIndex][@"down"];
            return  downarray.count;
        }
        
    }else {
        
        return [self.workYearsArray count];
        
    }
}

#pragma Mark -- UIPickerViewDelegate
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.salaryPicker) {
        
        NSString *salaryStr = self.salaryArray[row];
        self.salaryatxt.text = salaryStr;
        
    } else if (pickerView == self.typePicker){
        
        if (component == 0) {
            
            _typeIndex = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
            
        }
        NSDictionary *dic = self.typeTwoArray[_typeIndex];
        NSArray *array = dic[@"down"];
        if (array.count>0) {
            NSInteger Index = [pickerView selectedRowInComponent:1];
            NSString *typetwo = dic[@"down"][Index][@"state"];
            _jobTwoStr = dic[@"down"][Index][@"id"];
            self.jobCategoryTxt.text = [NSString stringWithFormat:@"%@ %@",dic[@"state"],typetwo];
        } else {
            _jobTwoStr = dic[@"id"];
            self.jobCategoryTxt.text = [NSString stringWithFormat:@"%@",dic[@"state"]];
        }
        
        
        
    }else {
        
        NSString *yearsStr = self.workYearsArray[row];
        self.workingYearsTxt.text = yearsStr;
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.salaryPicker) {
        
        return [_salaryArray objectAtIndex:row];
        
    } else if (pickerView == self.typePicker){
        
        if (component == 0) {
            
            //记录当前选中的省会
            _typeIndex = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
            NSDictionary *dic = [self.typeTwoArray objectAtIndex:row];
            return dic[@"state"];
        }else{
            NSDictionary *dic = self.typeTwoArray[_typeIndex];
            //获取选中的城市
//            NSInteger Index = [pickerView selectedRowInComponent:1];
            NSString *typetwo = dic[@"down"][row][@"state"];
            return typetwo;
        }
        
        
    }else {
        
        return [_workYearsArray objectAtIndex:row];
        
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView.text.length < 1){
        if (textView.tag == 200) {
            textView.text = @"请输入工作经验（500字以内）";
        } else {
            textView.text = @"请输入自我评价（500字以内）";
        }
        
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 200){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    if (textView.tag == 300) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


#pragma mark - 初始化界面

- (void)initializeUserInterface{
    
    //初始化滚动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/3*4);
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.autoresizesSubviews = NO;
    [self.view addSubview:_mainScrollView];

    //title
    
    UILabel *nameLbl = [UILabel new];
    UILabel *sexLbl = [UILabel new];
    UILabel *ageLbl = [UILabel new];
    UILabel *householdLbl = [UILabel new];
    UILabel *addressLbl = [UILabel new];
    UILabel *schoolingLbl = [UILabel new];
    UILabel *salaryLbl = [UILabel new];
    UILabel *jobCategoryLbl = [UILabel new];
    UILabel *workingYearsLbl = [UILabel new];
    UILabel *workExperienceLbl = [UILabel new];//9
    UILabel *expertiseLbl = [UILabel new];
    UILabel *rewardOrPunishmentLbl = [UILabel new];
    UILabel *assessmentLbl = [UILabel new];    //12
    
    NSArray *strArray = @[@"姓名",@"性别",@"年龄",@"户籍",@"现居地址",@"学历",@"期望薪资",@"职位类别",@"工作年限",@"工作经历",@"技能专长",@"所受奖惩",@"自我评价"];
    NSArray *lblArray = [NSArray arrayWithObjects:nameLbl,sexLbl,ageLbl,householdLbl,addressLbl,schoolingLbl,salaryLbl,jobCategoryLbl,workingYearsLbl,workExperienceLbl,expertiseLbl,rewardOrPunishmentLbl,assessmentLbl, nil];
    
    for (int i = 0; i < strArray.count; i ++) {
        
        if(i >= 10) {
            UILabel *lbl = lblArray[i];
            [lbl setText:strArray[i]];
            [lbl setFont:FONTSIZE];
            [self.mainScrollView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(80, 30));
                make.top.equalTo(self.mainScrollView.mas_top).offset(110+i*44);
                make.left.equalTo(self.mainScrollView.mas_left).offset(8);
            }];
        } else {
            UILabel *lbl = lblArray[i];
            [lbl setText:strArray[i]];
            [lbl setFont:FONTSIZE];
            [self.mainScrollView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(80, 30));
                make.top.equalTo(self.mainScrollView.mas_top).offset(7+i*44);
                make.left.equalTo(self.mainScrollView.mas_left).offset(8);
            }];
        }
    }
    
    _nameTxt = [UITextField new];
    _nameTxt.placeholder = @"请输入姓名";
    _nameTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_nameTxt];
    [self.nameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(nameLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _manBtn = [UIButton new];
    [_manBtn setImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
    _manBtn.selected = YES;
    [self.mainScrollView addSubview:_manBtn];
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (sexLbl.mas_right).offset(15);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    UILabel *manLbl = [UILabel new];
    manLbl.text = @"男";
    manLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:manLbl];
    [manLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manBtn.mas_right).offset(15);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    _womanBtn = [UIButton new];
    [_womanBtn setImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
    _womanBtn.selected = NO;
    [self.mainScrollView addSubview:_womanBtn];
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manLbl.mas_right).offset(15);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    UILabel *womanLbl = [UILabel new];
    womanLbl.text = @"女";
    womanLbl.font = FONTSIZE;
    [self.mainScrollView addSubview:womanLbl];
    [womanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.womanBtn.mas_right).offset(15);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    _ageTxt = [UITextField new];
    _ageTxt.placeholder = @"请输入年龄";
    _ageTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_ageTxt];
    [self.ageTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ageLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(ageLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _householdTxt = [UITextField new];
    _householdTxt.placeholder = @"请输入户籍所在地";
    _householdTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_householdTxt];
    [self.householdTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(householdLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(householdLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _addressTxt = [UITextField new];
    _addressTxt.placeholder = @"请输入现居住地址";
    _addressTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_addressTxt];
    [self.addressTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(addressLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _schoolingTxt = [UITextField new];
    _schoolingTxt.placeholder = @"请输入学历信息";
    _schoolingTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_schoolingTxt];
    [self.schoolingTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(schoolingLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(schoolingLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _salaryatxt = [UITextField new];
    _salaryatxt.placeholder = @"请选择您的期望薪资";
    _salaryatxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_salaryatxt];
    [self.salaryatxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(salaryLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(salaryLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _jobCategoryTxt = [UITextField new];
    _jobCategoryTxt.placeholder = @"请选择职位类别";
    _jobCategoryTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_jobCategoryTxt];
    [self.jobCategoryTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jobCategoryLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(jobCategoryLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _workingYearsTxt = [UITextField new];
    _workingYearsTxt.placeholder = @"请选择工作年限";
    _workingYearsTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_workingYearsTxt];
    [self.workingYearsTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workingYearsLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(workingYearsLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _workExperienceTxt = [UITextView new];
    _workExperienceTxt.text = @"请输入工作经验（500字以内）";
    _workExperienceTxt.delegate = self;
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
    
    _expertiseTxt = [UITextField new];
    _expertiseTxt.placeholder = @"请输入技能特长";
    _expertiseTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_expertiseTxt];
    [self.expertiseTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expertiseLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(expertiseLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _rewardOrPunishmentTxt = [UITextField new];
    _rewardOrPunishmentTxt.placeholder = @"请输入奖惩情况";
    _rewardOrPunishmentTxt.font = FONTSIZE;
    [self.mainScrollView addSubview:_rewardOrPunishmentTxt];
    [self.rewardOrPunishmentTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardOrPunishmentLbl.mas_right).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.centerY.equalTo(rewardOrPunishmentLbl.mas_centerY);
        make.height.mas_offset(30);
    }];
    
    _assessmentTxt = [UITextView new];
    _assessmentTxt.text = @"请输入自我评价（500字以内）";
    _assessmentTxt.delegate = self;
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
    
    _submitBtn = [[UIButton alloc] init];
    [_submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    _submitBtn.backgroundColor = COLOR_RGB(0, 174, 249, 1.0);
    [self.mainScrollView addSubview:_submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.assessmentTxt.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_offset(40);
    }];
    
    //选择性别
    [self.manBtn addTarget:self action:@selector(clickManBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanBtn addTarget:self action:@selector(clickWomanBtn:) forControlEvents:UIControlEventTouchUpInside];
    //滚蛋视图添加单击手势
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardWillHidden)];
    [self.mainScrollView addGestureRecognizer:tapges];
    //提交按钮
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
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
