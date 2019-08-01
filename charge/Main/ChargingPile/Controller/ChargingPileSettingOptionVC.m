//
//  ChargingPileSettingOptionVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/9/29.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargingPileSettingOptionVC.h"
#import "EWOptionItem.h"
#import "EWOptionArrowItem.h"
#import "ChargingpileSettingVC.h"
#import "AuthorizationVC.h"
#import "ChargingplieSettingSecondVC.h"

@interface ChargingPileSettingOptionVC ()


@end

@implementation ChargingPileSettingOptionVC


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = HEM_zhuangtishezhi;
    
    [self setUIView];
}

- (void)setUIView{
    
    EWOptionGroup *group = [[EWOptionGroup alloc]init];

    EWOptionArrowItem *InfoSettingItem = [EWOptionArrowItem arrowItemWithIcon:@"setting_canshu" title:HEM_canshu_shezhi detailTitle:@"" didClickBlock:^{
        
//        ChargingpileSettingVC *SettingVC = [[ChargingpileSettingVC alloc] init];
//        SettingVC.sn = self.sn;
//        SettingVC.title = HEM_canshu_shezhi;
//        SettingVC.priceConf = self.priceConf;
//        [self.navigationController pushViewController:SettingVC animated:YES];
        
        ChargingplieSettingSecondVC *SettingVC = [[ChargingplieSettingSecondVC alloc] init];
        SettingVC.sn = self.sn;
        SettingVC.title = HEM_canshu_shezhi;
        SettingVC.priceConf = self.priceConf;
        [self.navigationController pushViewController:SettingVC animated:YES];
    }];
    
    EWOptionArrowItem *AuthorizationItem = [EWOptionArrowItem arrowItemWithIcon:@"setting_shouquan" title:HEM_shouquanguanli detailTitle:@"" didClickBlock:^{
       
        AuthorizationVC *authVC = [[AuthorizationVC alloc] init];
        authVC.sn = self.sn;
        [self.navigationController pushViewController:authVC animated:YES];
    }];
    
    group.items = @[InfoSettingItem, AuthorizationItem];
    [self.groups addObject:group];
    [self.tableView reloadData];
}


- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_CONNECTOR_NUM" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
