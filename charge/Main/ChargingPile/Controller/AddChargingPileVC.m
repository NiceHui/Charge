//
//  AddChargingPileVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/9.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "AddChargingPileVC.h"
#import "DeviceManager.h"
#import "MMScanViewController.h"
#import "InputSettingAlert.h"

@interface AddChargingPileVC ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *chargingplieIdTF; // 充电桩ID

@property (nonatomic, strong) InputSettingAlert *inputAlert;

@end

@implementation AddChargingPileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_tianjiachongdianzhuang;
    
    [self setupSubview];
    
}


- (void)setupSubview{
    
    NSNumber *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
    NSString *userName = [UserInfo defaultUserInfo].userName;
    if([userName isEqualToString:@"ceshi00701"] && [auth isEqualToNumber:@1]){
        
        self.inputAlert = [[InputSettingAlert alloc]init];
        self.inputAlert.titleText = root_yanzheng_demo;
        self.inputAlert.PlaceholderText = root_Alet_user_pwd;
        [self.inputAlert show];
        
        __weak typeof(self) weakSelf = self;
        self.inputAlert.touchAlertCancel = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        self.inputAlert.touchAlertEnter = ^(NSString * _Nonnull text) {
            [weakSelf chectCode:text];
        };
    }
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*XLscaleH, ScreenWidth, 25*XLscaleH)];
    titleLabel.text = HEM_tianjianchongdianzhuang_tips;
    titleLabel.font = FontSize(20*XLscaleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorblack_222;
    [self.view addSubview:titleLabel];

    UITextField *chargingplieIdTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 150*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    chargingplieIdTF.attributedPlaceholder = [NSAttributedString.alloc initWithString:HEM_qingshuruchongdianzhuangID attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:FontSize(14*XLscaleH)}];
    chargingplieIdTF.font = FontSize(14*XLscaleH);
    chargingplieIdTF.leftViewMode = UITextFieldViewModeAlways;
    chargingplieIdTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:chargingplieIdTF];
    self.chargingplieIdTF = chargingplieIdTF;

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(chargingplieIdTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];

    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*XLscaleW, 250*XLscaleH, ScreenWidth-80*XLscaleW, 50*XLscaleH)];
    [enterBtn setTitle:root_quereng forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn setBackgroundColor:mainColor];
    XLViewBorderRadius(enterBtn, 25, 0, kClearColor);
    [self.view addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(touchAddChargeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ScanBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*XLscaleW, 400*XLscaleH, ScreenWidth-30*XLscaleW, 50*XLscaleH)];
    [ScanBtn setImage:IMAGE(@"cord") forState:UIControlStateNormal];
    [ScanBtn setTitle:HEM_saomatianjia forState:UIControlStateNormal];
    [ScanBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [ScanBtn setImageEdgeInsets:UIEdgeInsetsMake(12*XLscaleH, 0, 12*XLscaleH, 10*XLscaleW)];
    ScanBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    ScanBtn.titleLabel.font = FontSize(15*XLscaleH);
    [ScanBtn setBackgroundColor:[UIColor whiteColor]];
    [ScanBtn addTarget:self action:@selector(ScanAddAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ScanBtn];
    
}

// 点击添加
- (void)touchAddChargeAction{
    
    [self AddChargingPile:self.chargingplieIdTF.text];
}

// 添加充电桩
- (void)AddChargingPile:(NSString *)sn{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] AddChargingPileWithUserId:[UserInfo defaultUserInfo].userName sn:sn success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [self showToastViewWithTitle:root_ME_tianjia_chenggong];
            }else{
                [self showToastViewWithTitle:obj[@"data"]];
            }
            [weakSelf hideProgressView];
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}


//扫码添加
- (void)ScanAddAction{
    
    MMScanViewController *vc = [[MMScanViewController alloc]initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
        
        NSLog(@"扫码结果:%@", result);
        self.chargingplieIdTF.text = result;
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 刷新首页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_CHARGE" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_CONNECTOR_NUM" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



// 验证
- (void)chectCode:(NSString *)text{
    
    NSDictionary *parms = @{@"code":text,
                            @"userId":[UserInfo defaultUserInfo].userName};
    
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [BaseRequest myJsonPost:@"/ocpp/user/checkCode" parameters:parms Method:@"http://chat.growatt.com" success:^(id responseObject) {
        [self hideProgressView];
        if (responseObject) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/user/checkCode:%@",formal_Method ,jsonObj);
            
            if([jsonObj[@"code"] isEqualToNumber:@0]){
                [weakSelf.inputAlert hide];
                [weakSelf showToastViewWithTitle:root_yanzheng_chenggong];
            }else{
                [weakSelf showToastViewWithTitle:root_yanzheng_shibai];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputAlert show];
                });
            }
            
        }
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [weakSelf showToastViewWithTitle:root_Networking];
        [weakSelf.inputAlert show];
    }];
    
}



@end
