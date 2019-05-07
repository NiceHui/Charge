//
//  HSUIMarco.h
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#ifndef HSUIMarco_h
#define HSUIMarco_h



#define HEAD_URL_Demo  @"http://server-api.growatt.com"
#define HEAD_URL_Demo_CN  @"http://server-cn-api.growatt.com"
#define HEAD_URL  [UserInfo defaultUserInfo].server
#define OSS_HEAD_URL_Demo  @"http://oss1.growatt.com"
#define OSS_HEAD_URL  [UserInfo defaultUserInfo].OSSserver
#define OSS_HEAD_URL_Demo_2  @"http://oss.growatt.com"

#define worldServerUrl  @"http://server.growatt.com"
#define chinaServerUrl  @"http://server-cn.growatt.com"

//#define formal_Method @"http://chat.growatt.com" // 能源管理正式服务器
//#define Demo_Method @"http://192.168.30.69:8080" // 能源管理测试服务器
//#define formal_Method @"http://192.168.3.228" // 能源管理测试服务器
#define formal_Method @"http://charge.growatt.com" // 能源管理测试服务器(欧服)

//判断iPhoneX序列（iPhoneX，iPhoneXs，iPhoneXs Max）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXs_Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneX系列
#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define kNavBarHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define kBottomBarHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34.0 : 0)
#define kContentHeight (kScreenHeight - kNavBarHeight-kBottomBarHeight)


#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define XLscaleH ScreenHeight/667
#define XLscaleW ScreenWidth/375

//设置 view 圆角和边框
#define XLViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#define IMAGE(_NAME) [UIImage imageNamed:_NAME]// 图片

#define COLOR(_R,_G,_B,_A) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]// 颜色
// 白底
#define colorblack_51  COLOR(51, 51, 51, 1) // 所有标题性字体颜色
#define colorblack_102 COLOR(102, 102, 102, 1) // 所有内容字体颜色
#define colorblack_154 COLOR(154, 154, 154, 1) // 所有附加注释，时间提示字体颜色
#define colorblack_186 COLOR(186, 186, 186, 1) // 所有搜索框内提示字体颜色
#define colorblack_222 COLOR(222, 222, 222, 1) // 所有分割线的颜色
// 非白底
#define colorwhite_100  COLOR(242, 242, 242, 1) // 所有标题性字体颜色
#define colorwhite_80 COLOR(242, 242, 242, 0.8) // 所有内容字体颜色
#define colorwhite_60 COLOR(242, 242, 242, 0.6) // 所有附加注释，时间提示字体颜色
#define colorwhite_30 COLOR(242, 242, 242, 0.3) // 所有搜索框内提示字体颜色

#define mainColor COLOR(0, 227, 191, 1)
#define kClearColor [UIColor clearColor]

#define FontSize(size) [UIFont systemFontOfSize:(size)]// 字号
#define KEYWINDOW [UIApplication sharedApplication].keyWindow// keyWindow层
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO ) //字符串判空
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0     \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* HSUIMarco_h */
