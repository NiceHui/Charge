//
//  SetTimeRateVC.h
//  charge
//
//  Created by growatt007 on 2019/6/19.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol setTimeRateDelegate <NSObject>

- (void)setTimeRateWithArray:(NSArray *)timeRateArray;

@end

@interface SetTimeRateVC : BaseViewController

@property (nonatomic, strong) NSArray *timeRateArray;

@property (nonatomic, strong) NSString *symbol;

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, weak) id<setTimeRateDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
