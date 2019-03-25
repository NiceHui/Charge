//
//  ChargingPileCell.h
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargingPileCell : UITableViewCell
/**充电桩名称*/
@property (nonatomic, strong) UILabel *nameLB;
/**充电桩ID*/
@property (nonatomic, strong) UILabel *IDLabel;
/**功率*/
@property (nonatomic, strong) UILabel *powerLB;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
