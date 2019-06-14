//
//  ChargingStateView.m
//  ShinePhone
//
//  Created by growatt007 on 2018/10/13.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "ChargingStateView.h"
#import "XLCircle.h"

@interface ChargingStateView ()

@property (nonatomic, strong) UIView *bgView;
// 准备中
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation ChargingStateView

- (instancetype)initWithFrame:(CGRect)frame Type:(NSString *)type{
    
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:self.bgView];
    
        [self createUIWithType:@"0"];
        
    }
    return self;
}

// 0-空闲  1-准备中  2-充电中  3-暂停充电  4-充电结束  5-故障  6-不可用
- (void)createUIWithType:(NSString *)type
{
//    type = @"Charging";
    if([type isEqualToString:@"Available"]){// 空闲
        
        if([self.userType isEqualToNumber:@0]){
            [self charingInPreparation];
        }else{
            [self chargingTips:root_charge_state_available isShowImageType:@"Available"];
        }
        
    }else if ([type isEqualToString:@"Preparing"]){// 准备中
        
        [self charingInPreparation];
        
    }else if ([type isEqualToString:@"Reserved"]){// 预约等待中
        
        [self charingInPreparation];
        
    }else if ([type isEqualToString:@"Charging"]){// 充电中
        
        if([_model.cKey isEqualToString:@"G_SetAmount"] || [_model.cKey isEqualToString:@"G_SetEnergy"] || [_model.cKey isEqualToString:@"G_SetTime"]){
            [self currectTimingCharging];
        }else{
            [self currectCharging];
        }
    
    }else if ([type isEqualToString:@"SuspendedEV"] || [type isEqualToString:@"SuspendedEVSE"]){// 通讯异常
        
        [self chargingTips:root_charge_state_unavailable isShowImageType:@"Unavailable"];
        
    }else if ([type isEqualToString:@"Finishing"]){// 充电结束
        
        [self chargingFinish];
        
    }else if ([type isEqualToString:@"Faulted"]){// 故障
        
        [self chargingTips:root_charge_state_faulted isShowImageType:@"Faulted"];
        
    }else if ([type isEqualToString:@"Unavailable"]){// 不可用
        
        [self chargingTips:root_charge_state_unavailable isShowImageType:@"Unavailable"];
        
    }else if ([type isEqualToString:@"6"]){// 既插既冲
        
        [self currectCharging];
    }
}

#pragma mark -- 充电提示
- (void)chargingTips:(NSString *)tips isShowImageType:(NSString *)imgType{
    
    float image2W = ScreenWidth*1/2, image2H = image2W/2.6, image2X = ScreenWidth/2 - image2W/2, image2Y = 20;
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(image2X, image2Y, image2W, image2H)];
    imageView2.image = [UIImage imageNamed:@"free_bg"];
    [self.bgView addSubview:imageView2];
    
    float imageW = 13*XLscaleH, imageH = 14*XLscaleH, imageX = self.xmg_width/2-imageW - 25, imageY = CGRectGetMaxY(imageView2.frame)-20;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    imageView.image = [UIImage imageNamed:@"Charging_fault_tishi"];
    [self.bgView addSubview:imageView];
    
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, imageY, 100, 17*XLscaleH)];
    tipsLabel.text = root_guoya;
    tipsLabel.textColor = colorblack_154;
    tipsLabel.font = FontSize(17*XLscaleH);
    [self.bgView addSubview:tipsLabel];
    
    UILabel *tipsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView2.frame) + 10, self.xmg_width, 40*XLscaleH)];
    tipsLabel2.text = tips;
    tipsLabel2.textColor = colorblack_154;
    tipsLabel2.font = FontSize(16*XLscaleH);
    tipsLabel2.numberOfLines = 0;
    tipsLabel2.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:tipsLabel2];
    
    if ([imgType isEqualToString:@"Available"]) {// 空闲
        imageView.hidden = YES;
        tipsLabel.hidden = YES;
    }else if ([imgType isEqualToString:@"Faulted"]) {// 过压
        imageView2.hidden = YES;
    }else if ([imgType isEqualToString:@"Unavailable"]) {// 不可用
        imageView.hidden = YES;
        imageView2.hidden = YES;
        tipsLabel.hidden = YES;
    }
}

