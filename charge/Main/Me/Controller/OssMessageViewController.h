//
//  OssMessageViewController.h
//  ShinePhone
//
//  Created by sky on 17/5/25.
//  Copyright © 2017年 sky. All rights reserved.
//

#import "BaseViewController.h"

@interface OssMessageViewController : BaseViewController
@property (nonatomic, strong)  NSString *goViewType;
@property (nonatomic, strong)  NSMutableArray *serverListArray;
@property (nonatomic, strong)  NSString *phoneNum;
@property (nonatomic, strong)  NSString *OssName;
@property (nonatomic, strong)  NSString *OssPassword;
@property (nonatomic, strong)  NSString *addQuestionType;
@property (nonatomic, strong)  NSString *firstPhoneNum;
@property (nonatomic, strong)  NSString *changeType;               //修改邮箱和电话用

@property (nonatomic, assign) BOOL isOssCheck;     //是不是OSS登录

@end
