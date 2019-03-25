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
    
    _titleLabel.text = state ? root_open_solar : root_close_solar ;
    
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
    
    float paddingLF = 10*XLscaleW;
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLF, 2*paddingLF, bouncedView_Width-2*paddingLF, 15*XLscaleH)];
    titleLabel.text = root_open_solar;
    titleLabel.textColor = colorblack_102;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(12*XLscaleW);
    [self.bouncedView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(paddingLF, CGRectGetMaxY(titleLabel.frame)+3*XLscaleH, bouncedView_Width-2*paddingLF, 15*XLscaleH)];
    titleLabel2.text = @"8:00am~8:00pm";
    titleLabel2.textColor = colorblack_102;
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.font = FontSize(12*XLscaleW);
    [self.bouncedView addSubview:titleLabel2];
    
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


@end
