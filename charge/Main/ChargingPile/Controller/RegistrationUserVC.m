//
//  RegistrationUserVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/10.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "RegistrationUserVC.h"
#import "DeviceManager.h"
#import "protocol.h"
#import "SNLocationManager.h"

@interface RegistrationUserVC ()

@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *passWordTF;
@property (nonatomic, strong) UITextField *passWordTF2;
@property (nonatomic, strong) UITextField *emailTF;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) NSString *userEnable;
@property (nonatomic, strong) NSString *getCountry;
@property (nonatomic, strong) NSString *getZone;

@property (nonatomic) int getServerAddressNum;

@end

@implementation RegistrationUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_zhucexinyonghu;
    
    [self setupSubview];

    [self getInfo];
}


- (void)setupSubview{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*XLscaleH, ScreenWidth, 25*XLscaleH)];
    titleLabel.text = HEM_zhucexinyonghu_tips;
    titleLabel.font = FontSize(20*XLscaleW);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorblack_51;
    [self.view addSubview:titleLabel];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView.image = IMAGE(@"sign_user");
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 82*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:HEM_qingshuruyonghumingchepaidianhuayouxiang attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    userNameTF.attributedPlaceholder = placeholder;
    userNameTF.font = FontSize(14*XLscaleH);
    userNameTF.leftView = leftView;
    userNameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:userNameTF];
    self.userNameTF = userNameTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(userNameTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    
    
    UIImageView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView2.image = IMAGE(@"sign_password");
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 144*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    XLViewBorderRadius(passWordTF, 5, 0, kClearColor);
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:root_Alet_user_pwd attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    passWordTF.attributedPlaceholder = placeholder2;
    passWordTF.font = FontSize(14*XLscaleH);
    passWordTF.leftView = leftView2;
    passWordTF.leftViewMode = UITextFieldViewModeAlways;
    passWordTF.secureTextEntry = YES;
    [self.view addSubview:passWordTF];
    self.passWordTF = passWordTF;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(passWordTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView2.backgroundColor = colorblack_222;
    [self.view addSubview:lineView2];
    
    
    UIImageView *leftView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView3.image = IMAGE(@"sign_password");
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *passWordTF2 = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 204*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder3 = [[NSMutableAttributedString alloc]initWithString:root_xiangTong_miMa attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    passWordTF2.attributedPlaceholder = placeholder3;
    passWordTF2.font = FontSize(14*XLscaleH);
    passWordTF2.leftView = leftView3;
    passWordTF2.leftViewMode = UITextFieldViewModeAlways;
    passWordTF2.secureTextEntry = YES;
    [self.view addSubview:passWordTF2];
    [passWordTF2 addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passWordTF2 = passWordTF2;
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(passWordTF2.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView3.backgroundColor = colorblack_222;
    [self.view addSubview:lineView3];
    
    
    UIImageView *leftView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView4.image = IMAGE(@"sign_mail");
    leftView4.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *emailTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 264*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder4 = [[NSMutableAttributedString alloc]initWithString:root_dianzZiYouJian attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    emailTF.attributedPlaceholder = placeholder4;
    emailTF.font = FontSize(14*XLscaleH);
    emailTF.leftView = leftView4;
    emailTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:emailTF];
    self.emailTF = emailTF;
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(emailTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView4.backgroundColor = colorblack_222;
    [self.view addSubview:lineView4];
    
    UIButton *selectButton= [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame=CGRectMake(70*XLscaleW,328*XLscaleH, 15*XLscaleH, 15*XLscaleH);
    [selectButton setBackgroundImage:IMAGE(@"sign_xieyi") forState:UIControlStateNormal];
    [selectButton setBackgroundImage:IMAGE(@"sign_xieyi_click") forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectGo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    selectButton.selected = NO;// 默认不勾选
    _userEnable=@"no";
    
    UILabel *userOk= [[UILabel alloc] initWithFrame:CGRectMake(90*XLscaleW,324*XLscaleH, 180*XLscaleW, 20*XLscaleH)];
    userOk.text=root_tongyixieyi;
    userOk.textColor=mainColor;
    userOk.font = [UIFont systemFontOfSize:14*XLscaleH];
    userOk.adjustsFontSizeToFitWidth=YES;
    userOk.textAlignment = NSTextAlignmentCenter;
    userOk.userInteractionEnabled=YES;
    UITapGestureRecognizer * demo1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoUsert)];
    [userOk addGestureRecognizer:demo1];
    [self.view addSubview:userOk];
    
    UIView *userView= [[UIView alloc] initWithFrame:CGRectMake(100*XLscaleW,347*XLscaleH, 160*XLscaleW, 1*XLscaleH)];
    userView.backgroundColor=mainColor;
    [self.view addSubview:userView];
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*XLscaleW, 370*XLscaleH, ScreenWidth-80*XLscaleW, 50*XLscaleH)];
    [enterBtn setTitle:root_finish forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn setBackgroundColor:mainColor];
    enterBtn.titleLabel.font = FontSize(18*XLscaleH);
    XLViewBorderRadius(enterBtn, 25*XLscaleH, 0, kClearColor);
    [enterBtn addTarget:self action:@selector(RegistrationNewUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
}

// 监听输入值改变
- (void)passConTextChange:(UITextField *)textField{
    
}
// 跳转协议
-(void)GoUsert{
    protocol *go=[[protocol alloc]init];
    [self.navigationController pushViewController:go animated:YES];
}
// 勾选协议
-(void)selectGo:(UIButton*)sender{
    if (sender.selected) {
        [sender setSelected:NO];
        _userEnable=@"no";
        [sender setImage:[UIImage imageNamed:@"flow_selected_click.png"] forState:UIControlStateHighlighted];
        [sender setImage:[UIImage imageNamed:@"flow_selected_normal.png"] forState:UIControlStateNormal];
    }else{
        [sender setSelected:YES];
        _userEnable=@"ok";
        [sender setImage:[UIImage imageNamed:@"flow_selected_normal.png"] forState:UIControlStateHighlighted];
        [sender setImage:[UIImage imageNamed:@"flow_selected_click.png"] forState:UIControlStateNormal];
    }
}

//判断是否是正确的email
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark -- Http request
// 添加新授权用户
- (void)RegistrationNewUser{
    
    if (![self.passWordTF.text isEqual:self.passWordTF2.text]) {
        [self showToastViewWithTitle:root_xiangTong_miMa];
        return;
    }
    
    if (self.userNameTF.text.length<3) {
        [self showToastViewWithTitle:root_daYu_san];
        return;
    }
    
    if (self.passWordTF.text.length<6) {
        [self showToastViewWithTitle:root_daYu_liu];
        return;
    }
    
    if (![_userEnable isEqualToString:@"ok"]) {
        [self showToastViewWithTitle:root_xuanze_yonghu_xieyi];
        return;
    }
    
    if (![self isValidateEmail:self.emailTF.text]) {
        [self showToastViewWithTitle:root_shuru_zhengque_youxiang_geshi];
        return;
    }
    
    _dataDic = [[NSMutableDictionary alloc]init];
    [_dataDic setObject:self.userNameTF.text forKey:@"regUserName"];
    [_dataDic setObject:self.passWordTF.text forKey:@"regPassword"];
    [_dataDic setObject:self.emailTF.text forKey:@"regEmail"];
    
    _getServerAddressNum=0;
    
    [self registerFrist];
    
//    __weak typeof(self) weakSelf = self;
//    [self showProgressView];
//    [[DeviceManager shareInstenced] RegisterAuthorChargingPileWithSn:self.sn userName:self.userNameTF.text password:self.passWordTF.text success:^(id obj) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf hideProgressView];
//            [weakSelf showToastViewWithTitle:obj[@"data"]];
//        });
//    } failure:^(NSError *error) {
//        [weakSelf hideProgressView];
//    }];
}

// 获取服务器地址
-(void)registerFrist{
    
    _getServerAddressNum++;
    
    NSString *serverInitAddress;
    if ([self.languageType isEqualToString:@"0"]) {
        serverInitAddress=HEAD_URL_Demo_CN;
    }else{
        serverInitAddress=HEAD_URL_Demo;
    }
    
    if (_getServerAddressNum==2) {
        if ([serverInitAddress isEqualToString:HEAD_URL_Demo_CN]) {
            serverInitAddress=HEAD_URL_Demo;
        }else if ([serverInitAddress isEqualToString:HEAD_URL_Demo]){
            serverInitAddress=HEAD_URL_Demo_CN;
        }
        
    }
    
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:serverInitAddress paramars:@{@"country":_getCountry} paramarsSite:@"/newLoginAPI.do?op=getServerUrl" sucessBlock:^(id content) {
        [self hideProgressView];
        NSLog(@"getServerUrl: %@", content);
        if (content) {
            if ([content[@"success"]intValue]==1) {
                NSString *server1=content[@"server"];
                NSString *server2=@"http://";
                NSString *server=[NSString stringWithFormat:@"%@%@",server2,server1];
                [[UserInfo defaultUserInfo] setServer:server];
                
                [self PresentGo];
            }else{
                if (_getServerAddressNum==1) {
                    [self registerFrist];
                }else{
                    [self showToastViewWithTitle:root_Networking];
                }
            }
            
        }else{
            if (_getServerAddressNum==1) {
                [self registerFrist];
            }else{
                [self showToastViewWithTitle:root_Networking];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
        if (_getServerAddressNum==1) {
            [self registerFrist];
        }else{
            [self showToastViewWithTitle:root_Networking];
        }
        
    }];
    
    
}

#pragma mark - 点击注册
-(void)PresentGo{
    [self getLanguage];
    
    [_dataDic setObject:@"" forKey:@"regDataLoggerNo"];
    [_dataDic setObject:@"" forKey:@"regValidateCode"];
    [_dataDic setObject:@"" forKey:@"agentCode"];
    [_dataDic setObject:_getZone forKey:@"regTimeZone"];
    [_dataDic setObject:_getCountry forKey:@"regCountry"];
    
    NSDictionary *userCheck=[NSDictionary dictionaryWithObject:[_dataDic objectForKey:@"regUserName"] forKey:@"regUserName"];
    
    [self showProgressView];
    // 验证用户名是否存在
    [BaseRequest requestWithMethod:HEAD_URL paramars:userCheck paramarsSite:@"/newRegisterAPI.do?op=checkUserExist" sucessBlock:^(id content) {
        NSLog(@"checkUserExist: %@", content);
        [self hideProgressView];
        if (content) {
            if ([content[@"success"] integerValue] == 0) {
                [self showProgressView];
                // 注册
                [BaseRequest requestWithMethod:HEAD_URL paramars:_dataDic paramarsSite:@"/newRegisterAPI.do?op=creatAccount" sucessBlock:^(id content) {
                    NSLog(@"creatAccount: %@", content);
                    [self hideProgressView];
                    
                    if (content) {
                        if ([content[@"success"] integerValue] == 0) {

                            //注册失败
                            if ([content[@"msg"] isEqual:@"501"]) {
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_chaoChu_shuLiang cancelButtonTitle:root_Yes];
                            }else if ([content[@"msg"] isEqual:@"506"]){
                                
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_caijiqi_cuowu cancelButtonTitle:root_Yes];
                            }else if ([content[@"msg"] isEqual:@"503"]){
                                
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_yongHu_yi_shiYong cancelButtonTitle:root_Yes];
                                [self.navigationController popViewControllerAnimated:NO];
                            }else if ([content[@"msg"] isEqual:@"604"]){
                                
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_dailishang_cuowu cancelButtonTitle:root_Yes];
                                [self.navigationController popViewControllerAnimated:NO];
                            }else if ([content[@"msg"] isEqual:@"605"]){
                                
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_xuliehao_yijing_cunzai cancelButtonTitle:root_Yes];
                            }else if ([content[@"msg"] isEqual:@"606"]||[content[@"msg"] isEqual:@"607"]||[content[@"msg"] isEqual:@"608"]||[content[@"msg"] isEqual:@"609"]||[content[@"msg"] isEqual:@"602"]||[content[@"msg"] isEqual:@"502"]||[content[@"msg"] isEqual:@"603"]||[content[@"msg"] isEqual:@"701"]){
                                
                                NSString *failName=[NSString stringWithFormat:@"%@(%@)",root_zhuce_shibai,content[@"msg"]];
                                if ([[_dataDic objectForKey:@"regCountry"] isEqualToString:@"China"]) {
                                    
                                    [self showAlertViewWithTitle:failName message:root_fuwuqi_cuowu_tishi_2 cancelButtonTitle:root_Yes];
                                }else{
                                    [self showAlertViewWithTitle:failName message:root_fuwuqi_cuowu_tishi cancelButtonTitle:root_Yes];
                                }
                                
                                [BaseRequest getAppError:failName useName:[_dataDic objectForKey:@"regUserName"]];
                                
                            }else if ([content[@"msg"] isEqual:@"702"]){
                                
                                [self showAlertViewWithTitle:root_zhuce_shibai message:root_caijiqi_cuowu_tishi cancelButtonTitle:root_Yes];
                            }else{
                                
                                NSString *errorMsg=[NSString stringWithFormat:@"RegisterError%@",content[@"msg"]];
                                [BaseRequest getAppError:errorMsg useName:[_dataDic objectForKey:@"regUserName"]];
                                
                            }
                            
                        }
                        else {
                            //注册成功
                            [self showAlertViewWithTitle:@"" message:root_zhuCe_chengGong  cancelButtonTitle:root_Yes];
                            
                            [self addNewAuthor];
                        }
                    }
                    
                } failure:^(NSError *error) {
                    [self hideProgressView];
                    [self showToastViewWithTitle:root_Networking];
                }];
                
            }else{
                [self showAlertViewWithTitle:@"" message:root_yongHu_yi_shiYong cancelButtonTitle:root_Yes];
//                [self.navigationController popViewControllerAnimated:NO];
            }
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
    
    
}

// 获取国家
-(void)getInfo{
    _getCountry=@"initC";
    _getZone=@"initZ";
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode1 = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"englishCountryJson" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *countryArray1=[NSArray arrayWithArray:result[@"data"]];
    for (int i=0; i<countryArray1.count; i++) {
        if ([countryCode1 isEqualToString:countryArray1[i][@"countryCode"]]) {
            _getCountry=countryArray1[i][@"countryName"];
            _getZone=countryArray1[i][@"zone"];
        }
    }
    
    if ([_getCountry isEqualToString:@"initC"]) {
        _getCountry=@"Other";
        _getZone=@"1";
    }
    
}


-(void)getLanguage{
    //获取本地语言
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *regLanguage = [languages objectAtIndex:0];
    
    if ([regLanguage hasPrefix:@"en"]) {
        [_dataDic setObject:@"en" forKey:@"regLanguage"];
    }else if ([regLanguage hasPrefix:@"zh-Hans"]){
        [_dataDic setObject:@"zh_cn" forKey:@"regLanguage"];
    }else if ([regLanguage hasPrefix:@"fr"]){
        [_dataDic setObject:@"fr" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"ja"]){
        [_dataDic setObject:@"ja" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"it"]){
        [_dataDic setObject:@"it" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"nl"]){
        [_dataDic setObject:@"ho" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"tr"]){
        [_dataDic setObject:@"tk" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"pl"]){
        [_dataDic setObject:@"pl" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"el"]){
        [_dataDic setObject:@"gk" forKey:@"regLanguage"];
    }
    else if ([regLanguage hasPrefix:@"de"]){
        [_dataDic setObject:@"gm" forKey:@"regLanguage"];
    }else{
        [_dataDic setObject:@"en" forKey:@"regLanguage"];
    }
}

// 添加新授权用户
- (void)addNewAuthor{
    if (self.userNameTF.text.length == 0) {
        [self showToastViewWithTitle:root_WO_buneng_weikong];
        return;
    }
    
    [self showProgressView];
    __weak typeof(self) weakSelf = self;
    [[DeviceManager shareInstenced] GetUserIdWithUserAccount:self.userNameTF.text success:^(id data) {
        
        if ([data[@"result"] isEqualToNumber:@1]) {
            [[DeviceManager shareInstenced] AddAuthorChargingPileWithUserId:weakSelf.userNameTF.text ownerId:[UserInfo defaultUserInfo].userName sn:self.sn userName:weakSelf.userNameTF.text success:^(id obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideProgressView];
                    [weakSelf showToastViewWithTitle:obj[@"data"]];
                });
            } failure:^(NSError *error) {
                [weakSelf hideProgressView];
            }];
        }
        
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
    
}


@end
