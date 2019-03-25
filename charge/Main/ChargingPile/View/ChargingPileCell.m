//
//  ChargingPileCell.m
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "ChargingPileCell.h"

@implementation ChargingPileCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ChargingPileCellID";
    ChargingPileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell.backgroundColor = kClearColor;
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, 110*XLscaleH)];
        cellView.backgroundColor = [UIColor redColor];
        
        XLViewBorderRadius(cellView, 5, 0, kClearColor);
        [cell.contentView addSubview:cellView];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, 110*XLscaleH)];
        cellView.backgroundColor = [UIColor whiteColor];
        
        XLViewBorderRadius(cellView, 5, 0, kClearColor);
        //添加到cell
        [self addSubview:cellView];
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, 100*XLscaleW, 17*XLscaleH)];
        nameLB.font = [UIFont systemFontOfSize:18*XLscaleW];
        nameLB.textColor = colorblack_51;
        nameLB.text = HEM_chongdianzhuang;
        [cellView addSubview:nameLB];
        self.nameLB = nameLB;
        
        UIImageView *IDImgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(nameLB.frame)+19*XLscaleH, 15*XLscaleW, 15*XLscaleW)];
        IDImgView.image = IMAGE(@"charger_chongdianzhuangliebiao");
        [cellView addSubview:IDImgView];
        
        UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(IDImgView.frame)+9, IDImgView.xmg_y, 150*XLscaleW, 14*XLscaleH)];
        IDLabel.font = [UIFont systemFontOfSize:15*XLscaleW];
        IDLabel.textColor = COLOR(116, 116, 116, 1);
        IDLabel.text = [NSString stringWithFormat:@"%@：69782BD",HEM_charge_id];
        self.IDLabel = IDLabel;
        [cellView addSubview:IDLabel];
        
        UIImageView *powerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(IDImgView.xmg_x, CGRectGetMaxY(IDImgView.frame)+15*XLscaleH, 15*XLscaleW, 15*XLscaleW)];
        powerImgView.image = IMAGE(@"power_chongdianzhuangliebiao");
        [cellView addSubview:powerImgView];
        
//        UILabel *powerLB = [[UILabel alloc] initWithFrame:CGRectMake(IDLabel.xmg_x, powerImgView.xmg_y, 150*XLscaleW, 14*XLscaleH)];
//        powerLB.font = [UIFont systemFontOfSize:15*XLscaleW];
//        powerLB.textColor = COLOR(116, 116, 116, 1);
//        powerLB.text = [NSString stringWithFormat:@"%@：3000W",HEM_gonglv];
//        self.powerLB = powerLB;
//        [cellView addSubview:powerLB];
        
        UIImageView *arrowsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellView.xmg_width-18-7*XLscaleW, cellView.xmg_height/2-8*XLscaleW, 7*XLscaleW, 16*XLscaleW)];
        arrowsImgView.image = IMAGE(@"more_chongdianzhuangliebiao");
        [cellView addSubview:arrowsImgView];
        
    }
    return self;
}
@end
