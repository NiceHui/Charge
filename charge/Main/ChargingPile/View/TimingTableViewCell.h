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
@property (weak, nonatomic) IBOutlet UILabel *openTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthTImeLabel;

@property (weak, nonatomic) IBOutlet UILabel *loopTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loopButton;

@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;

@property (nonatomic, copy) void (^touchOpenOrCloseTiming)(BOOL isOpen, BOOL loopType, NSString *type);

// cell赋值
- (void)setCellDataWithModel:(ChargeTimingModel *)model;

@end

NS_ASSUME_NONNULL_END