#pragma mark -- 充电结束
- (void)chargingFinish{
    
    NSArray *valueArray= [_model getSupendData];
    NSArray *nameArray=@[root_charge_dianliang,root_charge_feilv,root_charge_shichang,root_charge_jine];
    NSArray *imageArray=@[@"Charging_dianliang",@"Charging_feilv",@"Charging_time",@"Charging_qian"];
    float marginTop = 12*XLscaleH, viewW = (self.xmg_width-3*marginTop)/2, viewH = (self.xmg_height-3*marginTop - 16*XLscaleH)/2;
    for (NSInteger i = 0; i < nameArray.count; i ++) {
        float z1 = i%2, z2 = i/2;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(marginTop+z1*(viewW+marginTop), marginTop+z2*(viewH+marginTop), viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        XLViewBorderRadius(view, 5, 0, kClearColor);
        [self.bgView addSubview:view];
        
        float imageW = 18*XLscaleH, imageH = 18*XLscaleH, imageX = 24*XLscaleW, imageY = (viewH-imageH)/2;
        UIImageView *infoTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        infoTypeImgView.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:infoTypeImgView];

        float detaW = view.xmg_width-imageW-imageX, detaH = 16*XLscaleH, detaX = CGRectGetMaxX(infoTypeImgView.frame)+20*XLscaleW, detaY = (viewH-2*detaH-11)/2;
        UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(detaX, detaY, detaW, detaH)];
        detailLB.textAlignment = NSTextAlignmentLeft;
        detailLB.textColor = colorblack_51;
        detailLB.adjustsFontSizeToFitWidth = YES;
        detailLB.font = [UIFont systemFontOfSize:16*XLscaleH];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:valueArray[i] number:colorblack_51 letter:colorblack_154];
        detailLB.attributedText = attribute;
        [view addSubview:detailLB];

        UILabel *infoNameLB = [[UILabel alloc] initWithFrame:CGRectMake(detailLB.xmg_x, CGRectGetMaxY(detailLB.frame)+11, detaW, detaH)];
        infoNameLB.textAlignment = NSTextAlignmentLeft;
        infoNameLB.textColor = COLOR(153, 153, 153, 1);
        infoNameLB.font = [UIFont systemFontOfSize:15*XLscaleH];
        infoNameLB.adjustsFontSizeToFitWidth = YES;
        infoNameLB.text = nameArray[i];
        [view addSubview:infoNameLB];
    }
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.xmg_height-17*XLscaleH, self.xmg_width, 16*XLscaleH)];
    tipsLabel.text = root_chongdianjieshu;
    tipsLabel.textColor = colorblack_154;
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:tipsLabel];
}


#pragma mark -- 充电中
- (void)currectCharging{
    
    NSArray *valueArray = [_model getChargingData][@"value"];
    
    NSArray *nameArray=@[root_charge_dianliang,root_charge_feilv,root_charge_dianliu,root_charge_shichang,root_charge_jine,root_charge_dianya];
    NSArray *imageArray=@[@"Charging_dianliang",@"Charging_feilv",@"Charging_dianliu",@"Charging_time",@"Charging_qian",@"Charging_dianya"];
    float marginTop = 10*XLscaleH, viewW = (self.xmg_width-4*marginTop)/3, viewH = (self.xmg_height-3*marginTop)/2;
    for (NSInteger i = 0; i < nameArray.count; i ++) {
        float z1 = i%3, z2 = i/3;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(marginTop+z1*(viewW+marginTop), marginTop+z2*(viewH+marginTop), viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        XLViewBorderRadius(view, 5*XLscaleW, 0, kClearColor);
        [self.bgView addSubview:view];
        
        float imageW = 18*XLscaleH, imageH = 18*XLscaleH, imageX = 18*XLscaleW, margintop2 = (viewH-imageH-30*XLscaleH)/4;
        UIImageView *infoTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, margintop2, imageW, imageH)];
        infoTypeImgView.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:infoTypeImgView];
        
        float detaW = view.xmg_width-imageW, detaH = 15*XLscaleH;
        UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(imageX, CGRectGetMaxY(infoTypeImgView.frame)+margintop2, detaW, detaH)];
        detailLB.font = [UIFont systemFontOfSize:14*XLscaleH];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:valueArray[i] number:colorblack_51 letter:colorblack_154];
        detailLB.attributedText = attribute;
        [view addSubview:detailLB];
        
        UILabel *infoNameLB = [[UILabel alloc] initWithFrame:CGRectMake(imageX, CGRectGetMaxY(detailLB.frame)+margintop2, detaW, detaH)];
        infoNameLB.textAlignment = NSTextAlignmentLeft;
        infoNameLB.textColor = COLOR(153, 153, 153, 1);
        infoNameLB.font = [UIFont systemFontOfSize:14*XLscaleH];
        infoNameLB.adjustsFontSizeToFitWidth = YES;
        infoNameLB.text = nameArray[i];
        [view addSubview:infoNameLB];
    }
}

