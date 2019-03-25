//
//  AuthorizationCell.m
//  ShinePhone
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "AuthorizationCell.h"

@implementation AuthorizationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, 60*XLscaleH)];
        cellView.backgroundColor = [UIColor whiteColor];
        XLViewBorderRadius(cellView, 5, 0, kClearColor);
        [self addSubview:cellView];
        
        UILabel *dateLB = [[UILabel alloc] initWithFrame:CGRectMake(19, 12*XLscaleH, 80*XLscaleW, 12*XLscaleH)];
        dateLB.textColor = colorblack_102;
        dateLB.font = [UIFont systemFontOfSize:12*XLscaleW];
        self.dateLB = dateLB;
        NSString *dateStr = @"2018/05/22";
        dateLB.text = dateStr;
        [cellView addSubview:dateLB];
        
        UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(dateLB.xmg_x, CGRectGetMaxY(dateLB.frame)+14*XLscaleH, 80*XLscaleW, dateLB.xmg_height)];
        timeLB.textColor = colorblack_102;
        timeLB.font = [UIFont systemFontOfSize:12*XLscaleW];
        self.timeLB = timeLB;

        NSString *timeStr = @"9:00";
        timeLB.text = timeStr;
        [cellView addSubview:timeLB];
        
        float imgW = 12*XLscaleW, imgH = 14*XLscaleW;
        UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLB.frame)+42*XLscaleW, (cellView.xmg_height-imgH)/2, imgW, imgH)];
        userImgView.image = IMAGE(@"userlist_user");
        [cellView addSubview:userImgView];

        UILabel *accountLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame)+12*XLscaleW, 22*XLscaleH, 120*XLscaleW, 15*XLscaleH)];
        accountLB.textColor = colorblack_51;
        accountLB.font = [UIFont systemFontOfSize:14*XLscaleW];
        accountLB.text = @"-----";
        self.accountLB = accountLB;
        [cellView addSubview:accountLB];
        
        float btnW = 18*XLscaleW, btnH = 18*XLscaleH, btnX = cellView.xmg_width-11*XLscaleW-btnW, btnY = (cellView.xmg_height-btnH)/2;
        UIButton *deleButton = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [deleButton setImage:[UIImage imageNamed:@"userlist_dalet"] forState:UIControlStateNormal];
        [deleButton addTarget:self action:@selector(touchDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:deleButton];
        
    }
    return self;
}

// 复制
- (void)copyTextAction{
    if (self.touchCopyTextBlock) {
        self.touchCopyTextBlock(self.passwordLB.text);
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.passwordLB.text;
}

// 删除
- (void)touchDeleteButton{
    
    if(self.touchDeleteEventBlock){
        self.touchDeleteEventBlock(_cellIndex);
    }
}


// cell赋值
- (void)setCellWithData:(NSDictionary *)data{
    
    self.dateLB.text = [self time_timestampToString:[data[@"time"] integerValue]][0];
    self.timeLB.text = [self time_timestampToString:[data[@"time"] integerValue]][1];
    self.accountLB.text = data[@"userName"];
    
    NSString *my_userId = [NSString stringWithFormat:@"%@", [UserInfo defaultUserInfo].userID];
    if ([data[@"userName"] isEqualToString:my_userId]) {
        self.accountLB.text = [UserInfo defaultUserInfo].userName;
    }
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
