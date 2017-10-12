//
//  CommonReleaseViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/7.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "CommonReleaseViewController.h"
#import "YJLocationPicker.h"
#import "MyServiceViewController.h"

@interface CommonReleaseViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSArray *_typeArray;
    NSString *cityone,*citytwo,*citythree;
    NSString *typeTwo;
    UIImage *headImg;
    
}

@property (nonatomic, strong) UIImageView *topImgView;
///普通服务名称
@property (nonatomic, strong) UITextField *nameTxt;
///联系人名字
@property (nonatomic, strong) UITextField *contactTxt;
///联系电话
@property (nonatomic, strong) UITextField *phoneTxt;
///选择地区
@property (nonatomic, strong) UIButton *areaBtn;
///选择类别
@property (nonatomic, strong) UITextField *typeTxt;
///确定
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIPickerView *typePickerView;

@end

@implementation CommonReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headImg = [UIImage imageNamed:@"appImg"];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
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
    
    
    if ([_actionType isEqualToString:@"update"]) {
        NSDictionary *paramDict = @{@"token":@"getCommon",
                                    @"serve_id":_serve_id};
//        NSDictionary *paramDict = @{@"token":@"serveAll",
//                                    @"serve_id":_serve_id,
//                                    @"lng":USER_LNG,
//                                    @"lat":USER_LAT,};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if (kStringIsEmpty(responseObj[@"error"])) {
                self.nameTxt.text = responseObj[@"data"][@"name"];
                self.contactTxt.text = responseObj[@"data"][@"realname"];
                self.phoneTxt.text = responseObj[@"data"][@"phone"];
                for (NSDictionary *dic in _typeArray) {
                    if ([responseObj[@"data"][@"type_two"] isEqualToString: dic[@"id"]]) {
                        self.typeTxt.text = dic[@"state"];
                        typeTwo = dic[@"id"];
                    }
                }
                NSString *areaStr = [NSString stringWithFormat:@"%@ %@ %@",responseObj[@"data"][@"cityone"],responseObj[@"data"][@"citytwo"],responseObj[@"data"][@"citythree"]];
                cityone = responseObj[@"data"][@"cityone"];
                citytwo = responseObj[@"data"][@"citytwo"];
                citythree = responseObj[@"data"][@"citythree"];
                [self.areaBtn setTitle:areaStr forState:UIControlStateNormal];
                [self.topImgView sd_setImageWithURLString:responseObj[@"data"][@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
            
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"查询服务 error====%@",responseObj);
        } andIsHUD:NO];
    }
    
}


