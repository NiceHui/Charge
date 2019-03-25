//
//  ChargeRecordCell.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/10.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargeRecordCell.h"

@interface ChargeRecordCell ()

// 左侧
@property (nonatomic, strong) UILabel *nameLabel;// 电桩名
@property (nonatomic, strong) UILabel *IDLabel;// 电桩ID
@property (nonatomic, strong) UILabel *modeLabel;// 类型

// 右侧
@property (nonatomic, strong) UILabel *timeLabel;// 日期时间
@property (nonatomic, strong) UILabel *formLabel;// 开始时间
@property (nonatomic, strong) UILabel *stopLabel;// 结束时间

// 下侧
@property (nonatomic, strong) UILabel *totalLabel;// 时长
@property (nonatomic, strong) UILabel *electricLabel;// 电量
@property (nonatomic, strong) UILabel *payLabel;// 花费

@end

@implementation ChargeRecordCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createUIView];
    }
    
    return self;
}


- (void)createUIView{
    
    self.backgroundColor = kClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    float cellW = ScreenWidth, cellH = 145*XLscaleH - 7*XLscaleH, marginLF = 13*XLscaleH, marginTop = 11*XLscaleH;
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 7*XLscaleH, cellW, cellH)];
    cellView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellView];
    
    // 左侧
    float nameLBW = 150*XLscaleW, nameLBH = 17*XLscaleH;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, marginTop, nameLBW, nameLBH)];
    nameLabel.text = @"车库电桩";
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = FontSize(18*XLscaleH);
    [cellView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, CGRectGetMaxY(nameLabel.frame)+6*XLscaleH, nameLBW, 11*XLscaleH)];
    IDLabel.text = @"ID:12345671234";
    IDLabel.textColor = colorblack_154;
    IDLabel.font = FontSize(11*XLscaleH);
    [cellView addSubview:IDLabel];
    _IDLabel = IDLabel;
    
    UILabel *modeLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, CGRectGetMaxY(IDLabel.frame)+13*XLscaleH, nameLBW, 15*XLscaleH)];
    modeLabel.text = @"交流双枪(A枪)";
    modeLabel.textColor = colorblack_154;
    modeLabel.font = FontSize(15*XLscaleH);
    [cellView addSubview:modeLabel];
    _modeLabel = modeLabel;
    
    // 右侧
    float timeW = 75*XLscaleW, timeH = 14*XLscaleH, timeX = cellW-timeW-19*XLscaleW;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeX, marginTop, timeW, timeH)];
    timeLabel.text = @"2018/10/13";
    timeLabel.textColor = colorblack_102;
//    timeLabel.font = FontSize(13*XLscaleH);
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [cellView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    float imgVWidth = 7*XLscaleW;
    UIImageView *startImageV = [[UIImageView alloc]initWithFrame:CGRectMake(timeX, CGRectGetMaxY(timeLabel.frame)+marginTop+imgVWidth/2, imgVWidth, imgVWidth)];
    startImageV.image = [UIImage imageNamed:@"record_start"];
    [cellView addSubview:startImageV];
    
    UILabel *formLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startImageV.frame)+5*XLscaleW, CGRectGetMaxY(timeLabel.frame)+marginTop, timeW, 12*XLscaleH)];
    formLabel.text = @"00:00";
    formLabel.textColor = colorblack_51;
    formLabel.font = FontSize(12*XLscaleH);
    [cellView addSubview:formLabel];
    _formLabel = formLabel;
    
    UIImageView *endImageV = [[UIImageView alloc]initWithFrame:CGRectMake(timeX, CGRectGetMaxY(formLabel.frame)+10*XLscaleH+imgVWidth/2, imgVWidth, imgVWidth)];
    endImageV.image = [UIImage imageNamed:@"record_finish"];
    [cellView addSubview:endImageV];
    
    UILabel *stopLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(endImageV.frame)+5*XLscaleW, CGRectGetMaxY(formLabel.frame)+10*XLscaleH, timeW, 12*XLscaleH)];
    stopLabel.text = @"00:00";
    stopLabel.textColor = colorblack_51;
    stopLabel.font = FontSize(12*XLscaleH);
    [cellView addSubview:stopLabel];
    _stopLabel = stopLabel;
    
    // 下侧
    // 时长
    float margin3 = CGRectGetMaxY(modeLabel.frame)+15*XLscaleH, imageW = 18*XLscaleW;
    UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(marginLF, margin3, imageW, imageW)];
    timeImageView.image = [UIImage imageNamed:@"Charging_time"];
    [cellView addSubview:timeImageView];
    
    float labelH = 13*XLscaleH, labelW = 100*XLscaleW, diff = (imageW-labelH)/2;
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame)+5, margin3+diff, labelW, labelH)];
    NSMutableAttributedString *attribute = [self changeAttributeWithString:@"24 h 20 min" number:colorblack_51 fontsize1:labelH letter:colorblack_154 fontsize2:12.0];
    totalLabel.attributedText = attribute;
    [cellView addSubview:totalLabel];
    _totalLabel = totalLabel;
    
    UILabel *totalLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(totalLabel.frame), CGRectGetMaxY(totalLabel.frame)+10, labelW, labelH+2)];
    totalLabel2.text = root_shichang;
    totalLabel2.textColor = colorblack_154;
    totalLabel2.font = FontSize(labelH);
    [cellView addSubview:totalLabel2];
    
    // 电量
    float imageX = cellW/2 - (imageW + labelW)/2 + 20;
    UIImageView *electricImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, margin3, imageW, imageW)];
    electricImageView.image = [UIImage imageNamed:@"Charging_dianliang"];
    [cellView addSubview:electricImageView];
    
    UILabel *electricLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(electricImageView.frame)+5, margin3+diff, labelW, labelH)];
    NSMutableAttributedString *attribute2 = [self changeAttributeWithString:@"100 kWh" number:colorblack_51 fontsize1:labelH letter:colorblack_154 fontsize2:12.0];
    electricLabel.attributedText = attribute2;
    [cellView addSubview:electricLabel];
    _electricLabel = electricLabel;
    
    UILabel *electricLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(electricLabel.frame), CGRectGetMaxY(totalLabel.frame)+10, labelW, labelH+2)];
    electricLabel2.text = root_dianliang;
    electricLabel2.textColor = colorblack_154;
    electricLabel2.font = FontSize(labelH);
    [cellView addSubview:electricLabel2];
    
    //金额
    float image2X = cellW - imageW - labelW + 10;
    UIImageView *payImageView = [[UIImageView alloc]initWithFrame:CGRectMake(image2X, margin3, imageW, imageW)];
    payImageView.image = [UIImage imageNamed:@"Charging_qian"];
    [cellView addSubview:payImageView];
    
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(payImageView.frame)+5, margin3+diff, labelW, labelH)];
    payLabel.text = @"0.0";
    payLabel.textColor = colorblack_51;
    payLabel.font = FontSize(labelH);
    [cellView addSubview:payLabel];
    _payLabel = payLabel;
    
    UILabel *payLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(payLabel.frame), CGRectGetMaxY(totalLabel.frame)+10, labelW, labelH+2)];
    payLabel2.text = root_jine;
    payLabel2.textColor = colorblack_154;
    payLabel2.font = FontSize(labelH);
    [cellView addSubview:payLabel2];
    
}

