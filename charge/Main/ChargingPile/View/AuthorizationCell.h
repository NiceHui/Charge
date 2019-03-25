//
//  AuthorizationCell.h
//  ShinePhone
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationCell : UITableViewCell
@property (nonatomic, strong) UILabel *dateLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *accountLB;
@property (nonatomic, strong) UILabel *passwordLB;
@property (nonatomic, strong) UIButton *textCopyBtn;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, copy) void (^touchCopyTextBlock)(NSString *text);

@property (nonatomic, copy) void (^touchDeleteEventBlock)(NSInteger index);

// cell赋值
- (void)setCellWithData:(NSDictionary *)data;

@end
