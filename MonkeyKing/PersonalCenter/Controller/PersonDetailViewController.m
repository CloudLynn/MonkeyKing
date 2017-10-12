//
//  PersonDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/9.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "YJLocationPicker.h"

@interface PersonDetailViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    UIImage *headImg;
}

///滚动视图
//@property (nonatomic, strong) UIScrollView *scrollView;
///头像
@property (nonatomic, strong) UIImageView *headImgView;
///昵称
@property (nonatomic, strong) UITextField *nickNameTxt;
///真实姓名
@property (nonatomic, strong) UITextField *realNameTxt;
///性别
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;
@property (nonatomic, strong) NSString *sexStr;
///身份证号
@property (nonatomic, strong) UITextField *IDcardTxt;
///省市区
@property (nonatomic, strong) UIButton *areaBtn;
///服务地址
@property (nonatomic, strong) UITextField *addressTxt;
///微信号
@property (nonatomic, strong) UITextField *wechatTxt;
///支付宝账号
@property (nonatomic, strong) UITextField *alipayTxt;
///工号
//@property (nonatomic, strong) UILabel *workNumberLbl;

///修改按钮
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    headImg = [UIImage imageNamed:@"user_headImg"];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"个人详情";

    
    NSArray *titleArray = @[@"昵       称",@"真实姓名",@"性       别",@"身份证号",@"省市区",@"住址",@"微  信  号",@"支付宝账号"];//,@"工       号"
    
    UILabel *nickNameLbl = [UILabel new];
    UILabel *realNameLbl = [UILabel new];
    UILabel *sexLbl = [UILabel new];
    UILabel *idcardLbl = [UILabel new];
    UILabel *areaLbl = [UILabel new];
    UILabel *addressLbl = [UILabel new];
    UILabel *wechatLbl = [UILabel new];
    UILabel *alipayLbl = [UILabel new];
//    UILabel *workNumberLbl = [UILabel new];
    
    NSArray *lblArray = [NSArray arrayWithObjects:nickNameLbl,realNameLbl,sexLbl,idcardLbl,areaLbl,addressLbl,wechatLbl,alipayLbl, nil];//workNumberLbl
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *lbl = lblArray[i];
        [lbl setText:titleArray[i]];
        [lbl setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(80, 30));
            make.top.equalTo(self.view.mas_top).offset(150+i*40);
            make.left.equalTo(self.view.mas_left).offset(8);
        }];
    }
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUpImage)];
    [self.headImgView addGestureRecognizer:tapges];
    
    [self.nickNameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLbl.mas_right).offset(8);
        make.centerY.equalTo(nickNameLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@30);
    }];
    
    [self.realNameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(realNameLbl.mas_right).offset(8);
        make.centerY.equalTo(realNameLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@30);
    }];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLbl.mas_right).offset(12);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.manBtn addTarget:self action:@selector(clickSexButton:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *manLbl = [UILabel new];
    manLbl.text = @"男";
    [self.view addSubview:manLbl];
    [manLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manBtn.mas_right).offset(8);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manLbl.mas_right).offset(12);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.womanBtn addTarget:self action:@selector(clickSexButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *womanLbl = [UILabel new];
    womanLbl.text = @"女";
    [self.view addSubview:womanLbl];
    [womanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.womanBtn.mas_right).offset(8);
        make.centerY.equalTo(sexLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    [self.IDcardTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(idcardLbl.mas_right).offset(8);
        make.centerY.equalTo(idcardLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaLbl.mas_right).offset(8);
        make.centerY.equalTo(areaLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [self.areaBtn addTarget:self action:@selector(clickChooseArea:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addressTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLbl.mas_right).offset(8);
        make.centerY.equalTo(addressLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [self.wechatTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechatLbl.mas_right).offset(8);
        make.centerY.equalTo(wechatLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [self.alipayTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayLbl.mas_right).offset(8);
        make.centerY.equalTo(alipayLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(30);
    }];
    
//    [self.workNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(workNumberLbl.mas_right).offset(8);
//        make.centerY.equalTo(workNumberLbl.mas_centerY);
//        make.right.equalTo(self.view.mas_right).offset(-8);
//        make.height.mas_offset(30);
//    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.alipayTxt.mas_bottom).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(30);
    }];
    
    [self.changeBtn addTarget:self action:@selector(clickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)initializeDataSource{
    //http://api.swktcx.com/A1/user.php?token=get_user&uid=10000
    if ([_actionType isEqualToString:@"add"]) {
        [self.headImgView setImage:[UIImage imageNamed:@"user_headImg"]];
        self.nickNameTxt.placeholder = @"请输入昵称";
        self.realNameTxt.placeholder = @"请输入真实姓名";
        self.manBtn.selected = YES;
        self.sexStr = @"男";
        [self.areaBtn setTitle:@"请选择省市区" forState:UIControlStateNormal];
        self.addressTxt.placeholder = @"请输入现在所住地址";
        self.IDcardTxt.placeholder = @"请输入您的身份证号";
        self.wechatTxt.placeholder = @"请输入您的微信号";
        self.alipayTxt.placeholder = @"请输入您的支付宝账号";
    } else {
        
        NSDictionary *paramDict = @{@"token":@"get_user",
                                    @"uid":USER_UID};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if (kStringIsEmpty(responseObj[@"error"])) {
                [self.headImgView sd_setImageWithURLString:responseObj[@"data"][@"image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
                self.nickNameTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"nickname"]];
                self.realNameTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"realname"]];
                self.sexStr = responseObj[@"data"][@"sex"];
                if ([self.sexStr isEqualToString:@"男"]) {
                    self.manBtn.selected = YES;
                    [self.manBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
                    self.womanBtn.selected = NO;
                    [self.womanBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
                } else if ([self.sexStr isEqualToString:@"女"]) {
                    self.manBtn.selected = NO;
                    [self.manBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
                    self.womanBtn.selected = YES;
                    [self.womanBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
                }
                self.IDcardTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"idcard"]];
                [self.areaBtn setTitle:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"city"]] forState:UIControlStateNormal];
                self.addressTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"address"]];
                self.wechatTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"weixin"]];
                self.alipayTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"alipay"]];
