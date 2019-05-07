//
//  SelectTimeAlert.h
//  charge
//
//  Created by growatt007 on 2019/4/10.
//  Copyright © 2019 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTimeAlert : UIView

@property (nonatomic, copy) NSString *titleText;// 标题

@property (nonatomic, copy) NSString *selectTime;// 当前值

@property (nonatomic, copy) NSString *itemText;// 设置项

@property (nonatomic, copy) NSString *PlaceholderText;// 输入提醒

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
