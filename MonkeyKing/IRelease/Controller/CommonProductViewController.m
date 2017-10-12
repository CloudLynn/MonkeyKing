//
//  CommonProductViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "CommonProductViewController.h"
#import "ZYQAssetPickerController.h"

@interface CommonProductViewController ()<ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

///名称
@property (nonatomic, strong) UITextField *nameTxt;
///价格
@property (nonatomic, strong) UITextField *priceTxt;
///备注
@property (nonatomic, strong) UITextView *noteTxt;
///相机
@property (nonatomic, strong) UIButton *cameraBtn;
///提交
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIView *scrollerView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imgArray;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;


@end

@implementation CommonProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"编辑服务产品";
    
    UILabel *nameLbl = [UILabel new];
    nameLbl.text = @"名称";
    UILabel *priceLbl = [UILabel new];
    priceLbl.text = @"价格";
    UILabel *noteLbl = [UILabel new];
    noteLbl.text = @"说明";
    NSArray *titleArr = @[nameLbl,priceLbl,noteLbl];
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel *lbl = titleArr[i];
        lbl.font = FONT_15;
        [self.view addSubview:lbl];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(8);
            make.top.equalTo(self.view.mas_top).offset(80+45*i);
            make.size.sizeOffset(CGSizeMake(50, 30));
        }];
    }
    
    [self.nameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLbl.mas_right).offset(8);
        make.centerY.equalTo(nameLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [self.priceTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLbl.mas_right).offset(8);
        make.centerY.equalTo(priceLbl.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [self.noteTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteLbl.mas_right).offset(8);
        make.top.equalTo(noteLbl.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_offset(@100);
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteTxt.mas_left);
        make.top.equalTo(self.noteTxt.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(30, 25));
    }];
    
    [self.cameraBtn addTarget:self action:@selector(clickCameraBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_offset(@30);
    }];
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollerView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-40, self.view.frame.size.height-120)];
//    _scrollerView.pagingEnabled=YES;
    _scrollerView.backgroundColor=[UIColor lightGrayColor];
//    _scrollerView.delegate=self;
    [self.view addSubview:_scrollerView];
    
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.top.equalTo(self.cameraBtn.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-8);
    }];
    
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(_scrollerView.frame.origin.x, _scrollerView.frame.origin.y+_scrollerView.frame.size.height-20, _scrollerView.frame.size.width, 20)];
    [self.view addSubview:_pageControl];
    
}

- (void)initializeDataSource{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    
    //http://api.swktcx.com/A1/serve.php?token=getCommonInfo&info_id=72
    if([_actionType isEqualToString:@"update"]){
        
        NSDictionary *paramDict = @{@"token":@"getCommonInfo",
                                    @"info_id":_serve_id};
        
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            self.nameTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"name"]];
            self.priceTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"money"]];
            self.noteTxt.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"notes"]];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollerView.frame.size.width, _scrollerView.frame.size.height)];
            [imgview sd_setImageWithURLString:responseObj[@"data"][@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
            [_scrollerView addSubview:imgview];
            if (_imgArray.count>0) {
                [_imgArray removeAllObjects];
            }
            [_imgArray addObject:imgview.image];
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"产品信息error");
        } andIsHUD:NO];
    }
    
}