// 改变字符串中英文字母的大小
- (NSMutableAttributedString *)changeAttributeWithString:(NSString *)string number:(UIColor *)color1 fontsize1:(CGFloat)size1 letter:(UIColor *)color2 fontsize2:(CGFloat)size2{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    for (int i = 0; i < AttributedStr.length; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [string substringWithRange:range];
        if ([self deptNumInputShouldLetter:str]) {
            [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size2], NSForegroundColorAttributeName:color2} range:range];
        }else{
            [AttributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size1], NSForegroundColorAttributeName:color1} range:range];
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

// 赋值
- (void)setCellDataWithModel:(ChargeRecordModel *)model{
    
    _nameLabel.text = model.chargeName.length ? model.chargeName : model.chargeId;
    _IDLabel.text = [NSString stringWithFormat:@"ID:%@",model.chargeId];
    _modeLabel.text = model.getConnectorIdName;
    
    _timeLabel.text = [self time_timestampToString:[model.sysStartTime integerValue]][0];
    _formLabel.text = [self time_timestampToString:[model.sysStartTime integerValue]][1];
    _stopLabel.text = [self time_timestampToString:[model.sysStartTime integerValue] + [model.ctime integerValue]*60*1000][1];
    
    NSInteger chargeTime = [model.ctime integerValue];
    NSString *hour = [NSString stringWithFormat:@"%ld",chargeTime/60];
    NSString *min = [NSString stringWithFormat:@"%ld",chargeTime%60];
    min = [NSString SupplementZero:min];
    NSString *total = [NSString stringWithFormat:@"%@ h %@ min",hour, min];// 时长
    NSMutableAttributedString *attribute1 = [self changeAttributeWithString:total number:colorblack_51 fontsize1:13*XLscaleH letter:colorblack_154 fontsize2:12.0];
    _totalLabel.attributedText = attribute1;
    
    NSString *electric = [NSString stringWithFormat:@"%.3f kWh",[model.energy floatValue]];// 电量
    NSMutableAttributedString *attribute2 = [self changeAttributeWithString:electric number:colorblack_51 fontsize1:13*XLscaleH letter:colorblack_154 fontsize2:12.0];
    _electricLabel.attributedText = attribute2;
    
    NSString *pay = [NSString stringWithFormat:@"%.3f",[model.cost floatValue]];// 花费
    NSMutableAttributedString *attribute3 = [self changeAttributeWithString:pay number:colorblack_51 fontsize1:13*XLscaleH letter:colorblack_154 fontsize2:12.0];
    _payLabel.attributedText = attribute3;
}

// 时间戳转字符串
- (NSArray *)time_timestampToString:(NSInteger)timestamp{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [dateFormat setDateFormat:@"yyyy"];
    NSString *Year=[dateFormat stringFromDate:confromTimesp];
    [dateFormat setDateFormat:@"MM"];
    NSString *Month=[dateFormat stringFromDate:confromTimesp];
    [dateFormat setDateFormat:@"dd"];
    NSString *Day=[dateFormat stringFromDate:confromTimesp];
    
    [dateFormat setDateFormat:@"HH"];
    NSString *hour=[dateFormat stringFromDate:confromTimesp];
    [dateFormat setDateFormat:@"mm"];
    NSString *Min=[dateFormat stringFromDate:confromTimesp];
    
    NSArray *timeArray = @[[NSString stringWithFormat:@"%@/%@/%@",Year, Month, Day],
                           [NSString stringWithFormat:@"%@:%@",hour, Min]];
    
    return timeArray;
}


@end
