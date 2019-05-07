//
//  TimingTableViewCell.m
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "TimingTableViewCell.h"

@implementation TimingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.closeTitleLabel.textColor = colorblack_51;
    self.openTitleLabel.textColor = colorblack_51;
    self.closeTitleLabel.textColor = colorblack_51;
    self.openTitleLabel.text = root_kaiqi;
    self.closeTitleLabel.text = root_guanbi;
    self.openTitleLabel.font = FontSize(12*XLscaleH);
    self.closeTitleLabel.font = FontSize(12*XLscaleH);
    
    self.startTimeLabel.textColor = colorblack_51;
    self.endTimeLabel.textColor = colorblack_51;
    self.lengthTImeLabel.textColor = colorblack_154;
    self.startTimeLabel.font = FontSize(12*XLscaleH);
    self.endTimeLabel.font = FontSize(12*XLscaleH);
    self.lengthTImeLabel.adjustsFontSizeToFitWidth = YES;
    
    self.loopTitleLabel.textColor = mainColor;
    self.loopTitleLabel.text = root_meitian;
    self.loopTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.controlSwitch.onTintColor = mainColor;
    self.controlSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.controlSwitch.on = NO;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54*XLscaleH, ScreenWidth, 1*XLscaleH)];
    lineView.backgroundColor = colorblack_222;
    [self addSubview:lineView];
}

// cell赋值
- (void)setCellDataWithModel:(ChargeTimingModel *)model{
    
    NSString *expiryDate = model.expiryDate;
    NSArray *expiryArray = [self separateTime:expiryDate];
    
    NSInteger cValue = [model.cValue integerValue]; // 通过开始时间和时长计算结束时间
    NSInteger endValue = cValue + [expiryArray[1] integerValue]*60 + [expiryArray[2] integerValue];// 计算总时间
    NSString *end_hour = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue/60]];
    NSString *end_min = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue%60]];
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@:%@",end_hour,end_min];
    
    NSInteger timeLength = [model.cValue integerValue];
    NSString *hour = [NSString stringWithFormat:@"%ld", timeLength/60];
    NSString *min = [NSString SupplementZero:[NSString stringWithFormat:@"%ld", timeLength%60]];
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


- (IBAction)set_IsLoopAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
    
    if(self.touchOpenOrCloseTiming){
        self.touchOpenOrCloseTiming(self.controlSwitch.isOn, self.loopButton.isSelected ,@"button");
    }
}


- (IBAction)touchOpenTimng:(UISwitch *)sender {
    
    if(self.touchOpenOrCloseTiming){
        self.touchOpenOrCloseTiming(sender.on, self.loopButton.isSelected, @"switch");
    }
    
}

@end
