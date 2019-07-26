//
//  SetTimeRateAlert.h
//  charge
//
//  Created by growatt007 on 2019/6/18.
//  Copyright © 2019 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SetTimeRateDelegate <NSObject>

- (void)SetTimeRateWithPrams:(NSDictionary *)prams;

@end

@interface SetTimeRateAlert : UIView

@property (nonatomic, strong) NSArray *timeRateArray;

@property (nonatomic, assign) NSInteger timeRateNum;

@property (nonatomic, weak) id<SetTimeRateDelegate> delegate;

@property (nonatomic, copy) void (^touchAlertEnter)(NSString *text);

@property (nonatomic, copy) void (^touchAlertCancel)(void);

/**
 弹出
 */
- (void)show;

/**
 关闭
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
