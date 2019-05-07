//
//  SelectTimeAlert.m
//  charge
//
//  Created by growatt007 on 2019/4/10.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "SelectTimeAlert.h"
#import "MBProgressHUD.h"
#import "CGXPickerView.h"

#define bouncedView_Width 260
#define bouncedView_height 240

#define dismissBtn_Windth 24
#define dismissBtn_height dismissBtn_Windth

#define TagValue  2220
#define AlertTime 0.25 //弹出动画时间

@interface SelectTimeAlert (){
    
    NSString *rightButtonString;
    NSString *leftButtonString;
}

@property (nonatomic, strong)UIView *bouncedView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIButton *leftButton;

@property (nonatomic, strong)UIButton *rightButton;

@end

@implementation SelectTimeAlert

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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 20*XLscaleH, self.bouncedView.xmg_width-20*XLscaleW, 40*XLscaleH)];
    titleLabel.textColor = colorblack_51;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(15*XLscaleH);
    titleLabel.numberOfLines = 0;
    [self.bouncedView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    float buttonW=100*XLscaleW;
    float buttonH=30*XLscaleH;
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10*XLscaleW, 100*XLscaleH, buttonW, buttonH)];
    [self.leftButton setTitle:root_kaishishijian forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = FontSize(14*XLscaleH);
    self.leftButton.tag=2000;
    self.leftButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.leftButton setTitleColor:colorblack_102 forState:UIControlStateNormal];
    [self.leftButton setBackgroundColor:colorblack_222];
    self.leftButton.layer.cornerRadius = buttonH*0.5;
    [self.leftButton addTarget:self action:@selector(goToAddTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.bouncedView  addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(bouncedView_Width-110*XLscaleW, 100*XLscaleH, buttonW, buttonH)];
    [self.rightButton setTitle:root_jieshushijian forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = FontSize(14*XLscaleH);
    self.rightButton.tag=3000;
    self.rightButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.rightButton.layer.cornerRadius = buttonH*0.5;
    [self.rightButton setTitleColor:colorblack_102 forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:colorblack_222];
    [self.rightButton addTarget:self action:@selector(goToAddTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.bouncedView  addSubview:self.rightButton];
    
    float lableW=10*XLscaleW;
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake((bouncedView_Width-lableW)/2, 100*XLscaleH, lableW, buttonH)];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.adjustsFontSizeToFitWidth=YES;
    titleLable.font = FontSize(18*XLscaleH);
    titleLable.text=@"~";
    titleLable.textColor = colorblack_102;
    [self.bouncedView addSubview:titleLable];
    
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
    
    if (leftButtonString==nil || [leftButtonString isEqualToString:@""]) {
        [self showToastViewWithTitle:HEM_weishezhi_kaishishijian];
        return;
    }
    if (rightButtonString==nil || [rightButtonString isEqualToString:@""]) {
        [self showToastViewWithTitle:root_weishezhi_jieshushijian];
        return;
    }
    
//    NSArray *starTimes0 = [leftButtonString componentsSeparatedByString:@":"];
//    NSArray *endTimes0 = [rightButtonString componentsSeparatedByString:@":"];
//
//    int starMin0 = [starTimes0[0] intValue]*60 + [starTimes0[1] intValue];
//    int endMin0 = [endTimes0[0] intValue]*60 + [endTimes0[1] intValue];
//
//    if (starMin0 >= endMin0) {
//        [self showToastViewWithTitle:root_bunengdayu_jieshushijian];
//        return;
//    }
    
    if (self.touchAlertEnter) {
        NSString *timeString=[NSString stringWithFormat:@"%@-%@",leftButtonString,rightButtonString];
        self.touchAlertEnter(timeString);
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
        [self.leftButton setTitle:root_kaishishijian forState:UIControlStateNormal];
        [self.rightButton setTitle:root_jieshushijian forState:UIControlStateNormal];
    }];
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
    self.titleLabel.font = FontSize([NSString getFontWithText:self.titleLabel.text size:self.titleLabel.xmg_size currentFont:17*XLscaleH]);
}

- (void)setSelectTime:(NSString *)selectTime{
    
    _selectTime = selectTime;
    
    if (self.selectTime.length > 0) {
        
        NSArray *array = [self.selectTime componentsSeparatedByString:@"-"];
        [self.leftButton setTitle:kStringIsEmpty(array[0]) ? root_kaishishijian : array[0] forState:UIControlStateNormal];
        [self.rightButton setTitle:kStringIsEmpty(array[1]) ? root_jieshushijian : array[1] forState:UIControlStateNormal];
        
        leftButtonString = kStringIsEmpty(array[0]) ? root_kaishishijian : array[0];
        rightButtonString = kStringIsEmpty(array[1]) ? root_jieshushijian : array[1];
    }
}


-(void)goToAddTime:(UIButton*)button{
    NSInteger NUM=button.tag;
    [CGXPickerView showDatePickerWithTitle:root_xuanzeshijian DateType:UIDatePickerModeCountDownTimer DefaultSelValue:nil MinDateStr:@"" MaxDateStr:@"" IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        if (NUM==2000) {
            [self.leftButton setTitle:selectValue forState:UIControlStateNormal];
            self->leftButtonString=selectValue;
        }else if (NUM==3000) {
            [self.rightButton setTitle:selectValue forState:UIControlStateNormal];
            self->rightButtonString=selectValue;
        }
        
    }];
}





@end
