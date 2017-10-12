//
//  TrafficViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TrafficViewController.h"

@interface TrafficViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIPickerView *_pickerView;
    NSArray *_typeArray;
}

///滚动视图(覆盖整个CV)
@property (nonatomic, strong) UIScrollView *mainScrollView;
///姓名
@property (nonatomic, strong) InputTextView *nameView;
///性别
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;
///手机
@property (nonatomic, strong) InputTextView *phoneView;
///起步价
@property (nonatomic, strong) InputTextView *startPView;
///乘运价
@property (nonatomic, strong) InputTextView *transPView;
///服务类型
@property (nonatomic, strong) InputTextView *typeView;
///服务范围
//@property (nonatomic, strong) InputTextView *serviceScopeView;
///工作区域
//@property (nonatomic, strong) InputTextView *workAreaView;
///车内、外照片
@property (nonatomic, strong) UIImageView *incarImgView;
@property (nonatomic, strong) UIImageView *outcarImgView;
///说明
@property (nonatomic, strong) UITextView *noteView;
///提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation TrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"旅游交通运输服务";
    
    //初始化滚动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/4*5+50);
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.autoresizesSubviews = NO;
    [self.view addSubview:_mainScrollView];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.mainScrollView.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-120);
        make.height.mas_offset(@40);
    }];
    
    UILabel *manLbl = [UILabel new];
    manLbl.text = @"男";
    manLbl.font = FONT_15;
    [self.mainScrollView addSubview:manLbl];
    UILabel *womanLbl = [UILabel new];
    womanLbl.text = @"女";
    womanLbl.font = FONT_15;
    [self.mainScrollView addSubview:womanLbl];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_right).offset(5);
        make.centerY.equalTo(self.nameView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.manBtn addTarget:self action:@selector(clickManBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [manLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manBtn.mas_right).offset(5);
        make.centerY.equalTo(self.nameView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manLbl.mas_right).offset(5);
        make.centerY.equalTo(self.nameView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.womanBtn addTarget:self action:@selector(clickWomanBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [womanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.womanBtn.mas_right).offset(5);
        make.centerY.equalTo(self.nameView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.nameView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.startPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.phoneView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.transPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.startPView.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.transPView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@40);
    }];
    
//    [self.serviceScopeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.typeView.mas_bottom).offset(3);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.mas_offset(@40);
//    }];
    
//    [self.workAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.top.equalTo(self.serviceScopeView.mas_bottom).offset(3);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.mas_offset(@40);
//    }];
    
    
    CGFloat centerY = SCREEN_WIDTH/2;
    
//    UILabel *incar = [UILabel new];
//    incar.text = @"车内照片";
//    incar.font = FONT_15;
//    [self.mainScrollView addSubview:incar];
    UIButton *incarBtn = [UIButton new];
    incarBtn.tag = 100;
    [incarBtn setTitle:@"车内照片" forState:UIControlStateNormal];
    [incarBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    incarBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    incarBtn.layer.borderWidth = 1.5f;
    incarBtn.layer.cornerRadius = 8.0f;
    incarBtn.layer.masksToBounds = YES;
    [self.mainScrollView addSubview:incarBtn];
    [incarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(centerY/2-40);
        make.top.equalTo(self.typeView.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
//    UILabel *outcar = [UILabel new];
//    outcar.text = @"车外照片";
//    outcar.font = FONT_15;
//    [self.mainScrollView addSubview:outcar];
    UIButton *outcarBtn = [UIButton new];
    outcarBtn.tag = 200;
    [outcarBtn setTitle:@"车外照片" forState:UIControlStateNormal];
    [outcarBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    outcarBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    outcarBtn.layer.borderWidth = 1.5f;
    outcarBtn.layer.cornerRadius = 8.0f;
    outcarBtn.layer.masksToBounds = YES;
    [self.mainScrollView addSubview:outcarBtn];
    [outcarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-centerY/2+40);
        make.top.equalTo(self.typeView.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    [self.incarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incarBtn.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.sizeOffset(CGSizeMake(centerY-40, centerY-40));
    }];
    
    [self.outcarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incarBtn.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.size.sizeOffset(CGSizeMake(centerY-40, centerY-40));
    }];
    
    //长按上传图片
    [incarBtn addTarget:self action:@selector(clickUpImage:) forControlEvents:UIControlEventTouchUpInside];
    [outcarBtn addTarget:self action:@selector(clickUpImage:) forControlEvents:UIControlEventTouchUpInside];
//    self.incarImgView.userInteractionEnabled = YES;
//    self.incarImgView.tag = 100;
//    self.outcarImgView.userInteractionEnabled = YES;
//    self.outcarImgView.tag = 200;
//    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUpImage:)];
//    [self.incarImgView addGestureRecognizer:tapges];
//    [self.outcarImgView addGestureRecognizer:tapges];
    
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.incarImgView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@100);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.top.equalTo(self.noteView.mas_bottom).offset(20);
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
    
    if ([_action_type isEqualToString:@"update"]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@token=tourOne&serve_id=%@",SERVEURL,_serve_id];
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
            if (kStringIsEmpty(responseObj[@"error"])) {
                NSLog(@"%@",responseObj[@"data"]);
                self.nameView.contentTxt.text = responseObj[@"data"][@"realname"];
                if ([responseObj[@"data"][@"sex"] isEqualToString:@"男"]) {
                    self.manBtn.selected = YES;
                    [_manBtn setImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
                    [_womanBtn setImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
                }else{
                    self.womanBtn.selected = YES;
                    [_womanBtn setImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
                    [_manBtn setImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
                }
                self.phoneView.contentTxt.text = [NSString stringWithFormat:@"%@",USER_USER];
                self.startPView.contentTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"start"]];
                self.transPView.contentTxt.text = [NSString stringWithFormat:@"%@ 元/公里*小时",responseObj[@"data"][@"course"]];
                for (NSDictionary *typeDict in _typeArray) {
                    if ([typeDict[@"type_two"] isEqualToString:responseObj[@"data"][@"type_two"]]) {
                        
                        self.typeView.contentTxt.text = [NSString stringWithFormat:@"%@",typeDict[@"state"]];
                    }
                }
                self.type_two = responseObj[@"data"][@"type_two"];
                [self.incarImgView sd_setImageWithURLString:responseObj[@"data"][@"in_car"] placeholderImage:[UIImage imageNamed:@"appImg"]];
                [self.outcarImgView sd_setImageWithURLString:responseObj[@"data"][@"ex_car"] placeholderImage:[UIImage imageNamed:@"appImg"]];
                self.noteView.text = [NSString stringWithFormat:@"说明：%@",responseObj[@"data"][@"name"]];
            } else {
                
                [PublicMethod showAlert:self message:responseObj[@"error"]];
                
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"乘运详情查询 error");
        } andIsHUD:NO];
    }
    
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

- (BOOL)checkTxtNotNull{
    BOOL flag = NO;
    if (kStringIsEmpty(self.nameView.contentTxt.text) || kStringIsEmpty(self.phoneView.contentTxt.text) || kStringIsEmpty(self.startPView.contentTxt.text) || kStringIsEmpty(self.transPView.contentTxt.text) || kStringIsEmpty(self.typeView.contentTxt.text) || kStringIsEmpty(self.noteView.text)) {
        
        flag = YES;
    }
    return flag;
}

- (void)clickSubmitBtn:(UIButton *)sender{
    
    if ([self checkTxtNotNull]) {
        
        [PublicMethod showAlert:self message:@"请填写完整信息"];
    } else {
        
        NSLog(@"提交");
        //http://api.swktcx.com/A1/serve.php?token=tour&uid=10000&realname=测试姓名&sex=男&phone=15000000000&start=10&course=2&type_one=1&type_two=21&my_appraise=说明旅游乘运
        NSString *sexStr;
        if (self.manBtn.selected == YES) {
            sexStr = @"男";
        } else {
            sexStr = @"女";
        }
        NSDictionary *paramsDict;
        if([_action_type isEqualToString:@"add"]){
            paramsDict = @{@"token":@"tour",
                           @"uid":USER_UID,
                           @"realname":self.nameView.contentTxt.text,
                           @"sex":sexStr,
                           @"phone":self.phoneView.contentTxt.text,
                           @"start":self.startPView.contentTxt.text,
                           @"course":self.transPView.contentTxt.text,
                           @"type_one":_type_one,
                           @"type_two":_type_two,
                           @"my_appraise":self.noteView.text};
        }else {
            paramsDict = @{@"token":@"setTour",
                           @"uid":USER_UID,
                           @"realname":self.nameView.contentTxt.text,
                           @"sex":sexStr,
                           @"phone":self.phoneView.contentTxt.text,
                           @"start":self.startPView.contentTxt.text,
                           @"course":self.transPView.contentTxt.text,
                           @"serve_id":_serve_id,
                           @"type_two":_type_two,
                           @"my_appraise":self.noteView.text};
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
            
            NSArray *imgArray = @[self.incarImgView.image,self.outcarImgView.image];
            NSArray *strArray = @[@"in_car",@"ex_car"];
            for (int i =0;i<imgArray.count;i++) {
                UIImage *image = imgArray[i];
                NSString *nameStr = strArray[i];
                NSData *imageDatas = UIImageJPEGRepresentation(image, 0.8);
                [formData appendPartWithFileData:imageDatas
                                            name:nameStr//@"upfile"
                                        fileName:@"carImage"
                                        mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%f",uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            NSLog(@"上传成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (kStringIsEmpty(dict[@"error"])) {
                [PublicMethod showAlert:self message:@"发布成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.typeView.contentTxt.text = _typeArray[row][@"state"];
    self.type_two = _typeArray[row][@"id"];
}

#pragma mark - 选照片 -

- (void)clickUpImage:(UIButton *)sender{
    
//    UIView *v = (UIView *)[gestureRecognizer view];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.view.tag = sender.tag;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

#pragma mark UIImagePickerControllerDelegate
//选取原始图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //从字典key获取image的地址
    UIImage *oriaineImage = info[UIImagePickerControllerEditedImage];
    //压缩图片
    UIImage *scaleImage = [self scaleImage:oriaineImage toScale:0.7];
    
    if (picker.view.tag == 100) {
        self.incarImgView.image = scaleImage;
    } else if (picker.view.tag == 200) {
        self.outcarImgView.image = scaleImage;
    }
    
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

- (InputTextView *)nameView{
    if (!_nameView) {
        _nameView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"姓名"];
        _nameView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:_nameView];
    }
    return _nameView;
}

- (UIButton *)manBtn{
    if (!_manBtn) {
        _manBtn = [UIButton new];
        [_manBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
        [self.mainScrollView addSubview:_manBtn];
    }
    return _manBtn;
}

- (UIButton *)womanBtn{
    if (!_womanBtn) {
        _womanBtn = [UIButton new];
        [_womanBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
        [self.mainScrollView addSubview:_womanBtn];
    }
    return _womanBtn;
}

- (InputTextView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"手机"];
        _phoneView.backgroundColor = [UIColor whiteColor];
        _phoneView.contentTxt.keyboardType = UIKeyboardTypePhonePad;
        [self.mainScrollView addSubview:_phoneView];
    }
    return _phoneView;
}

- (InputTextView *)startPView{
    if (!_startPView) {
        _startPView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"起始价￥"];
        _startPView.backgroundColor = [UIColor whiteColor];
        _startPView.contentTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self.mainScrollView addSubview:_startPView];
    }
    return _startPView;
}

- (InputTextView *)transPView{
    if (!_transPView) {
        _transPView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"乘运价￥"];
        _transPView.backgroundColor = [UIColor whiteColor];
        _transPView.contentTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self.mainScrollView addSubview:_transPView];
    }
    return _transPView;
}

- (InputTextView *)typeView{
    if (!_typeView) {
        _typeView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"服务类型"];
        _typeView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:_typeView];
    }
    return _typeView;
}

//- (InputTextView *)serviceScopeView{
//    if (!_serviceScopeView) {
//        _serviceScopeView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"服务范围"];
//        _serviceScopeView.backgroundColor = [UIColor whiteColor];
//        [self.mainScrollView addSubview:_serviceScopeView];
//    }
//    return _serviceScopeView;
//}
//
//- (InputTextView *)workAreaView{
//    if (!_workAreaView) {
//        _workAreaView = [[InputTextView alloc] initWithFrame:CGRectZero andTitle:@"工作区域"];
//        _workAreaView.backgroundColor = [UIColor whiteColor];
//        [self.mainScrollView addSubview:_workAreaView];
//    }
//    return _workAreaView;
//}

- (UIImageView *)incarImgView{
    if (!_incarImgView) {
        _incarImgView = [UIImageView new];
        [_incarImgView setImage:[UIImage imageNamed:@"appImg"]];
        [self.mainScrollView addSubview:_incarImgView];
    }
    return _incarImgView;
}

- (UIImageView *)outcarImgView{
    if (!_outcarImgView) {
        _outcarImgView = [UIImageView new];
        [_outcarImgView setImage:[UIImage imageNamed:@"appImg"]];
        [self.mainScrollView addSubview:_outcarImgView];
    }
    return _outcarImgView;
}

- (UITextView *)noteView{
    if (!_noteView) {
        _noteView = [UITextView new];
        _noteView.text = @"说明：";
        [self.mainScrollView addSubview:_noteView];
    }
    return _noteView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:COLOR_RGB(0, 174, 249, 1.0)];
        [self.mainScrollView addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameView.contentTxt resignFirstResponder];
    [self.phoneView.contentTxt resignFirstResponder];
    [self.startPView.contentTxt resignFirstResponder];
    [self.transPView.contentTxt resignFirstResponder];
    [self.typeView.contentTxt resignFirstResponder];
//    [self.serviceScopeView.contentTxt resignFirstResponder];
//    [self.workAreaView.contentTxt resignFirstResponder];
    [self.noteView resignFirstResponder];
    
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
