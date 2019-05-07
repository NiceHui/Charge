//
//  LoginViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 growatt007. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "LoginButton.h"
#import "ForgetPasswordVC.h"
#import "RegisterViewController.h"
#import "ChargingpileVC.h"

@interface LoginViewController ()
{
    NSInteger getServerAddressNum;
}

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) NSString *loginUserName;
@property (nonatomic, strong) NSString *loginUserPassword;

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, strong) NSString *userNameGet;
@property (nonatomic, strong) NSString *adNumber;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_log_in;
    
    [self getLoginType];
}


- (void)setupHeadView{
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightButton setTitle:root_register forState:UIControlStateNormal];
    [rightButton setTitleColor:mainColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = FontSize(15);
    [rightButton addTarget:self action:@selector(registerNewUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    // 监听是否有注册成功的跳转事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerLogin:) name:@"REGISTER_SUCCESS_LOGIN" object:nil];
}


- (void)setupUIView{
    
    CGFloat imageW = ScreenWidth*3/5, imageH = imageW/2.5, imageX = ScreenWidth/5, imageY = 20*XLscaleH;
    UIImageView *hdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    hdImageView.image = IMAGE(@"signin");
    [self.view addSubview:hdImageView];
    
    // 用户名
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView.image = IMAGE(@"sign_user");
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMaxY(hdImageView.frame)+50*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:root_Alet_user_messge attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    userTextField.attributedPlaceholder = placeholder;
    userTextField.font = FontSize(14*XLscaleH);
    userTextField.leftView = leftView;
    userTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:userTextField];
    _userTextField = userTextField;
    if (_oldName) {
        _userTextField.text = _oldName;
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(userTextField.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 2)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    // 用户密码
    UIImageView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 16*XLscaleH)];
    leftView2.image = IMAGE(@"sign_password");
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, CGRectGetMaxY(userTextField.frame)+20*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc]initWithString:root_Alet_user_pwd attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    pwdTextField.attributedPlaceholder = placeholder2;
    pwdTextField.font = FontSize(14*XLscaleH);
    pwdTextField.leftView = leftView2;
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    pwdTextField.secureTextEntry = YES;
    [self.view addSubview:pwdTextField];
    _pwdTextField = pwdTextField;
    if (_oldPassword) {
        _pwdTextField.text = _oldPassword;
    }
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(pwdTextField.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 2)];
    lineView2.backgroundColor = colorblack_222;
    [self.view addSubview:lineView2];
    
    // 登录按键
    float view_loginBtn_Y=CGRectGetMaxY(pwdTextField.frame)+30*XLscaleH;
    float view_loginBtn_H=44*XLscaleH , view_loginBtn_W = ScreenWidth - 100*XLscaleW;
    LoginButton *loginBtn = [[LoginButton alloc] initWithFrame:CGRectMake(50*XLscaleW, view_loginBtn_Y, view_loginBtn_W, view_loginBtn_H)];
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 22*XLscaleH;
    gradientLayer0.frame = loginBtn.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:1.0f/255.0f green:230.0f/255.0f blue:114.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:0.0f/255.0f green:227.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [loginBtn.layer addSublayer:gradientLayer0];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize: 18.0f*XLscaleH];
    [loginBtn setTitle:root_log_in forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 22*XLscaleH;
    loginBtn.titleLabel.textColor=[UIColor whiteColor];
    loginBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
    [loginBtn addTarget:self action:@selector(PresentCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, CGRectGetMaxY(loginBtn.frame)+20, 200, 30)];
    [forgetButton setTitle:root_forget_pwd forState:UIControlStateNormal];
    [forgetButton setTitleColor:mainColor forState:UIControlStateNormal];
    forgetButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [forgetButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    
    // 浏览用户登录
    float testW = ScreenWidth/2, testH = 30*XLscaleH, testX = ScreenWidth/4, testY = forgetButton.xmg_y + 100*XLscaleH;
    
    UIButton *testUserButton = [[UIButton alloc]initWithFrame:CGRectMake(testX, testY, testW, testH)];
    [testUserButton setTitle:root_liulanzhanghu forState:UIControlStateNormal];
    [testUserButton setTitleColor:mainColor forState:UIControlStateNormal];
    [testUserButton setImage:[UIImage imageNamed:@"arrow2@2x"] forState:UIControlStateNormal];
    testUserButton.titleLabel.font = FontSize(18*XLscaleW);
    testUserButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [testUserButton addTarget:self action:@selector(demoTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testUserButton];
    
    CGFloat imgWidth = testUserButton.imageView.bounds.size.width;
    CGFloat labWidth = testUserButton.titleLabel.bounds.size.width;
    [testUserButton setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth, 0, -labWidth)];
    [testUserButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];
    
}

//模拟网络访问
- (void)PresentCtrl:(LoginButton *)loginBtn {
    
    typeof(self) __weak weakself = self;
    //模拟网络访问
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself loginBtnAction:loginBtn];
    });
    
}