#pragma mark -- 预订充电中
- (void)currectTimingCharging{
    
    NSArray *nameArray1;
    NSArray *nameArray2;
    NSArray *imageArray2;
    NSString *titleText;
    
    if([_model.cKey isEqualToString:@"G_SetAmount"]){// 金额
    
        titleText = root_charge_yushe_fangan_jine;
        nameArray1=@[root_charge_yushe_jine,root_charge_jine];
        nameArray2=@[root_charge_dianliang,root_charge_shichang];
        imageArray2=@[@"Charging_dianliang",@"Charging_time"];
    
    }
    else if([_model.cKey isEqualToString:@"G_SetEnergy"]){// 电量

        titleText = root_charge_yushe_fangan_dianliang;
        nameArray1=@[root_charge_yushe_dianliang,root_charge_dianliang];
        nameArray2=@[root_charge_jine,root_charge_shichang];
        imageArray2=@[@"Charging_qian",@"Charging_time"];

    }else if([_model.cKey isEqualToString:@"G_SetTime"]){// 时间

        titleText = root_charge_yushe_fangan_shichang;
        nameArray1=@[root_charge_yushe_shichang,root_charge_shichang];
        nameArray2=@[root_charge_dianliang,root_charge_jine];
        imageArray2=@[@"Charging_dianliang",@"Charging_qian"];

    }

    NSArray *valueArray1 = [_model getChargingData][@"value1"];
    NSArray *valueArray2 = [_model getChargingData][@"value2"];
    NSArray *valueArray3 = [_model getChargingData][@"value3"];
    float progress = [[_model getChargingData][@"progress"] floatValue];
    if (progress > 1) {
        progress = 1.0;
    }else if (progress <= 0) {
        progress = 0.0;
    }
    
    float marginLF = 10*XLscaleW, marginBottom = 5*XLscaleH, tViewW = (self.xmg_width-2*marginLF-marginBottom)*3/5, tViewH = (self.xmg_height-marginBottom)*2/3;
    UIView *TimingView = [[UIView alloc]initWithFrame:CGRectMake(marginLF, 0, tViewW, tViewH)];
    TimingView.backgroundColor = [UIColor whiteColor];
    XLViewBorderRadius(TimingView, 5, 0, kClearColor);
    [self.bgView addSubview:TimingView];
    
    float labelW = tViewW-2*marginLF, labelH=15*XLscaleH;
    UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(marginLF, marginBottom+3, labelW, labelH+2)];
    titleLabel.text = titleText; //@"Preset program-Amount";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = colorblack_154;
