//
//  SetTimeRateAlert.m
//  charge
//
//  Created by growatt007 on 2019/6/18.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "SetTimeRateAlert.h"
#import "CGXPickerView.h"
#import "MBProgressHUD.h"

#define bouncedView_Width 300
#define bouncedView_height 400

#define dismissBtn_Windth 24
#define dismissBtn_height dismissBtn_Windth

#define TagValue  3330
#define AlertTime 0.25 //弹出动画时间

@interface SetTimeRateAlert ()<UITextFieldDelegate>{
    NSInteger selectNum;
}

@property (nonatomic, strong)UIView *bouncedView;

@property (nonatomic, strong)UITextField *inputField;

@end

@implementation SetTimeRateAlert

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initUI];
        
        // 添加通知监听见键盘弹出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        // 添加通知监听见键盘收起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
        // 点击取消
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:@"CGXSTRING_TOUCH_CANCEL" object:nil];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHideKeyBoard)];
    [self.bouncedView addGestureRecognizer:tapGesture];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 15*XLscaleH, self.bouncedView.xmg_width-20*XLscaleW, 40*XLscaleH)];
    titleLabel.text = HEM_charge_feilv;
    titleLabel.textColor = colorblack_51;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(15*XLscaleH);
    titleLabel.numberOfLines = 0;
    [self.bouncedView addSubview:titleLabel];
    
    CGFloat viewY = CGRectGetMaxY(titleLabel.frame);
    CGFloat viewH = 45*XLscaleH;
    for (int i = 0; i < 6; i++) {
        UIView *view1 = [self createTimeRateViewFrame:CGRectMake(0, viewY, bouncedView_Width, viewH) Time:@"11:20~20:30" Rate:@"1.5" tag:i];
        [self.bouncedView addSubview:view1];
        viewY += viewH;
    }
    
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


- (UIView *)createTimeRateViewFrame:(CGRect)rect Time:(NSString *)time Rate:(NSString *)rate tag:(NSInteger)tag{

    UIView *view = [[UIView alloc]initWithFrame:rect];
    
    CGFloat viewW = rect.size.width, viewH = rect.size.height;
    CGFloat marginLF = 10*XLscaleW;
    CGFloat lblW = (viewW - 2*marginLF)/2 - 12*XLscaleW;
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, 0, lblW, viewH)];
    lblTime.tag = 1500 +tag;
    lblTime.text = root_xuanzeshijian;
    lblTime.textColor = colorblack_102;
    lblTime.textAlignment = NSTextAlignmentCenter;
    lblTime.font = FontSize([NSString getFontWithText:lblTime.text size:lblTime.xmg_size currentFont:13*XLscaleH]);
    [view addSubview:lblTime];
    lblTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToAddTime:)];
    [lblTime addGestureRecognizer:tapG];
    
    
    CGFloat imgW = 10*XLscaleW, imgH = 15*XLscaleH;
    UIImageView *imgDir = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblTime.frame), (viewH-imgH)/2, imgW, imgH)];
    imgDir.image = IMAGE(@"frag4");
    [view addSubview:imgDir];
    
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = CGRectMake(viewW/2, (viewH-20*XLscaleH)/2, 1, 25*XLscaleH);
    lineLayer.backgroundColor = COLOR(236, 239, 241, 1).CGColor;
    [view.layer addSublayer:lineLayer];

    CGFloat tfW = (viewW - 2*marginLF)/2;
    UITextField *tfRate = [[UITextField alloc]initWithFrame:CGRectMake(viewW/2+2, 0, tfW*0.8, viewH)];
    tfRate.placeholder = HEM_charge_feilv;
    tfRate.textColor = colorblack_102;
    tfRate.textAlignment = NSTextAlignmentCenter;
    [tfRate setValue:[UIFont boldSystemFontOfSize:12*XLscaleH] forKeyPath:@"_placeholderLabel.font"];
    tfRate.font = FontSize(13*XLscaleH);
    tfRate.tag = 1600 + tag;
    tfRate.delegate=self;
    [view addSubview:tfRate];
    
    UILabel *lblUnit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tfRate.frame), 0, tfW*0.2, viewH)];
    lblUnit.text = @"$";
    lblUnit.textColor = colorblack_102;
    lblUnit.font = FontSize(13*XLscaleH);
    lblUnit.textAlignment = NSTextAlignmentCenter;
    lblUnit.adjustsFontSizeToFitWidth = YES;
    [view addSubview:lblUnit];
    
    CALayer *lineLayer2 = [[CALayer alloc]init];
    lineLayer2.frame = CGRectMake(0, viewH-1, viewW, 1);
    lineLayer2.backgroundColor = COLOR(236, 239, 241, 1).CGColor;
    [view.layer addSublayer:lineLayer2];
    
    return view;
}

