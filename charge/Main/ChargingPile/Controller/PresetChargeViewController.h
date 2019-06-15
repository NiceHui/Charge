//
//  PresetChargeViewController.h
//  charge
//
//  Created by growatt007 on 2018/10/17.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PresetChargeViewController : BaseViewController

@property (nonatomic, strong) NSString *programme;

@property (nonatomic, copy) void(^returnPresetValueAndprogramme)(NSString *value, NSString *vluae2 ,NSString*programme ,NSString*unit);
@end

NS_ASSUME_NONNULL_END