//    titleLabel.font = [UIFont systemFontOfSize:15*XLscaleH];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [TimingView addSubview:titleLabel];
    

    NSArray *colorArray = @[COLOR(202, 208, 213, 1), COLOR(48, 229, 120, 1)];
    float view2Y = CGRectGetMaxY(titleLabel.frame)+2, view2W = tViewW/2, view2H = (tViewH-view2Y)/2;
    for (int i=0; i < colorArray.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, view2Y+view2H*i, view2W, view2H)];
        [TimingView addSubview:view];
        
        float label2W = 100*XLscaleW, label2H = 14*XLscaleH, paddingTop = (view2H-27*XLscaleH-5)/2;
        UILabel *timingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*XLscaleW+8*XLscaleW, paddingTop, label2W, label2H)];
        timingLabel.textColor = colorblack_51;
        timingLabel.font = [UIFont systemFontOfSize:15*XLscaleH];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:valueArray1[i] number:colorblack_51 letter:colorblack_154];
        timingLabel.attributedText = attribute;
        [view addSubview:timingLabel];
        
        UIView *style = [[UIView alloc] initWithFrame:CGRectMake(marginLF, paddingTop+(label2H-8*XLscaleH)/2, 8*XLscaleH, 8*XLscaleH)];
        style.layer.backgroundColor = [colorArray[i] CGColor];
        XLViewBorderRadius(style, 4, 0, kClearColor);
        [view addSubview:style];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timingLabel.xmg_x, CGRectGetMaxY(timingLabel.frame)+5, 110*XLscaleW, 14*XLscaleH)];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.textColor = colorblack_154;
        typeLabel.font = [UIFont systemFontOfSize:11*XLscaleH];
        typeLabel.text = nameArray1[i];
        [view addSubview:typeLabel];
    }
    
    // 进度条    tViewH-CGRectGetMaxY(titleLabel.frame)-45
    float circleY = TimingView.xmg_height-80*XLscaleH, circleH = 65*XLscaleH, circleX = TimingView.xmg_width-20*XLscaleW-circleH, lineWidth = 8*XLscaleH, font = 12*XLscaleH;
    if(IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max){
        circleY = TimingView.xmg_height-60*XLscaleH;
        circleH = 50*XLscaleH;
        circleX = TimingView.xmg_width-20*XLscaleW-circleH;
        lineWidth = 6*XLscaleH;
        font = 10*XLscaleH;
    }
    XLCircle* circle = [[XLCircle alloc] initWithFrame:CGRectMake(circleX, circleY, circleH, circleH) lineWidth:lineWidth];
    circle.progress = progress;
    [TimingView addSubview:circle];
    // 显示百分比
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(circle.center.x-25*XLscaleW, circle.center.y-10*XLscaleH, 50*XLscaleW, 20*XLscaleH)];
    percentLabel.textColor = colorblack_154;
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.font = [UIFont boldSystemFontOfSize:font];
    [TimingView addSubview:percentLabel];
    percentLabel.text = [NSString stringWithFormat:@"%.1f%%",progress*100];

    // 右边的view
    float LF_viewW = (self.xmg_width-2*marginLF-marginBottom)*2/5, LF_viewH = (self.xmg_height-marginBottom)*2/3;
    UIView *rightView = [self createView:CGRectMake(CGRectGetMaxX(TimingView.frame)+marginBottom, 0, LF_viewW, LF_viewH) ImageArray:imageArray2 ValueArray:valueArray2 TitleArray:nameArray2 type:0];
    XLViewBorderRadius(rightView, 5, 0, kClearColor);
    [self.bgView addSubview:rightView];

    // 底下的view
    NSArray *nameArray3=@[root_charge_feilv,root_charge_dianliu,root_charge_dianya];
    NSArray *imageArray3=@[@"Charging_feilv",@"Charging_dianliu",@"Charging_dianya"];
    float BT_viewW = self.xmg_width-2*marginLF, BT_viewH = (self.xmg_height-marginBottom)*1/3;
    UIView *BottomView = [self createView:CGRectMake(marginLF, CGRectGetMaxY(TimingView.frame)+marginBottom, BT_viewW, BT_viewH) ImageArray:imageArray3 ValueArray:valueArray3 TitleArray:nameArray3 type:1];
    XLViewBorderRadius(BottomView, 5, 0, kClearColor);
    [self.bgView addSubview:BottomView];
}
// 创建 view
- (UIView *)createView:(CGRect)rect ImageArray:(NSArray *)imageArray ValueArray:(NSArray *)valueArray TitleArray:(NSArray *)titleArray type:(int)type{
    
    UIView *view1 = [[UIView alloc]initWithFrame:rect];
    view1.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:view1];
    
    float viewW = view1.xmg_width, viewH = view1.xmg_height/imageArray.count;// 纵向
    if (type) { // 横向
        viewW = view1.xmg_width/imageArray.count;
        viewH = view1.xmg_height;
    }
    for (int i=0; i < imageArray.count; i++) {
        UIView *view2 = [[UIView alloc]init];
        if (type) {
            view2.frame = CGRectMake(i*viewW, 0, viewW, viewH);// 横向
        }else{
            view2.frame = CGRectMake(0, i*viewH, viewW, viewH);// 纵向
        }
        [view1 addSubview:view2];
        
        float imageW = 18*XLscaleH, imageH = 18*XLscaleH, imageX = 18*XLscaleW, margintop2 = (viewH-imageH)/2;
        UIImageView *infoTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, margintop2, imageW, imageH)];
        infoTypeImgView.image = [UIImage imageNamed:imageArray[i]];
        [view2 addSubview:infoTypeImgView];
        
        float detaW = viewW-imageW-imageX, detaH = 16*XLscaleH, detaY = (viewH-2*detaH - 10*XLscaleW)/2;
        UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(infoTypeImgView.frame)+10*XLscaleW, detaY, detaW, detaH)];
        detailLB.font = [UIFont systemFontOfSize:14*XLscaleH];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:valueArray[i] number:colorblack_51 letter:colorblack_154];
        detailLB.attributedText = attribute;
        [view2 addSubview:detailLB];
        
        UILabel *infoNameLB = [[UILabel alloc] initWithFrame:CGRectMake(detailLB.xmg_x, CGRectGetMaxY(detailLB.frame)+10*XLscaleW, detaW, detaH+2)];
        infoNameLB.textAlignment = NSTextAlignmentLeft;
        infoNameLB.textColor = COLOR(153, 153, 153, 1);
        infoNameLB.font = [UIFont systemFontOfSize:13*XLscaleH];
        infoNameLB.adjustsFontSizeToFitWidth = YES;
        infoNameLB.text = titleArray[i];
        [view2 addSubview:infoNameLB];
    }
    return view1;
}

