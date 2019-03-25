//
//  EWOptionCell.h
//  EasyWork
//
//  Created by Ryan on 16/7/28.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWOptionItem.h"
#import "EWOptionSwitchItem.h"
#import "EWOptionArrowItem.h"


@interface EWOptionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) EWOptionItem *item;

@property(nonatomic, strong, readonly) UISwitch *st;

@property(nonatomic, assign) BOOL hideSeparatorLine;

@property(nonatomic, assign) CGFloat iconLeftPadding;

@property(nonatomic, strong, readonly) UILabel *detailTitleLabel;

@property(nonatomic, strong, readonly) UILabel *titleLabel;

@property(nonatomic, strong, readonly) UIImageView *leftIconImageView;

@end
