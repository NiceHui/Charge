//
//  InputSettingAlert.h
//  charge
//
//  Created by growatt007 on 2018/10/22.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InputSettingDelegate <NSObject>

- (void)InputSettingWithPrams:(NSDictionary *)prams;

@end

@interface InputSettingAlert : UIView

@property (nonatomic, copy) NSString *titleText;// 标题

@property (nonatomic, copy) NSString *currentText;// 当前值

@property (nonatomic, copy) NSString *itemText;// 设置项

@property (nonatomic, copy) NSString *PlaceholderText;// 输入提醒

@property (nonatomic, weak) id<InputSettingDelegate> delegate;

@property (nonatomic, copy) void (^touchAlertEnter)(NSString *text);

@property (nonatomic, copy) void (^touchAlertCancel)();


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