// 选择开始时间结束时间
-(void)goToAddTime:(UITapGestureRecognizer *)gesture{
    
    UILabel *label = (UILabel *)gesture.view;
    selectNum = label.tag - 1500;
    
    if (selectNum > 2) {
        self.bouncedView.frame = CGRectMake((ScreenWidth-bouncedView_Width*XLscaleW)/2, (ScreenHeight-bouncedView_height*XLscaleH)/2-3*45*XLscaleH, bouncedView_Width*XLscaleW, bouncedView_height*XLscaleH);
    }
    
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        if (i<10) {
            [hours addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [hours addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    NSMutableArray *mins = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        if (i<10) {
            [mins addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [mins addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    // 获取已设置值，显示出来
    NSArray *dfStart = @[@"00", @"00"];
    NSArray *dfEnd = @[@"23", @"59"];
    NSArray *timeArray = [label.text componentsSeparatedByString:@"-"];
    if (timeArray.count == 2) {
        dfStart = [timeArray[0] componentsSeparatedByString:@":"];
        dfEnd = [timeArray[1] componentsSeparatedByString:@":"];
    }
    
    [CGXPickerView showStringPickerWithTitle:root_kaishishijian DataSource:@[hours,mins] DefaultSelValue:dfStart IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
        NSLog(@"%@:%@",selectValue[0],selectValue[1]);
        
        [CGXPickerView showStringPickerWithTitle:root_jieshushijian DataSource:@[hours,mins] DefaultSelValue:dfEnd IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue2, id selectRow2) {
            NSLog(@"%@:%@",selectValue2[0],selectValue2[1]);
            
            label.text = [NSString stringWithFormat:@"%@:%@-%@:%@", selectValue[0],selectValue[1], selectValue2[0],selectValue2[1]];
        }];
    }];
    
}

// textField开始编辑的时候
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    selectNum = textField.tag - 1600;
    return YES;
}

// 点击确定
- (void)tounchEnter{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *timeArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        UILabel *lblTime = [self viewWithTag:1500+i];
        UITextField *tfRate = [self viewWithTag:1600+i];
        
        if([lblTime.text rangeOfString:@"-"].location != NSNotFound) {// 是否为正确的时间段输入
            if ([tfRate.text isEqualToString:HEM_charge_feilv]) { // 是否有输入
                if (![NSString isNum:tfRate.text]) { // 是否为数字
                    [self showToastViewWithTitle:root_geshi_cuowu];
                    return;
                }
                [dataArray addObject:@{@"time": lblTime.text, @"price": tfRate.text, @"name": @""}];
                [timeArray addObject:[lblTime.text componentsSeparatedByString:@":"]];
            }
        }
    }
    
    
    
    if(self.touchAlertCancel){
        self.touchAlertCancel();
    }
    [self hide];
}

// 点击取消
- (void)touchCancel{
    if(self.touchAlertCancel){
        self.touchAlertCancel();
    }
    [self hide];
}

// 弹框显示
- (void)show {
    
    // 刷新显示值
    for (int i = 0; i < self.timeRateArray.count; i++) {
        UILabel *lblTime = [self viewWithTag:1500+i];
        UITextField *tfRate = [self viewWithTag:1600+i];
        
        NSDictionary *dict = self.timeRateArray[i];
        
        lblTime.text = [NSString stringWithFormat:@"%@",dict[@"time"]];
        tfRate.text = [NSString stringWithFormat:@"%@",dict[@"price"]];
    }
    
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
    }];
}
// 隐藏弹框
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

// 键盘弹出
- (void)keyboardAction:(NSNotification*)sender{
    
    if (selectNum > 2) { // 大于2就把view位置提高
        self.bouncedView.frame = CGRectMake((ScreenWidth-bouncedView_Width*XLscaleW)/2, (ScreenHeight-bouncedView_height*XLscaleH)/2-3*45*XLscaleH, bouncedView_Width*XLscaleW, bouncedView_height*XLscaleH);
    }
}
// 键盘隐藏
- (void)keyboardHideAction:(NSNotification*)sender{
    
    if (selectNum > 2) { // 把view位置还原
        self.bouncedView.frame = CGRectMake((ScreenWidth-bouncedView_Width*XLscaleW)/2, (ScreenHeight-bouncedView_height*XLscaleH)/2, bouncedView_Width*XLscaleW, bouncedView_height*XLscaleH);
    }
}

- (void)touchHideKeyBoard{
    [self endEditing:YES];
}


@end