- (void)clickUpImage{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //拍照
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置摄像头模式（拍照）
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    //从相册获取
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        _imagePickerController.allowsEditing = YES;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickChooseAreaAction:(UIButton *)sender{
    
    [self.nameTxt resignFirstResponder];
    [self.contactTxt resignFirstResponder];
    [self.phoneTxt resignFirstResponder];
    [self.typeTxt resignFirstResponder];
    
    [[[YJLocationPicker alloc] initWithSlectedLocation:^(NSArray *locationArray) {
        
        //array里面放的是省市区三级
        NSLog(@"%@", locationArray);
        //拼接后给button赋值
        [sender setTitle:[[locationArray[0] stringByAppendingString:locationArray[1]] stringByAppendingString:locationArray[2]]forState:UIControlStateNormal];
        cityone = locationArray[0];
        citytwo = locationArray[1];
        citythree = locationArray[2];
        
    }] show];
    
}

- (BOOL)checkStringIsNull{
    BOOL flag = NO;
    if (kStringIsEmpty(_nameTxt.text) || kStringIsEmpty(_contactTxt.text) || kStringIsEmpty(_phoneTxt.text) || kStringIsEmpty(_typeTxt.text) || kStringIsEmpty(cityone)) {
        
        flag = YES;
        [PublicMethod showAlert:self message:@"请将服务信息填写完整"];
        
    } else if (_phoneTxt.text.length != 11){
        flag = YES;
        [PublicMethod showAlert:self message:@"请输入11位手机号码"];
    }
    return flag;
}

- (void)clickSubmitBtn{
    
    [self.nameTxt resignFirstResponder];
    [self.contactTxt resignFirstResponder];
    [self.phoneTxt resignFirstResponder];
    [self.typeTxt resignFirstResponder];
    
    if ([self checkStringIsNull] == NO) {
        NSLog(@" %@======%@ ",USER_LAT,USER_LNG);
        NSString *token ;
        NSDictionary *paramsDict;
        if ([_actionType isEqualToString:@"add"]) {
            token = @"common";
            paramsDict = @{@"token":token,
                           @"uid":USER_UID,
                           @"name":_nameTxt.text,
                           @"realname":_contactTxt.text,
                           @"phone":_phoneTxt.text,
                           @"lng":USER_LNG,
                           @"lat":USER_LAT,
                           @"type_one":_type_one,
                           @"type_two":typeTwo,
                           @"cityone":cityone,
                           @"citytwo":citytwo,
                           @"citythree":citythree};
        } else if ([_actionType isEqualToString:@"update"]){
            token = @"setCommon";
            paramsDict = @{@"token":token,
                           @"uid":USER_UID,
                           @"serve_id":_serve_id,
                           @"name":_nameTxt.text,
                           @"realname":_contactTxt.text,
                           @"phone":_phoneTxt.text,
                           @"lng":USER_LNG,
                           @"lat":USER_LAT,
                           @"type_one":_type_one,
                           @"type_two":typeTwo,
                           @"cityone":cityone,
                           @"citytwo":citytwo,
                           @"citythree":citythree};
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //接收类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/jpg",
                                                             @"image/gif",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        //AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSURLSessionDataTask *task = [manager POST:SERVEURL parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            NSData *imageDatas = UIImageJPEGRepresentation(headImg, 0.8);
            [formData appendPartWithFileData:imageDatas
                                        name:@"upfile"
                                    fileName:@"typeImg"
                                    mimeType:@"image/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%f",uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            NSLog(@"上传成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (kStringIsEmpty(dict[@"error"])) {
                MyServiceViewController *myserviceVC = [[MyServiceViewController alloc] init];
                [self.navigationController pushViewController:myserviceVC animated:YES];
            } else {
                [PublicMethod showAlert:self message:dict[@"error"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //上传失败
            NSLog(@"上传失败");
            NSLog(@"\n%@",error);
        }];
        
        [task resume];
        
        
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
    self.typeTxt.text = _typeArray[row][@"state"];
    typeTwo = _typeArray[row][@"id"];
}


#pragma mark UIImagePickerControllerDelegate
//选取原始图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //从字典key获取image的地址
    UIImage *oriaineImage = info[UIImagePickerControllerEditedImage];
    //压缩图片
    UIImage *scaleImage = [self scaleImage:oriaineImage toScale:0.3];
    
    _topImgView.image = scaleImage;
    headImg = scaleImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scaleSize, image.size.height*scaleSize)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameTxt resignFirstResponder];
    [self.contactTxt resignFirstResponder];
    [self.phoneTxt resignFirstResponder];
    [self.typeTxt resignFirstResponder];
}

#pragma mark - initUI -

- (void)initializeUserInterface{
    
    
    self.navigationItem.title = @"编辑服务";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIView *nameView = [UIView new];
    UIView *contactView = [UIView new];
    UIView *phoneView = [UIView new];
    UIView *areaView = [UIView new];
    UIView *typeView = [UIView new];
    NSArray *viewArray = @[nameView,contactView,phoneView,areaView,typeView];
    NSArray *titleArray = @[@"服务名称",@"联系人",@"联系电话",@"选择地区",@"服务类别"];
    for (int i = 0;i < titleArray.count;i ++) {
        UIView *view = viewArray[i];
        view.backgroundColor = [UIColor whiteColor];
        NSString *title = titleArray[i];
        UILabel *lbl = [UILabel new];
        lbl.text = title;
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.font = [UIFont systemFontOfSize:15.0f];
        lbl.textColor = [UIColor darkGrayColor];
        [self.view addSubview:view];
        [view addSubview:lbl];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.top.equalTo(self.view.mas_top).offset(200+40*i);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.height.mas_offset(@30);
        }];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(20);
            make.centerY.equalTo(view.mas_centerY);
            make.size.sizeOffset(CGSizeMake(80, 30));
        }];
    }
    
    
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(74);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4));
    }];
    UILabel *noteLbl = [UILabel new];
    noteLbl.text = @"点击图片进行编辑";
    noteLbl.textAlignment = NSTextAlignmentCenter;
    noteLbl.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noteLbl];
    [noteLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImgView.mas_centerX);
        make.top.equalTo(self.topImgView.mas_bottom).offset(3);
        make.size.sizeOffset(CGSizeMake(120, 25));
    }];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUpImage)];
    [self.topImgView addGestureRecognizer:tapges];
    
    [self.nameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left).offset(110);
        make.centerY.equalTo(nameView.mas_centerY);
        make.right.equalTo(nameView.mas_right).offset(-20);
    }];
    
    [self.contactTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactView.mas_left).offset(110);
        make.centerY.equalTo(contactView.mas_centerY);
        make.right.equalTo(contactView.mas_right).offset(-20);
    }];
    
    [self.phoneTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left).offset(110);
        make.centerY.equalTo(phoneView.mas_centerY);
        make.right.equalTo(phoneView.mas_right).offset(-20);
    }];
    
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaView.mas_left).offset(110);
        make.centerY.equalTo(areaView.mas_centerY);
        make.right.equalTo(areaView.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    [self.areaBtn addTarget:self action:@selector(clickChooseAreaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.typeTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeView.mas_left).offset(110);
        make.centerY.equalTo(typeView.mas_centerY);
        make.right.equalTo(typeView.mas_right).offset(-20);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.typeTxt.mas_bottom).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    _typePickerView.delegate = self;
    _typePickerView.dataSource = self;
    self.typeTxt.inputView = _typePickerView;
}

- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = [UIImageView new];
        [_topImgView setImage:headImg];
        _topImgView.layer.cornerRadius = 8;
        _topImgView.layer.masksToBounds = YES;
        _topImgView.userInteractionEnabled = YES;
        [self.view addSubview:_topImgView];
    }
    return  _topImgView;
}

- (UITextField *)nameTxt{
    if (!_nameTxt) {
        _nameTxt = [UITextField new];
        _nameTxt.placeholder = @"请输入服务名称";
        [self.view addSubview:_nameTxt];
    }
    return _nameTxt;
}

- (UITextField *)contactTxt{
    if (!_contactTxt) {
        _contactTxt = [UITextField new];
        _contactTxt.placeholder = @"请输入联系人姓名";
        [self.view addSubview:_contactTxt];
    }
    return _contactTxt;
}

- (UITextField *)phoneTxt{
    if (!_phoneTxt) {
        _phoneTxt = [UITextField new];
        _phoneTxt.placeholder = @"请输入联系人电话";
        _phoneTxt.keyboardType = UIKeyboardTypePhonePad;
        [self.view addSubview:_phoneTxt];
    }
    return _phoneTxt;
}

- (UIButton *)areaBtn{
    if (!_areaBtn) {
        _areaBtn = [UIButton new];
        [_areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
//        _areaBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:_areaBtn];
    }
    return _areaBtn;
}

- (UITextField *)typeTxt{
    if (!_typeTxt) {
        _typeTxt = [UITextField new];
        _typeTxt.placeholder = @"请选择服务类型";
        _typeTxt.delegate = self;
        [self.view addSubview:_typeTxt];
    }
    return _typeTxt;
    
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius = 8;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        _submitBtn.layer.borderWidth = 1.0f;
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
