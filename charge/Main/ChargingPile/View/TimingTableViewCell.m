//
//  TimingTableViewCell.m
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "TimingTableViewCell.h"

@implementation TimingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self initUI];
    }
    
    return self;
}


- (void)initUI{
    
    float marginLF = 10*XLscaleW;
    float lblH = 15*XLscaleH, marginTop = (55-2*15)/3*XLscaleH;
    float lblW = (ScreenWidth-2*marginLF)/5;
    _openTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, marginTop, lblW, lblH)];
    _openTitleLabel.text = root_kaiqi;
    _openTitleLabel.textColor = colorblack_51;
    _openTitleLabel.font=FontSize(13*XLscaleH);
    _openTitleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_openTitleLabel];
    
    _closeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, CGRectGetMaxY(_openTitleLabel.frame)+marginTop, lblW, lblH)];
    _closeTitleLabel.text = root_guanbi;
    _closeTitleLabel.textColor = colorblack_51;
    _closeTitleLabel.font=FontSize(13*XLscaleH);
    _closeTitleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_closeTitleLabel];
    
    _startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_openTitleLabel.frame), marginTop, lblW, lblH)];
    _startTimeLabel.textColor = colorblack_51;
    _startTimeLabel.font=FontSize(12*XLscaleH);
    _startTimeLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_startTimeLabel];
    
    _endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_openTitleLabel.frame), CGRectGetMaxY(_openTitleLabel.frame)+marginTop, lblW, lblH)];
    _endTimeLabel.textColor = colorblack_51;
    _endTimeLabel.font=FontSize(12*XLscaleH);
    _endTimeLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_endTimeLabel];
    
    _lengthTImeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_endTimeLabel.frame), (55*XLscaleH-lblH)/2, lblW, lblH)];
    _lengthTImeLabel.textColor = colorblack_154;
    _lengthTImeLabel.font=FontSize(12*XLscaleH);
    _lengthTImeLabel.textAlignment=NSTextAlignmentCenter;
    _lengthTImeLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_lengthTImeLabel];
    
    _loopTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lengthTImeLabel.frame), (55*XLscaleH-lblH)/2, lblW-5*XLscaleW, lblH)];
    _loopTitleLabel.text = root_meitian;
    _loopTitleLabel.textColor = mainColor;
    _loopTitleLabel.font=FontSize(12*XLscaleH);
    _loopTitleLabel.textAlignment=NSTextAlignmentRight;
    _loopTitleLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_loopTitleLabel];
    
    _loopButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_loopTitleLabel.frame)+2*XLscaleW, (55*XLscaleH-15*XLscaleH)/2, 15*XLscaleH, 15*XLscaleH)];
    [_loopButton setImage:IMAGE(@"sign_xieyi") forState:UIControlStateNormal];
    [_loopButton setImage:IMAGE(@"sign_xieyi_click") forState:UIControlStateSelected];
    [_loopButton addTarget:self action:@selector(set_IsLoopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loopButton];
    
    float btnW = 40*XLscaleW, btnH = 30*XLscaleW;
    _controlSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth-2*marginLF-btnW, (55*XLscaleH-btnH)/2, btnW, btnH)];
    _controlSwitch.onTintColor = mainColor;
    _controlSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _controlSwitch.on = NO;
    [_controlSwitch addTarget:self action:@selector(touchOpenTimng:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_controlSwitch];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55*XLscaleH-1, ScreenWidth, 1)];
    lineView.backgroundColor = colorblack_222;
    [self addSubview:lineView];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.closeTitleLabel.textColor = colorblack_51;
//    self.openTitleLabel.textColor = colorblack_51;
//    self.closeTitleLabel.textColor = colorblack_51;
//    self.openTitleLabel.text = root_kaiqi;
//    self.closeTitleLabel.text = root_guanbi;
//    self.openTitleLabel.font = FontSize(12*XLscaleH);
//    self.closeTitleLabel.font = FontSize(12*XLscaleH);
    
//    self.startTimeLabel.textColor = colorblack_51;
//    self.endTimeLabel.textColor = colorblack_51;
//    self.lengthTImeLabel.textColor = colorblack_154;
//    self.startTimeLabel.font = FontSize(12*XLscaleH);
//    self.endTimeLabel.font = FontSize(12*XLscaleH);
//    self.lengthTImeLabel.adjustsFontSizeToFitWidth = YES;
    
//    self.loopTitleLabel.textColor = mainColor;
//    self.loopTitleLabel.text = root_meitian;
//    self.loopTitleLabel.adjustsFontSizeToFitWidth = YES;
    
//    self.controlSwitch.onTintColor = mainColor;
//    self.controlSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    self.controlSwitch.on = NO;
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54*XLscaleH, ScreenWidth, 1*XLscaleH)];
//    lineView.backgroundColor = colorblack_222;
//    [self addSubview:lineView];
}

// cell赋值
- (void)setCellDataWithModel:(ChargeTimingModel *)model{
    
    NSString *expiryDate = model.expiryDate;
    NSArray *expiryArray = [self separateTime:expiryDate];
    
    NSInteger cValue = [model.cValue integerValue]; // 通过开始时间和时长计算结束时间
    NSInteger endValue = cValue + [expiryArray[1] integerValue]*60 + [expiryArray[2] integerValue];// 计算总时间
    NSString *end_hour = [NSString SupplementZero:[NSString stringWithFormat:@"%d",endValue/60]];
    NSString *end_min = [NSString SupplementZero:[NSString stringWithFormat:@"%d",endValue%60]];
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@:%@",end_hour,end_min];
    
    NSInteger timeLength = [model.cValue integerValue];
    NSString *hour = [NSString stringWithFormat:@"%d", timeLength/60];
    NSString *min = [NSString SupplementZero:[NSString stringWithFormat:@"%d", timeLength%60]];
    self.lengthTImeLabel.text = [NSString stringWithFormat:@"%@h%@min",hour,min];
    
    if ([model.loopType isEqualToNumber:@0]) {
        self.loopButton.selected = YES;
    }else{
        self.loopButton.selected = NO;
    }
    
    if([model.status isEqualToString:@"Accepted"]) {
        self.controlSwitch.on = YES;
    }else {
        self.controlSwitch.on = NO;
    }
    
}

// 分离时间
- (NSArray *)separateTime:(NSString *)time{
    
    NSMutableString *string = [NSMutableString stringWithString:time];
    NSMutableString *string2 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"T" withString:@":"]];
    NSString *time1 = [string2 stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSArray *array = [time1 componentsSeparatedByString:@":"];// @"2018-10-20:11:30:27.666"
    
    return array;
}


- (void)set_IsLoopAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
    
    if(self.touchOpenOrCloseTiming){
        self.touchOpenOrCloseTiming(self.controlSwitch.isOn, self.loopButton.isSelected ,@"button");
    }
}


- (void)touchOpenTimng:(UISwitch *)sender {
    
    if(self.touchOpenOrCloseTiming){
        self.touchOpenOrCloseTiming(sender.on, self.loopButton.isSelected, @"switch");
    }
    
}

@end
