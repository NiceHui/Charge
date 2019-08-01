//
//  SolarTipsAlert.m
//  charge
//
//  Created by growatt007 on 2018/11/21.
//  Copyright © 2018 hshao. All rights reserved.
//

#import "SolarTipsAlert.h"

#define TagValue  1220
#define AlertTime 0.25 //弹出动画时间

@interface SolarTipsAlert (){
    float bouncedView_Width;
    float bouncedView_height;
    float bouncedView_Y;
}

@property (nonatomic, strong)UIView *bouncedView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *titleLabel2;

@property (nonatomic, strong)UIButton *btnSwitch;

@property (nonatomic, strong)UIButton *enterBtn;

@end

@implementation SolarTipsAlert

- (instancetype)initWithButtonFrame:(CGRect)rect{
    
    if (self = [super init]) {
        
        bouncedView_Width = ScreenWidth - 2*(rect.origin.x +rect.size.width+ 3*XLscaleW);
        bouncedView_height = bouncedView_Width*3/5;
        bouncedView_Y = rect.origin.y + rect.size.height/2;
        [self initUI];
    }
    return self;
}

- (void)setState:(BOOL)state{
    
    _state = state;
    
//    _titleLabel.text = state ? root_open_solar : root_close_solar ;
    
    if (state) {
        [_enterBtn setTitle:root_kaiqi forState:UIControlStateNormal];
    }else{
        [_enterBtn setTitle:root_guanbi forState:UIControlStateNormal];
    }
}

- (void)initUI{
    
    self.frame = KEYWINDOW.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    self.bouncedView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-bouncedView_Width*XLscaleW)/2, bouncedView_Y, bouncedView_Width*XLscaleW, bouncedView_height*XLscaleH)];
    self.bouncedView.backgroundColor = [UIColor whiteColor];
    XLViewBorderRadius(self.bouncedView, 10, 0, kClearColor);
    [self addSubview:self.bouncedView];
    
    float paddingLF = 10*XLscaleW, paddingTop = (self.bouncedView.xmg_height-40*XLscaleH-30*XLscaleH)/3;
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLF, paddingTop, bouncedView_Width*XLscaleW-2*paddingLF, 15*XLscaleH)];
    titleLabel.text = @"";
    titleLabel.textColor = colorblack_102;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(12*XLscaleW);
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.bouncedView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(paddingLF, CGRectGetMaxY(titleLabel.frame)+paddingTop, bouncedView_Width*XLscaleW-2*paddingLF, 15*XLscaleH)];
    titleLabel2.text = @"";
    titleLabel2.textColor = colorblack_102;
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.font = FontSize(12*XLscaleW);
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.bouncedView addSubview:titleLabel2];
    _titleLabel2 = titleLabel2;
    
    // 切换模式按键
    UIButton *btnSwitch = [[UIButton alloc]initWithFrame:CGRectMake(paddingLF, CGRectGetMaxY(titleLabel2.frame)+3, bouncedView_Width*XLscaleW-2*paddingLF, paddingTop)];
    [btnSwitch setTitle:[NSString stringWithFormat:@"%@ ECO+",root_MAX_300] forState:UIControlStateNormal];
    [btnSwitch setTitle:[NSString stringWithFormat:@"%@ ECO",root_MAX_300] forState:UIControlStateSelected];
    [btnSwitch setTitleColor:mainColor forState:UIControlStateNormal];
    [btnSwitch addTarget:self action:@selector(touchSwitchSolarModel:) forControlEvents:UIControlEventTouchUpInside];
    btnSwitch.titleLabel.font = FontSize(12*XLscaleH);
    btnSwitch.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.bouncedView addSubview:btnSwitch];
    _btnSwitch = btnSwitch;
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bouncedView.xmg_height-40*XLscaleH, self.bouncedView.xmg_width/2-1, 40*XLscaleH)];
    [cancelBtn setTitle:root_cancel forState:UIControlStateNormal];
    [cancelBtn setTitleColor:colorblack_154 forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = FontSize(14*XLscaleH);
    [self.bouncedView addSubview:cancelBtn];
    // 确认
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bouncedView.xmg_width/2, self.bouncedView.xmg_height-40*XLscaleH, self.bouncedView.xmg_width/2, 40*XLscaleH)];
    [enterBtn setTitle:root_OK forState:UIControlStateNormal];
    [enterBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(tounchEnter) forControlEvents:UIControlEventTouchUpInside];
    enterBtn.titleLabel.font = FontSize(14*XLscaleH);
    [self.bouncedView addSubview:enterBtn];
    _enterBtn = enterBtn;
    
}

- (void)tounchEnter{
    
    if (self.touchAlertEnter) {
        self.touchAlertEnter();
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

// 切换模式
- (void)touchSwitchSolarModel:(UIButton *)button{
    
    if (self.touchAlertSwitchSolarModel) {
        // 1: ECO   2: ECO+
        self.touchAlertSwitchSolarModel(button.isSelected ? @1 : @2);
    }
    
    [self hide];
}

// 显示当前设置的solar模式
- (void)setDeviceModel:(GRTChargingPileModel *)deviceModel{
    
    NSString *G_SolarMode = [NSString stringWithFormat:@"%@",deviceModel.G_SolarMode];
    NSString *G_SolarLimitPower = [NSString stringWithFormat:@"%@", deviceModel.G_SolarLimitPower];
    
    _titleLabel.text = @"";
    if ([G_SolarMode isEqualToString:@"2"]) {
        _titleLabel.text = [NSString stringWithFormat:@"%@:%@",root_solar_mode, @"ECO+"];
        _titleLabel2.text = [NSString stringWithFormat:@"%@:%@kWh",root_eco_current_limit,G_SolarLimitPower];
        _btnSwitch.hidden=NO;
        _btnSwitch.selected = YES;
    } else if([G_SolarMode isEqualToString:@"1"]){
        _titleLabel2.text = [NSString stringWithFormat:@"%@:%@",root_solar_mode, @"ECO"];
        _btnSwitch.hidden=NO;
        _btnSwitch.selected = NO;
    } else if([G_SolarMode isEqualToString:@"0"]){
        _titleLabel2.text = [NSString stringWithFormat:@"%@:%@",root_solar_mode, @"FAST"];
        _btnSwitch.hidden=YES;
    }else{
        _titleLabel2.text = root_weishezhi;
        _enterBtn.enabled = NO;
        _btnSwitch.hidden=YES;
    }
}

@end