#pragma mark -- 准备中
- (void)charingInPreparation{
    
    NSDictionary *dict = [_model getReserveNow];// 获取预定信息
    
    if (![self.userType isEqualToNumber:@0]) { // 非桩主不显示预约信息
        dict = @{@"cKey": @"",@"value": @[@"--", @"-- kWh", @"- h - min"],@"value2": @"--"};
    }
    
    float marginLF = 12*XLscaleH;
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, 5, 100*XLscaleW, 17*XLscaleH)];
    tipsLabel.text = root_yushe_fangan;
    tipsLabel.textColor = colorblack_51;
//    tipsLabel.font = FontSize(13*XLscaleH);
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:tipsLabel];
    
    UILabel *tipsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipsLabel.frame), 5*XLscaleH, ScreenWidth-CGRectGetMaxX(tipsLabel.frame)-marginLF, 15*XLscaleH)];
    tipsLabel2.text = root_yushe_tips;
    tipsLabel2.textColor = colorblack_154;
//    tipsLabel2.font = FontSize(10*XLscaleH);
    tipsLabel2.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:tipsLabel2];
    
    NSArray *imageNameArray = @[@"prepare_money",@"prepare_dianliang",@"prepare_time"];
    NSArray *titleArray = @[root_jine,root_dianliang,root_shichang];
    NSArray *valueArray = dict[@"value"];
    float viewW = (self.xmg_width - 2*marginLF - 16)/3, viewH = (self.xmg_height-(5+15+5+10+15+5+5)*XLscaleH)/2;
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(marginLF+(viewW+8)*i, CGRectGetMaxY(tipsLabel2.frame)+5, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        XLViewBorderRadius(view, 5, 0, kClearColor);
        [self.bgView addSubview:view];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorCharingProgramme:)];
        [view addGestureRecognizer:tapGesture];
        view.tag = 1000 + i;
        
        float marginLF2 = 10*XLscaleH, imageW = 14*XLscaleH,imageH = 14*XLscaleH;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(marginLF2/2, marginLF2, imageW, imageH)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        [view addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, marginLF2, 50*XLscaleW, 15*XLscaleH)];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = colorblack_154;
        titleLabel.font = FontSize(12*XLscaleH);
        [view addSubview:titleLabel];
        
        // 选择方案
        CGFloat buttonW = 18*XLscaleH ,buttonH = 18*XLscaleH, buttonX = viewW - buttonW - 5;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, marginLF2, buttonW, buttonH)];
        [button setImage:[UIImage imageNamed:@"prepare_weixuan"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"prepare_yixuan"] forState:UIControlStateSelected];
