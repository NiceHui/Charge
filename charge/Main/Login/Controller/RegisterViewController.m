//
//  RegisterViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseNavigationController.h"
#import "ChargingpileVC.h"
#import "protocol.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *passWordTF;
@property (nonatomic, strong) UITextField *passWordTF2;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) NSString *userEnable;
@property (nonatomic, strong) NSString *getCountry;
@property (nonatomic, strong) NSString *getZone;

@property (nonatomic) int getServerAddressNum;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_register;
    
    [self setupUIView];
    
    [self getInfo];
}

- (void)setupUIView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30*XLscaleH, ScreenWidth, 25*XLscaleH)];
    titleLabel.text = HEM_zhucexinyonghu_tips;
    titleLabel.font = FontSize(20*XLscaleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorblack_51;
    [self.view addSubview:titleLabel];
    
    
    // 用户名
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView.image = IMAGE(@"sign_user");
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *userNameTF = [self createUITextFieldWithFrame:CGRectMake(35*XLscaleW, 82*XLscaleH, ScreenWidth-45*XLscaleW, 45*XLscaleH) Placeholder:HEM_qingshuruyonghumingchepaidianhuayouxiang leftView:leftView];
    [self.view addSubview:userNameTF];
    self.userNameTF = userNameTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(userNameTF.frame)-5, ScreenWidth-60*XLscaleW, 2)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMinY(userNameTF.frame)+20*XLscaleH, 20*XLscaleW, 20*XLscaleH)];
    label1.text = @"*";
    label1.textColor = colorblack_154;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = FontSize(18*XLscaleH);
    [self.view addSubview:label1];
    
    
    // 密码
    UIImageView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleW)];
    leftView2.image = IMAGE(@"sign_password");
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *passWordTF = [self createUITextFieldWithFrame:CGRectMake(35*XLscaleW, CGRectGetMaxY(userNameTF.frame)+17*XLscaleH, ScreenWidth-45*XLscaleW, 45*XLscaleH) Placeholder:root_Alet_user_pwd leftView:leftView2];
    passWordTF.secureTextEntry = YES;
    [self.view addSubview:passWordTF];
    self.passWordTF = passWordTF;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(passWordTF.frame)-5*XLscaleH, ScreenWidth-60*XLscaleW, 2)];
    lineView2.backgroundColor = colorblack_222;
    [self.view addSubview:lineView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMinY(passWordTF.frame)+20*XLscaleH, 20*XLscaleW, 20*XLscaleH)];
    label2.text = @"*";
    label2.textColor = colorblack_154;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = FontSize(18*XLscaleH);
    [self.view addSubview:label2];
    
    
    // 重复输入密码
    UIImageView *leftView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView3.image = IMAGE(@"sign_password");
    leftView3.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *passWordTF2 = [self createUITextFieldWithFrame:CGRectMake(35*XLscaleW, CGRectGetMaxY(passWordTF.frame)+17, ScreenWidth-45*XLscaleW, 45*XLscaleH) Placeholder:root_xiangTong_miMa leftView:leftView3];
    passWordTF2.secureTextEntry = YES;
    [self.view addSubview:passWordTF2];
    self.passWordTF2 = passWordTF2;
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(passWordTF2.frame)-5, ScreenWidth-60*XLscaleW, 2)];
    lineView3.backgroundColor = colorblack_222;
    [self.view addSubview:lineView3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMinY(passWordTF2.frame)+20*XLscaleH, 20*XLscaleW, 20*XLscaleH)];
    label3.text = @"*";
    label3.textColor = colorblack_154;
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = FontSize(18*XLscaleH);
    [self.view addSubview:label3];
    
    
    // 邮箱
    UIImageView *leftView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView5.image = IMAGE(@"sign_mail");
    leftView5.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *emailTF = [self createUITextFieldWithFrame:CGRectMake(35*XLscaleW, CGRectGetMaxY(passWordTF2.frame)+17*XLscaleH, ScreenWidth-45, 45*XLscaleH) Placeholder:root_dianzZiYouJian leftView:leftView5];
    [self.view addSubview:emailTF];
    self.emailTF = emailTF;
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(emailTF.frame)-5*XLscaleH, ScreenWidth-60*XLscaleW, 2)];
    lineView5.backgroundColor = colorblack_222;
    [self.view addSubview:lineView5];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMinY(emailTF.frame)+20*XLscaleH, 20*XLscaleW, 20*XLscaleH)];
    label4.text = @"*";
    label4.textColor = colorblack_154;
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = FontSize(18*XLscaleH);
    [self.view addSubview:label4];
    
    
    // 电话
    UIImageView *leftView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView6.image = IMAGE(@"sign_phone");
    leftView6.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *phoneTF = [self createUITextFieldWithFrame:CGRectMake(35*XLscaleW, CGRectGetMaxY(emailTF.frame)+17*XLscaleH, ScreenWidth-45, 45*XLscaleH) Placeholder:root_DianHua leftView:leftView6];
    [self.view addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(phoneTF.frame)-5*XLscaleH, ScreenWidth-60*XLscaleW, 2)];
    lineView6.backgroundColor = colorblack_222;
    [self.view addSubview:lineView6];
    
    
    // 用户协议
    UILabel *userOk= [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100*XLscaleW, CGRectGetMaxY(phoneTF.frame)+15*XLscaleH, 200*XLscaleW, 20*XLscaleH)];
    userOk.text=root_tongyixieyi;
    userOk.textColor=mainColor;
    userOk.adjustsFontSizeToFitWidth=YES;
    userOk.textAlignment = NSTextAlignmentCenter;
    userOk.userInteractionEnabled=YES;
    UITapGestureRecognizer * demo1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoUsert)];
    [userOk addGestureRecognizer:demo1];
    [self.view addSubview:userOk];
    
    UIView *userView= [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(userOk.frame)-5*XLscaleW, CGRectGetMaxY(userOk.frame)-2*XLscaleH, userOk.xmg_width+10*XLscaleW, 1*XLscaleH)];
    userView.backgroundColor=mainColor;
    [self.view addSubview:userView];
    
    UIButton *selectButton= [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame=CGRectMake(CGRectGetMinX(userOk.frame)-30*XLscaleW ,CGRectGetMinY(userOk.frame)+4*XLscaleH, 15*XLscaleH, 15*XLscaleH);
    [selectButton setBackgroundImage:IMAGE(@"sign_xieyi") forState:UIControlStateNormal];
    [selectButton setBackgroundImage:IMAGE(@"sign_xieyi_click") forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectGo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    selectButton.selected = NO;// 默认不勾选
    _userEnable=@"no";
    
    // 注册按键
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(50*XLscaleW, CGRectGetMaxY(userOk.frame)+17*XLscaleH, ScreenWidth-100*XLscaleW, 45*XLscaleH)];
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 22*XLscaleH;
    gradientLayer0.frame = enterBtn.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:1.0f/255.0f green:230.0f/255.0f blue:114.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:0.0f/255.0f green:227.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [enterBtn.layer addSublayer:gradientLayer0];
    [enterBtn setTitle:root_register forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = FontSize(18*XLscaleH);
    XLViewBorderRadius(enterBtn, 22*XLscaleH, 0, kClearColor);
    [enterBtn addTarget:self action:@selector(RegistrationNewUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
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
        [sender setImage:[UIImage imageNamed:@"flow_selected_click"] forState:UIControlStateHighlighted];
        [sender setImage:[UIImage imageNamed:@"flow_selected_normal"] forState:UIControlStateNormal];
    }else{
        [sender setSelected:YES];
        _userEnable=@"ok";
        [sender setImage:[UIImage imageNamed:@"flow_selected_normal"] forState:UIControlStateHighlighted];
        [sender setImage:[UIImage imageNamed:@"flow_selected_click"] forState:UIControlStateNormal];
    }
}

// 创建
- (UITextField *)createUITextFieldWithFrame:(CGRect)rect Placeholder:(NSString *)string leftView:(UIView *)leftView{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    textField.attributedPlaceholder = placeholder;
    textField.font = FontSize(14*XLscaleH);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
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
    [_dataDic setObject:self.phoneTF.text forKey:@"regPhoneNumber"];
    
    _getServerAddressNum=0;
    
    [self registerFrist];
    
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
                            __weak typeof(self) weakSelf = self;
                            UIAlertAction *action = [UIAlertAction actionWithTitle:root_Yes style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"REGISTER_SUCCESS_LOGIN" object:@"" userInfo:@{@"userName": weakSelf.userNameTF.text, @"passWord": weakSelf.passWordTF.text}];
                            }];
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:root_zhuCe_chengGong preferredStyle:UIAlertControllerStyleAlert];
                            [alertVC addAction:action];
                            [self presentViewController:alertVC animated:YES completion:nil];
                            
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
