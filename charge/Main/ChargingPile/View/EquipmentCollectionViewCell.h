//
//  EquipmentCollectionViewCell.h
//  ShinePhone
//
//  Created by growatt007 on 2018/7/2.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *string;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSString *sn;

- (void)setCellTitle:(NSString *)title withImage:(NSString *)imageStr BgColor:(UIColor *)bgColor;

@property (nonatomic, copy) void (^longTouchDeleteWithCharge)(NSString *sn);

@end