//        button.transform = CGAffineTransformMakeScale(1*XLscaleW, 1*XLscaleW);
        button.tag = 1500 + i;
        [button addTarget:self action:@selector(selectorCharingProgramme:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        // 数值
        CGFloat buttonW2 = viewW ,buttonH2 = 15*XLscaleH;
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, viewH - buttonH2 - 12*XLscaleW, buttonW2, buttonH2)];
        [button2 setImage:[UIImage imageNamed:@"prepare_more"] forState:UIControlStateNormal];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:valueArray[i] number:colorblack_154 letter:colorblack_154];
        [button2 setAttributedTitle:attribute forState:UIControlStateNormal];
        button2.titleLabel.font = FontSize(15*XLscaleH);
        button2.tag = 2000 + i;
        [button2 addTarget:self action:@selector(SettingCharingValue:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button2];
        [self setButtonTitleAndImage:button2];
    }
    
    float tipsLBY = CGRectGetMaxY(tipsLabel.frame) + viewH + 15*XLscaleH;
    UILabel *tipsLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(marginLF ,tipsLBY ,200*XLscaleW ,17*XLscaleH)];
    tipsLabel3.text = root_yuyuechongdian;
    tipsLabel3.textColor = colorblack_51;
    tipsLabel3.font = tipsLabel.font;
    [self.bgView addSubview:tipsLabel3];
    
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(marginLF, CGRectGetMaxY(tipsLabel3.frame)+5, self.xmg_width-2*marginLF, viewH)];
    orderView.backgroundColor = [UIColor whiteColor];
    XLViewBorderRadius(orderView, 5, 0, kClearColor);
    [self.bgView addSubview:orderView];
    if ([self.userType isEqualToNumber:@0]) {// 桩主
        tipsLabel3.hidden = NO;
        orderView.hidden = NO;
    }else{ // 分享用户
        tipsLabel3.hidden = YES;
        orderView.hidden = YES;
    }
    
    float marginLF3 = 8*XLscaleH;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF3+18*XLscaleW, marginLF3, 100*XLscaleW, 20*XLscaleH)];
    titleLabel.text = root_kaishishijian;
    titleLabel.textColor = colorblack_154;
    titleLabel.font = FontSize(13*XLscaleH);
    [orderView addSubview:titleLabel];
    
    float imageW = 15*XLscaleH,imageH = 15*XLscaleH, imageY = viewH-16*XLscaleH-marginLF3;
    UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(marginLF/2, marginLF3+3, imageW, imageH)];
    timeImageView.image = [UIImage imageNamed:@"prepare_yuyue"];
    [orderView addSubview:timeImageView];
    
    // 时间
    CGFloat buttonW2 = orderView.xmg_width-2*marginLF-20*XLscaleW  ,buttonH2 = 15*XLscaleH;
    UIButton *timeButton = [[UIButton alloc]initWithFrame:CGRectMake(marginLF+20*XLscaleW, imageY, buttonW2, buttonH2)];
    [timeButton setImage:[UIImage imageNamed:@"prepare_more"] forState:UIControlStateNormal];
    [timeButton setTitle:dict[@"value2"] forState:UIControlStateNormal];
    [timeButton setTitleColor:colorblack_51 forState:UIControlStateNormal];
    timeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    timeButton.titleLabel.font = FontSize(15*XLscaleH);
    [timeButton addTarget:self action:@selector(SettingCharingTime:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:timeButton];
    _timeButton = timeButton;
    [self setButtonTitleAndImage:timeButton];// 图片文字位置
    
    // 是否循环
    UIButton *looptypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, imageY, 80*XLscaleW, imageH)];
    [looptypeBtn setTitle:root_meitian forState:UIControlStateNormal];
    [looptypeBtn setTitleColor:colorblack_102 forState:UIControlStateNormal];
    [looptypeBtn setTitleColor:mainColor forState:UIControlStateSelected];
    [looptypeBtn setImage:IMAGE(@"sign_xieyi") forState:UIControlStateNormal];
    [looptypeBtn setImage:IMAGE(@"sign_xieyi_click") forState:UIControlStateSelected];
    looptypeBtn.titleLabel.font = FontSize(12*XLscaleH);
    [looptypeBtn setImageEdgeInsets:UIEdgeInsetsMake(13*XLscaleH, 0, 13*XLscaleH, 10)];
    looptypeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [looptypeBtn addTarget:self action:@selector(touchSelectLooptype:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:looptypeBtn];
    _looptypeBtn = looptypeBtn;
    if ([_model.LastAction isKindOfClass:[NSDictionary class]]) { // 判断是否为NSDictionary
        if ([dict[@"looptype"] isEqualToNumber:@0] && [_model.LastAction[@"action"] isEqualToString:@"ReserveNow"]) {// 判断最后一次操作
            looptypeBtn.selected = YES;// 循环
        }
    }else{
        looptypeBtn.selected = NO;// 不循环
    }

    float switchW = 51*XLscaleH, switchH = 21*XLscaleH, switchX = self.xmg_width - 2*marginLF - switchW;
    UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(switchX, 5*XLscaleH, switchW, switchH)];
    switchButton.onTintColor = COLOR(1, 229, 137, 1);
    switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [orderView addSubview:switchButton];
    _switchButton = switchButton;
    if ([_model.LastAction isKindOfClass:[NSDictionary class]]) { // 判断是否为NSDictionary
        if (_model.ReserveNow.count > 0 && [_model.LastAction[@"action"] isEqualToString:@"ReserveNow"]) {
            _switchButton.on = YES;
        }
    }
    if(![self.userType isEqualToNumber:@0]){
        _switchButton.on = NO;
    }
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(switchButton.frame)-60*XLscaleW-10, switchButton.xmg_centerY-7*XLscaleH, 60*XLscaleW, 15*XLscaleH)];
    stateLabel.text = root_yiguanbi;
    stateLabel.textColor = colorblack_154;
    stateLabel.font = FontSize(13*XLscaleH);
    stateLabel.textAlignment = NSTextAlignmentRight;
    [orderView addSubview:stateLabel];
    _stateLabel = stateLabel;
    if (_switchButton.on) {
        stateLabel.text = root_yikaiqi;
    }
    
    NSString *programme = @"";
    if ([dict[@"cKey"] isEqualToString:@"G_SetAmount"]) {// 金额
        programme = @"Amount";
    }else if ([dict[@"cKey"] isEqualToString:@"G_SetEnergy"]){// 电量
        programme = @"Electricity";
    }else if ([dict[@"cKey"] isEqualToString:@"G_SetTime"]){//时间
        programme = @"Time";
    }
    // 刷新方案勾选
    [self reloadCurrentProgramme:programme];
}

