//
//  setTimingViewController.h
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BaseViewController.h"
#import "ChargeTimingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface setTimingViewController : BaseViewController

@property (nonatomic, strong) NSString *reservationId;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSNumber *connectorId;
@property (nonatomic, strong) ChargeTimingModel *model;
@end

NS_ASSUME_NONNULL_END
