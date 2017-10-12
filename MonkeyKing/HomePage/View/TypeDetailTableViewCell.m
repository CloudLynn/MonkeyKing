//
//  TypeDetailTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TypeDetailTableViewCell.h"
#import "CartModel.h"

@interface TypeDetailTableViewCell ()<UITextFieldDelegate>


@property (nonatomic, assign) double count;
@property (nonatomic, strong) NSMutableDictionary *resultDict;

@property (nonatomic, copy) selectBlcok block;
@end

@implementation TypeDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.count = 0.00;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.proImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_offset(@(80));
        make.width.mas_offset(@(80));
    }];
    
    [self.proNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(5);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2, 30));
        make.top.equalTo(self.mas_top).offset(8);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(5);
        make.top.equalTo(self.proNameLbl.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2, 30));
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.checkBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.checkBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.plusBtn addTarget:self action:@selector(clickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plusBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.checkBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(40, 30));
    }];
    _countTxt.text = [NSString stringWithFormat:@"%.2f",_count];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLbl.mas_left).offset(-5);
        make.centerY.equalTo(self.checkBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [self.minusBtn addTarget:self action:@selector(clickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(5);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}


- (void)setContentDict:(NSDictionary *)contentDict{
    [_proImgView sd_setImageWithURLString:contentDict[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    _proNameLbl.text = contentDict[@"name"];
    _priceLbl.text = [NSString stringWithFormat:@"￥%@",contentDict[@"money"]];
    _noteView.text = [NSString stringWithFormat:@"%@",contentDict[@"notes"]];
    
    if ([contentDict[@"isSelect"] isEqualToString:@"YES"]) {
        [self.checkBtn setImage:[UIImage imageNamed:@"selected1"] forState:UIControlStateNormal];
    }else{
        [self.checkBtn setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.countTxt resignFirstResponder];
}

- (void)clickMinusBtn:(UIButton *)button{

    
    if (!_checkBtn.selected) {
        if ([_countTxt.text doubleValue] > 1) {
            
            _countTxt.text = [NSString stringWithFormat:@"%.2f",[_countTxt.text doubleValue]-1];
        } else {
            _countTxt.text = @"0.00";
        }
//        [[CartModel sharedInstance] reduceInfo:_info];
//        _countTxt.text = [NSString stringWithFormat:@"%d",[[CartModel sharedInstance] infoAddCartNum:_info.info_id]];
    }
    
}

- (void)clickPlusBtn:(UIButton *)button{

    if (!_checkBtn.selected) {
        
        _countTxt.text = [NSString stringWithFormat:@"%.2f",[_countTxt.text doubleValue]+1];
//        [[CartModel sharedInstance] addInfo:_info];
//        _countTxt.text = [NSString stringWithFormat:@"%d",[[CartModel sharedInstance] infoAddCartNum:_info.info_id]];
    }
}

-(void)clickSelectBlock:(selectBlcok)block{
    self.block = block;
}

- (void)clickCheckBtn{
    
    self.checkBtn.selected = !self.checkBtn.selected;
    if (self.block!=nil) {
        self.block(self.checkBtn);
    }
    

//    
//    if (self.checkBtn.selected) {
//        
//        [self.checkBtn setImage:[UIImage imageNamed:@"selected1"] forState:UIControlStateNormal];
//        self.countTxt.enabled = NO;
//        [[CartModel sharedInstance] addInfo:_info andCount:[_countTxt.text doubleValue]];
//        _countTxt.text = [NSString stringWithFormat:@"%.2f",[[CartModel sharedInstance] infoAddCartNum:_info.info_id]];
//        
//    } else {
//        
//        [self.checkBtn setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
//        self.countTxt.enabled = YES;
//        //减去该类商品
//        [[CartModel sharedInstance] reduceAllWithInfo:_info];
//        _countTxt.text = [NSString stringWithFormat:@"%.2f",[[CartModel sharedInstance] infoAddCartNum:_info.info_id]];
//    }
    
}

#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textField4 - 开始编辑");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField4 - 结束编辑");
    [[CartModel sharedInstance] addInfo:_info andCount:[textField.text doubleValue]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField4 - 正在编辑, 当前输入框内容为: %@",textField.text);
    return YES;
}

#pragma mark - initUI -
- (UIImageView *)proImgView{
    if (!_proImgView) {
        _proImgView = [UIImageView new];
        [self addSubview:_proImgView];
    }
    return _proImgView;
}

- (UILabel *)proNameLbl{
    if (!_proNameLbl) {
        _proNameLbl = [UILabel new];
        [self addSubview:_proNameLbl];
    }
    return _proNameLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [UILabel new];
        [self addSubview:_priceLbl];
    }
    return _priceLbl;
}

- (UITextField *)countLbl{
    if (!_countTxt) {
        _countTxt = [UITextField new];
        _countTxt.enabled = NO;
        _countTxt.delegate = self;
        _countTxt.textAlignment = NSTextAlignmentCenter;
        _countTxt.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_countTxt];
    }
    return _countTxt;
}
- (UIButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [UIButton new];
        [_minusBtn setImage:[UIImage imageNamed:@"minusImg"] forState:UIControlStateNormal];
        [self addSubview:_minusBtn];
    }
    return _minusBtn;
}

- (UIButton *)plusBtn{
    if (!_plusBtn) {
        _plusBtn = [UIButton new];
        [_plusBtn setImage:[UIImage imageNamed:@"plusImg"] forState:UIControlStateNormal];
        [self addSubview:_plusBtn];
    }
    return _plusBtn;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton new];
        _checkBtn.selected = NO;
        [_checkBtn setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
        [self addSubview:_checkBtn];
    }
    return _checkBtn;
}

- (UITextView *)noteView{
    if (!_noteView) {
        _noteView = [UITextView new];
        _noteView.editable = NO;
        [self addSubview:_noteView];
    }
    return _noteView;
}

- (NSMutableDictionary *)resultDict{
    if (!_resultDict) {
        _resultDict = [NSMutableDictionary dictionary];
    }
    return _resultDict;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
