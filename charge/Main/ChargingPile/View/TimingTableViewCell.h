//
//  TimingTableViewCell.h
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeTimingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimingTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *openTitleLabel;
@property (strong, nonatomic) UILabel *closeTitleLabel;

@property (strong, nonatomic) UILabel *startTimeLabel;
@property (strong, nonatomic) UILabel *endTimeLabel;
@property (strong, nonatomic) UILabel *lengthTImeLabel;

@property (strong, nonatomic) UILabel *loopTitleLabel;
@property (strong, nonatomic) UIButton *loopButton;

@property (strong, nonatomic) UISwitch *controlSwitch;

@property (nonatomic, copy) void (^touchOpenOrCloseTiming)(BOOL isOpen, BOOL loopType, NSString *type);

// cell赋值
- (void)setCellDataWithModel:(ChargeTimingModel *)model;

@end

NS_ASSUME_NONNULL_END
