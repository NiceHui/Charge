//
//  InputSettingAlert.m
//  charge
//
//  Created by growatt007 on 2018/10/22.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "InputSettingAlert.h"
#import "MBProgressHUD.h"

#define bouncedView_Width 260
#define bouncedView_height 240

#define dismissBtn_Windth 24
#define dismissBtn_height dismissBtn_Windth

#define TagValue  1110
#define AlertTime 0.25 //弹出动画时间

@interface InputSettingAlert ()

@property (nonatomic, strong)UIView *bouncedView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UITextField *inputField;

@end

@implementation InputSettingAlert


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initUI];
        
    }
    return self;
}

- (void)initUI{
    
    self.frame = KEYWINDOW.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    self.bouncedView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-bouncedView_Width*XLscaleW)/2, (ScreenHeight-bouncedView_height*XLscaleH)/2, bouncedView_Width*XLscaleW, bouncedView_height*XLscaleH)];
    self.bouncedView.backgroundColor = [UIColor whiteColor];
    XLViewBorderRadius(self.bouncedView, 10, 0, kClearColor);
    [self addSubview:self.bouncedView];
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 15*XLscaleH, self.bouncedView.xmg_width-20*XLscaleW, 50*XLscaleH)];
    titleLabel.textColor = colorblack_51;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(15*XLscaleH);
//    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.numberOfLines = 0;
    [self.bouncedView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    // 输入
    UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectMake(20*XLscaleW, 100*XLscaleH, self.bouncedView.xmg_width-40*XLscaleW, 40*XLscaleH)];
    inputField.backgroundColor = colorblack_222;
    XLViewBorderRadius(inputField, 5, 0, kClearColor);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:HEM_shuru_genggai_shezhi attributes:@{NSFontAttributeName:FontSize(13*XLscaleW), NSParagraphStyleAttributeName:style}];
    inputField.attributedPlaceholder = attri;
    inputField.textAlignment = NSTextAlignmentCenter;
    inputField.font = FontSize(13*XLscaleW);
    [self.bouncedView addSubview:inputField];
    self.inputField = inputField;

    // 取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bouncedView.xmg_height-40*XLscaleH, self.bouncedView.xmg_width/2-1, 40*XLscaleH)];
    [cancelBtn setTitle:root_cancel forState:UIControlStateNormal];
    [cancelBtn setTitleColor:colorblack_154 forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:colorblack_222];
    cancelBtn.titleLabel.font = FontSize(15*XLscaleH);
    [self.bouncedView addSubview:cancelBtn];
    // 确认
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bouncedView.xmg_width/2, self.bouncedView.xmg_height-40*XLscaleH, self.bouncedView.xmg_width/2, 40*XLscaleH)];
    [enterBtn setTitle:root_OK forState:UIControlStateNormal];
    [enterBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(tounchEnter) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn setBackgroundColor:colorblack_222];
    enterBtn.titleLabel.font = FontSize(15*XLscaleH);
    [self.bouncedView addSubview:enterBtn];
    
}

- (void)tounchEnter{
    
    if (self.inputField.text.length == 0) {
        [self showToastViewWithTitle: root_WO_buneng_weikong];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(InputSettingWithPrams:)]) {
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        NSString *inputText = self.inputField.text;
        [param setObject:inputText forKey:_itemText];
        
        [self.delegate InputSettingWithPrams:param];
    }
    
    if (self.touchAlertEnter) {
        self.touchAlertEnter(self.inputField.text);
    }
    
    [self hide];
}

- (void)touchCancel{
    
    if(self.touchAlertCancel){
        self.touchAlertCancel();
    }
    
    [self hide];
}

- (void)show {
    
    UIView *oldView = [KEYWINDOW viewWithTag:TagValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }

    self.tag = TagValue;
    [KEYWINDOW addSubview:self] ;

    self.alpha = 0;
    self.bouncedView.alpha = 0;
    self.bouncedView.transform = CGAffineTransformScale(self.bouncedView.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.alpha = 1;
        self.bouncedView.alpha = 1;
        self.bouncedView.transform = CGAffineTransformIdentity;
        self.inputField.text = @"";
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:HEM_shuru_genggai_shezhi attributes:@{NSFontAttributeName:FontSize(13*XLscaleW), NSParagraphStyleAttributeName:style}];
    self.inputField.attributedPlaceholder = attri;
}

- (void)hide {
    
    self.alpha = 1;
    self.bouncedView.alpha = 1;
    [UIView animateWithDuration:AlertTime animations:^{
        self.alpha = 0;
        self.bouncedView.alpha = 1;
        self.bouncedView.transform = CGAffineTransformScale(self.bouncedView.transform,0.1,0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
    
}

- (void)showToastViewWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)setTitleText:(NSString *)titleText{
    
    _titleText = titleText;
    
    self.titleLabel.text = titleText;
    
}

- (void)setCurrentText:(NSString *)currentText{
    
    _currentText = currentText;
    
    self.inputField.text = currentText;
}

- (void)setItemText:(NSString *)itemText{
    
    _itemText = itemText;
    
//    if ([_itemText isEqualToString:@"rate"] || [_itemText isEqualToString:@"power"]) {
//
//        self.inputField.keyboardType = UIKeyboardTypeNumberPad;
//    }else{
    
        self.inputField.keyboardType = UIKeyboardTypeDefault;
//    }
}

- (void)setPlaceholderText:(NSString *)PlaceholderText{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:PlaceholderText attributes:@{NSFontAttributeName:FontSize(13*XLscaleW), NSParagraphStyleAttributeName:style}];
    self.inputField.attributedPlaceholder = attri;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [KEYWINDOW endEditing:YES];
}

@end