- (void)loginBtnAction:(LoginButton *)loginBtn{

    if (_userTextField.text == nil || _userTextField.text == NULL || [_userTextField.text isEqualToString:@""]) {//判断用户名为空
        //按钮动画还原
        [loginBtn ErrorRevertAnimationCompletion:nil];
        //延迟调用弹出提示框方法
        [self performSelector:@selector(userAlertAction) withObject:nil afterDelay:1.0];
    }else if (_pwdTextField.text == nil || _pwdTextField.text == NULL || [_pwdTextField.text isEqualToString:@""]) {//判断密码为空或者不正确
        //按钮动画还原
        [loginBtn ErrorRevertAnimationCompletion:nil];
        //延迟调用弹出提示框方法
        [self performSelector:@selector(passWordAlertAction) withObject:nil afterDelay:1.0];
    }else {
        //用户名和密码输入正确跳转页面
        [loginBtn ExitAnimationCompletion:^{
            
            self.loginUserName=_userTextField.text ;
            self.loginUserPassword=_pwdTextField.text;

//            [self netRequest];
            
            getServerAddressNum=0;
            [self netServerInit];
            
        }];
    }
}

//弹出输入用户提示框方法
- (void)userAlertAction {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:root_Alet_user message:root_Alet_user_messge preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *btnAction = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCtrl addAction:btnAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
//弹出输入密码提示框方法
- (void)passWordAlertAction {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:root_Alet_user message:root_Alet_user_pwd preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btnAction = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertCtrl addAction:btnAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

// 注册新用户
- (void)registerNewUser:(UIButton *)button{
    
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 忘记密码
- (void)forgetPassword:(UIButton *)button{
    
    ForgetPasswordVC *vc = [[ForgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)getLoginType{
    
    NSString *LoginType=@"First";
    LoginType=[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *reUsername=[ud objectForKey:@"userName"];
    NSString *rePassword=[ud objectForKey:@"userPassword"];
    
    [self setupHeadView];
    [self setupUIView];
    
    getServerAddressNum=0;// 记录获取真实服务器地址次数
    
    if (reUsername==nil || reUsername==NULL||([reUsername isEqual:@""] )||rePassword==nil || rePassword==NULL||([rePassword isEqual:@""] )) { // 账号密码为空时
        
        [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo_CN];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSString *server=[ud objectForKey:@"server"];
        
        if (server==nil || server==NULL||[server isEqual:@""]) {
            [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo];
        }
        
        [[UserInfo defaultUserInfo] setCoreDataEnable:@"1"];
        
    }else{ //账号密码不为空时自动登录
        
        //服务器地址更换
        NSString*UrlString=HEAD_URL;
        if ([UrlString containsString:chinaServerUrl]) {
            [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo_CN];
        }else  if ([UrlString containsString:worldServerUrl]) {
            [[UserInfo defaultUserInfo] setServer:worldServerUrl];
        }
        
        _loginUserName=reUsername;
        _loginUserPassword=rePassword;

        [self performSelectorOnMainThread:@selector(netServerInit) withObject:nil waitUntilDone:NO];

    }

}


// 登录
-(void)netRequest{
    
//    _getNetForPlantType=1;
    NSDictionary *netDic=@{@"userName":_loginUserName, @"password":[self MD5:_loginUserPassword]};
    NSString*netUrl=@"/newLoginAPI.do";
    [self netForLoginAll:netDic netUrl:netUrl netType:1];
    
}
-(void)netForLoginAll:(NSDictionary*)netDic netUrl:(NSString*)netUrl netType:(NSInteger)netType{

    [self showProgressView];
    [BaseRequest requestWithMethod:HEAD_URL paramars:netDic paramarsSite:netUrl sucessBlock:^(id content) {
        [self hideProgressView];
        NSLog(@"%@:%@",HEAD_URL,content);
        if (content) {
            if ([content[@"success"] integerValue] == 0) {
                //登陆失败
                if (netType==2) {
                    if ([content[@"msg"] integerValue] == 501) {
                        [self showToastViewWithTitle:root_uid_weikong];
                    }else if ([content[@"msg"] integerValue] ==502) {
                        [self showToastViewWithTitle:root_WO_yonghu_bucunzai];
                    }else if ([content[@"msg"] integerValue] ==503) {
                        [self showToastViewWithTitle:root_fuWuQi_cuoWu];
                        
                    }
                }else{
                    if ([content[@"msg"] integerValue] == 501) {
                        [self showTheErrorAlert:root_yongHuMing_mima_weikong];
                    }else if ([content[@"msg"] integerValue] ==502) {
                        [self showTheErrorAlert:root_yongHuMing_mima_cuowu];
                    }else if ([content[@"msg"] integerValue] ==503) {
                        [self showTheErrorAlert:root_fuWuQi_cuoWu];
                    }
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:@"O" forKey:@"LoginType"];
                [[NSUserDefaults standardUserDefaults] setObject:self.loginUserName forKey:@"OssName"];
                [[NSUserDefaults standardUserDefaults] setObject:self.loginUserPassword forKey:@"OssPassword"];
                
            } else {
                
                self.dataSource = [NSDictionary dictionaryWithDictionary:content];
                self.userNameGet=self.dataSource[@"user"][@"accountName"];
                self.adNumber=content[@"app_code"];
                
                //登陆成功
                [[UserInfo defaultUserInfo] setUserPassword:self.loginUserPassword];
                [[UserInfo defaultUserInfo] setUserName:self.userNameGet];
                
                NSDictionary *userDic=[NSDictionary dictionaryWithDictionary:self.dataSource[@"user"]];
                if ([userDic.allKeys containsObject:@"isValiPhone"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.dataSource[@"user"][@"isValiPhone"]] forKey:@"isValiPhone"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.dataSource[@"user"][@"isValiEmail"]] forKey:@"isValiEmail"];
                }
                
                if ([self.dataSource[@"user"][@"rightlevel"] integerValue]==2) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"isDemo" forKey:@"isDemo"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"isNotDemo" forKey:@"isDemo"];
                }
                
                NSString *counrtyName=self.dataSource[@"user"][@"counrty"];
                NSString *timeZoneNum=self.dataSource[@"user"][@"timeZone"];
                [[NSUserDefaults standardUserDefaults] setObject:counrtyName forKey:@"counrtyName"];
                [[NSUserDefaults standardUserDefaults] setObject:timeZoneNum forKey:@"timeZoneNum"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"S" forKey:@"LoginType"];
                [[UserInfo defaultUserInfo] setTelNumber:self.dataSource[@"user"][@"phoneNum"]];
                [[UserInfo defaultUserInfo] setUserID:self.dataSource[@"user"][@"id"]];
                [[UserInfo defaultUserInfo] setEmail:self.dataSource[@"user"][@"email"]];
                [[UserInfo defaultUserInfo] setAgentCode:self.dataSource[@"user"][@"agentCode"]];
                
                NSString *ID=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
                NSLog(@"ID=%@",ID);
                
                NSString *serviceBool=self.dataSource[@"service"];
                if ([serviceBool isEqualToString:@"0"]||[serviceBool isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"serviceBool"];
                }else if ([serviceBool isEqualToString:@"1"]){
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"serviceBool"];
                }
                //登录成功条跳转的方法
                [self didPresentControllerButtonTouch];
                
            }
        }
        
    } failure:^(NSError *error) {

        [[NSUserDefaults standardUserDefaults] setObject:@"O" forKey:@"LoginType"];
        [[NSUserDefaults standardUserDefaults] setObject:self.loginUserName forKey:@"OssName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.loginUserPassword forKey:@"OssPassword"];
        
        [self hideProgressView];
        [self showTheErrorAlert:@"Networking Timeout"];
        
    }];
}

// 错误提示
-(void)showTheErrorAlert:(NSString*)alertString{
    
    [self showToastViewWithTitle:alertString];
}

//登录成功条跳转的方法
- (void)didPresentControllerButtonTouch {
    
    NSLog(@"登录成功");
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[ChargingpileVC new]];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

// 获取服务器
-(void)netServerInit{
    
    getServerAddressNum++;
    
    NSString *serverInitAddress;
    if ([self.languageType isEqualToString:@"0"]) {
        serverInitAddress=HEAD_URL_Demo_CN;
    }else{
        serverInitAddress=HEAD_URL_Demo;
    }
    
    if (getServerAddressNum==2) {
        if ([serverInitAddress isEqualToString:HEAD_URL_Demo_CN]) {
            serverInitAddress=HEAD_URL_Demo;
        }else if ([serverInitAddress isEqualToString:HEAD_URL_Demo]){
            serverInitAddress=HEAD_URL_Demo_CN;
        }
    }
    
    NSString *userName=_loginUserName;
    
    [self showProgressView];
    [BaseRequest requestWithMethodResponseStringResult:serverInitAddress paramars:@{@"userName":userName} paramarsSite:@"/newLoginAPI.do?op=getServerUrlByName" sucessBlock:^(id content) {
        
        id  content1= [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        [self hideProgressView];
        NSLog(@"getUserServerUrl: %@", content1);
        if (content1) {
            if ([content1[@"success"]intValue]==1) {
                NSString *server1=content1[@"msg"];
                NSString *server2=@"http://";
                NSString *server=[NSString stringWithFormat:@"%@%@",server2,server1];
                
                //服务器地址更换
                if ([server containsString:chinaServerUrl]) {
                    server=HEAD_URL_Demo_CN;
                }else  if ([server containsString:worldServerUrl]) {
                    server=HEAD_URL_Demo;
                }
                
                [[UserInfo defaultUserInfo] setServer:server];
                [self netRequest];
            }else{
                if (getServerAddressNum==1) {// 判断是否第一次请求服务器
                    [self netServerInit];
                }else{
                    if ([self.languageType isEqualToString:@"0"]) {
                        [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo_CN];
                    }else{
                        [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo];
                    }
                    [self netRequest];
                }
            }
        }else{
            
            if (getServerAddressNum==1) {
                [self netServerInit];
            }else{
                if ([self.languageType isEqualToString:@"0"]) {
                    [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo_CN];
                }else{
                    [[UserInfo defaultUserInfo] setServer:HEAD_URL_Demo];
                }
                [self netRequest];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
        if (getServerAddressNum==1) {
            [self netServerInit];
        }else{

            [self showToastViewWithTitle:root_Networking];
        }
    }];
}

// 注册后跳转登录
- (void)registerLogin:(NSNotification *)notification{
    
    [self showProgressView];
    
    NSDictionary *dict = notification.userInfo;
    
    self.userTextField.text = dict[@"userName"];
    self.pwdTextField.text = dict[@"passWord"];
    
    self.loginUserName=_userTextField.text ;
    self.loginUserPassword=self.pwdTextField.text;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        getServerAddressNum=0;
        [weakSelf netServerInit];
    });
    
}

// 获取浏览账户
- (void)demoTest{
 
    
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [BaseRequest myJsonPost:@"/ocpp/user/glanceUser" parameters:nil Method:formal_Method success:^(id responseObject) {
        [self hideProgressView];
        if (responseObject) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/user/glanceUser:%@",formal_Method ,jsonObj);
            
            if([jsonObj[@"code"] isEqualToNumber:@0]){
                
//                weakSelf.userTextField.text = jsonObj[@"data"][@"userId"];
//                weakSelf.pwdTextField.text = jsonObj[@"data"][@"password"];
                
                weakSelf.loginUserName=jsonObj[@"data"][@"userId"];
                weakSelf.loginUserPassword=jsonObj[@"data"][@"password"];
                
                getServerAddressNum=0;
                [weakSelf netServerInit];
                
                [[NSUserDefaults standardUserDefaults] setObject:jsonObj[@"data"][@"auth"] forKey:@"auth"];
            }else{
                [self showTheErrorAlert:root_login_shibai];
            }

        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
    
    
}



@end