#pragma mark -- 点击事件

// 选择切换方案
- (void)selectorCharingProgramme:(id )sender{
    
    UIView *view;
    if ([sender isKindOfClass:[UIButton class]]) {
        view = sender;
    }else{
        UITapGestureRecognizer *tap = sender;
        view = tap.view;
    }
    NSInteger tag = view.tag;
    NSString *programme = @"";
    
    if (tag == 1500 || tag == 1000) {// 金额
        programme = @"Amount";
        _looptypeBtn.hidden = NO; // 显示是否循环按键
    }else if (tag == 1501 || tag == 1001){// 电量
        programme = @"Electricity";
        _looptypeBtn.hidden = NO;
    }else if (tag == 1502 || tag == 1002){//时间
        programme = @"Time";
        _looptypeBtn.hidden = YES;
    }
    // 刷新勾选的预设方案
    [self reloadCurrentProgramme:programme];
    
    UIButton *button1;
    NSArray *titleArray = @[@"--", @"-- kWh", @"- h - min"];
    for (NSInteger i = 0; i < 3; i++) {
        button1 = [self viewWithTag:i+2000];
        // 清空显示
        NSMutableAttributedString *attribute = [self changeAttributeWithString:titleArray[i] number:colorblack_154 letter:colorblack_154];
        [button1 setAttributedTitle:attribute forState:UIControlStateNormal];
        [self setButtonTitleAndImage:button1];
    }
    
    // 清空定时显示
    [_timeButton setTitle:@"--" forState:UIControlStateNormal];
    [self setButtonTitleAndImage:_timeButton];
    
    // 还原按钮状态
    _switchButton.on = NO;
    _stateLabel.text = root_yiguanbi;
    
    // 还原是否循环按键
    _looptypeBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(SelectChargingProgramme:)]) {
        [self.delegate SelectChargingProgramme:programme];
    }
}


//设定数值
- (void)SettingCharingValue:(UIButton *)button{
    
    NSInteger tag = button.tag;
    NSString *programme = @"";
    
    if (tag == 2000) {// 金额
        programme = @"Amount";
    }else if (tag == 2001){// 电量
        programme = @"Electricity";
    }else if (tag == 2002){//时间
        programme = @"Time";
    }
    
    if ([self.delegate respondsToSelector:@selector(ChargingStatePresetValueWithProgramme:)]) {
        [self.delegate ChargingStatePresetValueWithProgramme:programme];
    }
}


// 定时列表
- (void)SettingCharingTime:(UIButton *)button{
    
    if([self.delegate respondsToSelector:@selector(ChargingTimingList:)]){
        [self.delegate ChargingTimingList:@"0"];
    }
}


// 是否开启
- (void)switchAction:(UISwitch *)switchBtn{
    
    if (switchBtn.isOn) {
        _stateLabel.text = root_yikaiqi;
    }else{
        _stateLabel.text = root_yiguanbi;
        // 清空时长显示
        UIButton *button = [self viewWithTag:2002];
        NSMutableAttributedString *attribute = [self changeAttributeWithString:@"- h - min" number:colorblack_154 letter:colorblack_154];
        [button setAttributedTitle:attribute forState:UIControlStateNormal];
        [self setButtonTitleAndImage:button];
        // 清空开始时间显示
        [_timeButton setTitle:@"--" forState:UIControlStateNormal];
        [self setButtonTitleAndImage:_timeButton];
    }
    if([self.delegate respondsToSelector:@selector(ChargingTimingList:)]){
        [self.delegate ChargingTimingList:@"1"];
    }
}

// 是否选择循环
- (void)touchSelectLooptype:(UIButton *)button{
    
    button.selected = !button.isSelected;
}


