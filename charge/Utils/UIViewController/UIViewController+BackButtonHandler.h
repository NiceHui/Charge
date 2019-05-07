//
//  RootViewController+BackButtonHandler.h
//  ShinePhone
//
//  Created by growatt007 on 2018/10/8.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
- (BOOL)navigationShouldPopOnBackButton;

@end


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