//                self.workNumberLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"worknumber"]];
                
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
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

- (void)clickSexButton:(UIButton *)sender{
    if (sender.tag == 100) {
        [_manBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
        _manBtn.selected = YES;
        _sexStr = @"男";
        [_womanBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
        _womanBtn.selected = NO;
    } else {
        [_womanBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
        _womanBtn.selected = YES;
        _sexStr = @"女";
        [_manBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
        _manBtn.selected = NO;
    }
}

- (void)clickChooseArea:(UIButton *)sender{
    [self resignFirstR];
    [[[YJLocationPicker alloc] initWithSlectedLocation:^(NSArray *locationArray) {
        
        //array里面放的是省市区三级
        NSLog(@"%@", locationArray);
        //拼接后给button赋值
        NSString *areaStr = [NSString stringWithFormat:@"%@-%@-%@",locationArray[0],locationArray[1],locationArray[2]];
//        [sender setTitle:[[locationArray[0] stringByAppendingString:locationArray[1]] stringByAppendingString:locationArray[2]]forState:UIControlStateNormal];
        [sender setTitle:areaStr forState:UIControlStateNormal];

        
    }] show];
}

- (void)resignFirstR{
    [self.nickNameTxt resignFirstResponder];
    [self.realNameTxt resignFirstResponder];
    [self.IDcardTxt resignFirstResponder];
    [self.wechatTxt resignFirstResponder];
    [self.alipayTxt resignFirstResponder];
    [self.addressTxt resignFirstResponder];
}

- (BOOL)checkStringNotNull{
    BOOL flag = YES;
    if (kStringIsEmpty(self.nickNameTxt.text) || kStringIsEmpty(self.realNameTxt.text) || kStringIsEmpty(self.addressTxt.text) || kStringIsEmpty(self.IDcardTxt.text) || kStringIsEmpty(self.wechatTxt.text) || kStringIsEmpty(self.alipayTxt.text)) {
        flag = NO;
        [PublicMethod showAlert:self message:@"请填写完整的个人信息"];
        
    } else if (_IDcardTxt.text.length!=18){
        flag = NO;
        [PublicMethod showAlert:self message:@"请输入18位身份证号码"];
    } else if ([_areaBtn.titleLabel.text isEqualToString:@"请选择省市区"]) {
        flag = NO;
        [PublicMethod showAlert:self message:@"请选择省市区"];
    }
    return flag;
}

- (void)clickChangeBtn{
    /*" uid ": 10000
     " realname ":真实姓名
     " nickname ":昵称
     " sex ": 男
     " city ": 北京东城天安门			/省市区
     " address ": 服务地址
     " idcard ": 500321214950051235
     " weixin ": fa875454
     " alipay ": 15234987654

*/
    if ([self checkStringNotNull]) {
        NSDictionary *paramDic = @{@"token":@"set_user",
                                   @"uid":USER_UID,
                                   @"nickname":self.nickNameTxt.text,
                                   @"realname":self.realNameTxt.text,
                                   @"sex":self.sexStr,
                                   @"city":self.areaBtn.titleLabel.text,
                                   @"address":self.addressTxt.text,
                                   @"alipay":self.alipayTxt.text,
                                   @"weixin":self.wechatTxt.text,
                                   @"idcard":self.IDcardTxt.text,};
        
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
        
        NSURLSessionDataTask *task = [manager POST:USERURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            NSData *imageDatas = UIImageJPEGRepresentation(headImg, 0.8);
            [formData appendPartWithFileData:imageDatas
                                        name:@"upfile"
                                    fileName:@"headImg"
                                    mimeType:@"image/jpg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [PublicMethod showAlert:self message:dict[@"data"]];
            if (kStringIsEmpty(dict[@"error"])) {
                
                
                NSNotification *notice = [NSNotification notificationWithName:@"changePersonDetail" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
//                [self.navigationController popViewControllerAnimated:YES];
                
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstR];
}

#pragma mark UIImagePickerControllerDelegate
//选取原始图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //从字典key获取image的地址
    UIImage *oriaineImage = info[UIImagePickerControllerEditedImage];
    //压缩图片
    UIImage *scaleImage = [self scaleImage:oriaineImage toScale:0.3];
    
    _headImgView.image = scaleImage;
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

#pragma mark - initUI -

//- (UIScrollView *)scrollView{
//    [self.view addSubview:_scrollView];
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _scrollView.contentOffset = CGPointMake(0, 0);
//        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60);
//        _scrollView.backgroundColor = [UIColor whiteColor];
//        _scrollView.userInteractionEnabled = YES;
//        _scrollView.scrollEnabled = YES;
//        _scrollView.delegate = self;
//        [self.view addSubview:_scrollView];
//    }
//    return _scrollView;
//}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.userInteractionEnabled = YES;
        [self.view addSubview:_headImgView];
    }
    return _headImgView;
}

- (UITextField *)nickNameTxt{
    if (!_nickNameTxt) {
        _nickNameTxt = [UITextField new];
        _nickNameTxt.placeholder = @"请输入昵称";
        [self.view addSubview:_nickNameTxt];
    }
    return _nickNameTxt;
}

- (UITextField *)realNameTxt{
    if (!_realNameTxt) {
        _realNameTxt = [UITextField new];
        _realNameTxt.placeholder = @"请输入真实姓名";
        [self.view addSubview:_realNameTxt];
    }
    return _realNameTxt;
}

- (UIButton *)manBtn{
    if (!_manBtn) {
        _manBtn = [UIButton new];
        [_manBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
        _manBtn.selected = YES;
        _sexStr = @"男";
        _manBtn.tag = 100;
        [self.view addSubview:_manBtn];
    }
    return _manBtn;
}

- (UIButton *)womanBtn{
    if (!_womanBtn) {
        _womanBtn = [UIButton new];
        [_womanBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
        _womanBtn.selected = NO;
        _womanBtn.tag = 200;
        [self.view addSubview:_womanBtn];
    }
    return _womanBtn;
}

- (UITextField *)IDcardTxt{
    if (!_IDcardTxt) {
        _IDcardTxt = [UITextField new];
        _IDcardTxt.placeholder = @"请输入身份证号";
        [self.view addSubview:_IDcardTxt];
    }
    return _IDcardTxt;
}

- (UIButton *)areaBtn{
    if (!_areaBtn) {
        _areaBtn = [UIButton new];
        
        _areaBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _areaBtn.layer.borderWidth = 1.0f;
        _areaBtn.layer.cornerRadius = 8.0f;
        _areaBtn.layer.masksToBounds = YES;
        [_areaBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self.view addSubview:_areaBtn];
    }
    return _areaBtn;
}

- (UITextField *)addressTxt{
    if (!_addressTxt) {
        _addressTxt = [UITextField new];
        _addressTxt.placeholder = @"请输入住址";
        [self.view addSubview:_addressTxt];
    }
    return _addressTxt;
}

- (UITextField *)wechatTxt{
    if (!_wechatTxt) {
        _wechatTxt = [UITextField new];
        _wechatTxt.placeholder = @"请输入微信号";
        [self.view addSubview:_wechatTxt];
    }
    return _wechatTxt;
}

- (UITextField *)alipayTxt{
    if (!_alipayTxt) {
        _alipayTxt = [UITextField new];
        _alipayTxt.placeholder = @"请输入支付宝账号";
        [self.view addSubview:_alipayTxt];
    }
    return _alipayTxt;
}

//- (UILabel *)workNumberLbl{
//    if (!_workNumberLbl) {
//        _workNumberLbl = [UILabel new];
//        [self.view addSubview:_workNumberLbl];
//    }
//    return _workNumberLbl;
//}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton new];
        [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeBtn.layer.cornerRadius = 8.0f;
        _changeBtn.layer.masksToBounds = YES;
        _changeBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        _changeBtn.layer.borderWidth = 1.0f;
        [self.view addSubview:_changeBtn];
    }
    return _changeBtn;
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