// 改变字符串中英文字母的大小
- (NSMutableAttributedString *)changeAttributeWithString:(NSString *)string number:(UIColor *)color1 letter:(UIColor *)color2{
    string = [NSString stringWithFormat:@"%@", string];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    for (int i = 0; i < AttributedStr.length; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [string substringWithRange:range];
        if ([self deptNumInputShouldLetter:str]) {
            [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0*XLscaleH], NSForegroundColorAttributeName:color2} range:range];
        }else{
            [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0*XLscaleH], NSForegroundColorAttributeName:color1} range:range];
        }
    }
    return AttributedStr;
}

// 判断字符串是否为英文字母
- (BOOL)deptNumInputShouldLetter:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[A-Za-z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


#pragma mark -- 方法
// 设置方案预设值
- (void)setProgrammeWithValue:(NSString *)value1 Value2:(NSString *)value2 programme:(NSString *)programme{
    
    self.currentPrograme = programme;
    UIButton *button1;
    // 更新勾选状态
    for (NSInteger i = 1500; i < 1503; i++) {
        button1 = [self viewWithTag:i];
        button1.selected = NO;
    }
    
    UIButton *button;
    NSString *showString = @"";
    if ([programme isEqualToString:@"Amount"]) {// 金额
        button = [self viewWithTag:2000];
        showString = value1;
        button1 = [self viewWithTag:1500];
        button1.selected = YES;
    }else if ([programme isEqualToString:@"Electricity"]) {// 电量
        button = [self viewWithTag:2001];
        showString = [NSString stringWithFormat:@"%@ kWh",value1];
        button1 = [self viewWithTag:1501];
        button1.selected = YES;
    }else if ([programme isEqualToString:@"Time"]) {// 时间
        button = [self viewWithTag:2002];
        showString = [NSString stringWithFormat:@"%@ h %@ min",value1, value2];
        button1 = [self viewWithTag:1502];
        button1.selected = YES;
    }
    
    // 设置显示值
    NSMutableAttributedString *attribute = [self changeAttributeWithString:showString number:colorblack_154 letter:colorblack_154];
    [button setAttributedTitle:attribute forState:UIControlStateNormal];
    [self setButtonTitleAndImage:button];
    // 刷新勾选的预设方案
//    [self reloadCurrentProgramme:programme];
    
}

// 调整UIButton图片与文字位置
- (void)setButtonTitleAndImage:(UIButton *)button{
    CGFloat interval = 1.0;
    // button标题的偏移量
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.bounds.size.width-interval, 0, button.imageView.bounds.size.width+interval);
    // button图片的偏移量
    button.imageEdgeInsets = UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width+interval, 0, -button.titleLabel.bounds.size.width-interval);
}

// 刷新勾选的预设方案
- (void)reloadCurrentProgramme:(NSString *)programme{
    
    NSInteger tag = 0;
    
    if ([programme isEqualToString:@"Amount"]) {// 金额
        tag = 1500;
        _looptypeBtn.hidden = NO;
    }else if ([programme isEqualToString:@"Electricity"]) {// 电量
        tag = 1501;
        _looptypeBtn.hidden = NO;
    }else if ([programme isEqualToString:@"Time"]) {// 时间
        tag = 1502;
        _looptypeBtn.hidden = YES;
    }
    
    UIButton *button;
    // 更新勾选状态
    for (NSInteger i = 1500; i < 1503; i++) {
        button = [self viewWithTag:i];
        if (i == tag) {
            button.selected = !button.isSelected;
        }else{
            button.selected = NO;
        }
    }
    
    // 标志当前勾选状态
    self.currentPrograme = @"";
    for (NSInteger i = 1500; i < 1503; i++) {
        button = [self viewWithTag:i];
        if(button.isSelected){
            if (i == 1500) {
                self.currentPrograme = @"Amount";
            }else if(i == 1501){
                self.currentPrograme = @"Electricity";
            }else if(i == 1502){
                self.currentPrograme = @"Time";
            }
        }
    }
    if (![_currentPrograme isEqualToString:@"Time"]) {
        _looptypeBtn.hidden = NO;
    }
}

// setting
- (void)setModel:(ChargingpileInfoModel *)model{
    
    _model = model;
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.bgView];
    
    [self createUIWithType:model.status];
}

// 刷新定时按键的显示
- (void)setTimeButtonWithTitle:(NSString *)time{
    
    [_timeButton setTitle:time forState:UIControlStateNormal];
    [self setButtonTitleAndImage:_timeButton];
}




@end