- (void)clickCameraBtn{
//    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
//    picker.maximumNumberOfSelection = 10;
//    picker.assetsFilter = [ALAssetsFilter allPhotos];
//    picker.showEmptyGroups=NO;
//    picker.delegate=self;
//    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//            return duration >= 5;
//        } else {
//            return YES;
//        }
//    }];
//    
//    [self presentViewController:picker animated:YES completion:NULL];
    //}
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
//    _imagePickerController.view.tag = sender.tag;
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
    [_scrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //从字典key获取image的地址
    UIImage *oriaineImage = info[UIImagePickerControllerEditedImage];
    //压缩图片
    UIImage *scaleImage = [self scaleImage:oriaineImage toScale:0.7];
    
//    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(_scrollerView.frame.size.width, 0, _scrollerView.frame.size.width, _scrollerView.frame.size.height)];
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollerView.frame.size.width, _scrollerView.frame.size.height)];
    imgview.contentMode=UIViewContentModeScaleAspectFill;
    imgview.clipsToBounds=YES;
    [imgview setImage:scaleImage];
    [_scrollerView addSubview:imgview];
    if (_imgArray.count>0) {
        [_imgArray removeAllObjects];
    }
    [_imgArray addObject:imgview.image];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scaleSize, image.size.height*scaleSize)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (void)clickSubmitBtn{
    //添加http://api.swktcx.com/A1/serve.php?token=commonInfo&serve_id=241&uid=10000&type_two=230&name=产品名称&money=10&notes=添加服务下的服务产品说明
    //修改http://api.swktcx.com/A1/serve.php?token=setCommonInfo
    
    [self.nameTxt resignFirstResponder];
    [self.priceTxt resignFirstResponder];
    [self.noteTxt resignFirstResponder];
    
    if ([self checkStringIsNull] == NO) {
        NSLog(@" %@======%@ ",USER_LAT,USER_LNG);
        NSDictionary *paramsDict;
        if ([_actionType isEqualToString:@"add"]) {
            
            paramsDict = @{@"token":@"commonInfo",
                                         @"serve_id":_serve_id,
                                         @"uid":USER_UID,
                                         @"type_two":_type_two,
                                         @"name":_nameTxt.text,
                                         @"money":_priceTxt.text,
                                         @"notes":_noteTxt.text,};
            
        } else if ([_actionType isEqualToString:@"update"]){
            
            paramsDict = @{@"token":@"setCommonInfo",
                                         @"info_id":_serve_id,
                                         @"name":_nameTxt.text,
                                         @"money":_priceTxt.text,
                                         @"notes":_noteTxt.text,};
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
            
            for (UIImage *image in _imgArray) {
                NSData *imageDatas = UIImageJPEGRepresentation(image, 0.8);
                [formData appendPartWithFileData:imageDatas
                                            name:@"upfile"
                                        fileName:@"productImage"
                                        mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            NSLog(@"上传成功");
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (kStringIsEmpty(dict[@"error"])) {
//                [PublicMethod showAlert:self message:@"发布产品成功"];
                
                NSNotification *notice = [NSNotification notificationWithName:@"addProduct" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
                [self.navigationController popViewControllerAnimated:YES];
                
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

- (BOOL)checkStringIsNull{
    BOOL flag = NO;
    if (kStringIsEmpty(_nameTxt.text) || kStringIsEmpty(_priceTxt.text) || kStringIsEmpty(_noteTxt.text)) {
        flag = YES;
        [PublicMethod showAlert:self message:@"请填写完整的产品信息"];
    } else if (_noteTxt.text.length>50) {
        flag = YES;
        [PublicMethod showAlert:self message:@"备注字数超过限制"];
    }
    return flag;
}


#pragma mark - ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    
//   
//    
//    [_scrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _scrollerView.contentSize=CGSizeMake(assets.count*_scrollerView.frame.size.width, _scrollerView.frame.size.height);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _pageControl.numberOfPages=assets.count;
//        });
//        if (_imgArray.count>0) {
//            [_imgArray removeAllObjects];
//        }
//        for (int i=0; i<assets.count; i++) {
//            ALAsset *asset=assets[i];
//            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollerView.frame.size.width, 0, _scrollerView.frame.size.width, _scrollerView.frame.size.height)];
//            imgview.contentMode=UIViewContentModeScaleAspectFill;
//            imgview.clipsToBounds=YES;
//            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imgview setImage:tempImg];
//                [_imgArray addObject:tempImg];
//                [_scrollerView addSubview:imgview];
//            });
//        }
//    });
//}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameTxt resignFirstResponder];
    [self.priceTxt resignFirstResponder];
    [self.noteTxt resignFirstResponder];
}

#pragma mark - initUI -
- (UITextField *)nameTxt{
    if (!_nameTxt) {
        _nameTxt = [UITextField new];
        _nameTxt.font = FONT_15;
        _nameTxt.placeholder = @"请输入产品名称";
        _nameTxt.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_nameTxt];
    }
    return _nameTxt;
}

- (UITextField *)priceTxt{
    if (!_priceTxt) {
        _priceTxt = [UITextField new];
        _priceTxt.font = FONT_15;
        _priceTxt.placeholder = @"请输入产品价格";
        _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
        _priceTxt.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_priceTxt];
    }
    return _priceTxt;
}

- (UITextView *)noteTxt{
    if (!_noteTxt) {
        _noteTxt = [UITextView new];
        _noteTxt.font = FONT_15;
        _noteTxt.text = @"备注（50字以内）";
        _noteTxt.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_noteTxt];
    }
    return _noteTxt;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton new];
        [_cameraBtn setImage:[UIImage imageNamed:@"cameraImg"] forState:UIControlStateNormal];
        [self.view addSubview:_cameraBtn];
    }
    return _cameraBtn;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _submitBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        _submitBtn.layer.borderWidth = 1.0f;
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
