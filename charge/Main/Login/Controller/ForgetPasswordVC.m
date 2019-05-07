//
//  ForgetPasswordVC.m
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ForgetPasswordVC.h"

@interface ForgetPasswordVC ()

@property (nonatomic, strong) UITextField *userNameTF;

@property(nonatomic,strong)NSString *serverAddress;

@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_forget_pwd;
    
    [self setupUIView];
    
}


- (void)setupUIView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*XLscaleH, ScreenWidth, 50*XLscaleW)];
    titleLabel.text = root_forget_tips;
    titleLabel.font = FontSize(17*XLscaleW);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorblack_154;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleH, 16*XLscaleW)];
    leftView.image = IMAGE(@"sign_user.png");
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITextField *userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 150*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:HEM_qingshuruyonghumingchepaidianhuayouxiang attributes:@{NSFontAttributeName:FontSize(14*XLscaleH)}];
    userNameTF.attributedPlaceholder = placeholder;
    userNameTF.font = FontSize(14*XLscaleH);
    userNameTF.leftView = leftView;
    userNameTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:userNameTF];
    self.userNameTF = userNameTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(userNameTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 2)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(50*XLscaleW, 250*XLscaleH, ScreenWidth-100*XLscaleW, 45*XLscaleH)];
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
    [enterBtn setTitle:root_quereng forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = FontSize(18*XLscaleH);
    XLViewBorderRadius(enterBtn, 22*XLscaleH, 0, kClearColor);
    [enterBtn addTarget:self action:@selector(RetrieveThePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}


// 找回密码
- (void)RetrieveThePassword{
    
    if ([self.userNameTF.text isEqual:@""]) {
        [self showAlertViewWithTitle:@"" message:root_zhengQueDe_yonghuMing cancelButtonTitle:root_OK];
        return;
    }
    NSDictionary *userCheck=[NSDictionary dictionaryWithObject:self.userNameTF.text forKey:@"accountName"];
    [self showProgressView];
    
    NSMutableDictionary *getServer=[NSMutableDictionary dictionaryWithObject:self.userNameTF.text forKey:@"param"];
    [getServer setObject:@"1" forKey:@"type"];
    
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:getServer  paramarsSite:@"/newForgetAPI.do?op=getServerUrlByParam" sucessBlock:^(id content) {
        
        if (content) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"getServerUrlByParam: %@", jsonObj);
            if ([jsonObj[@"success"] integerValue] == 1) {
                
                NSString *server1=jsonObj[@"msg"];
                NSString *server2=@"http://";
                _serverAddress=[NSString stringWithFormat:@"%@%@",server2,server1];
                
                [BaseRequest requestWithMethod:_serverAddress paramars:userCheck  paramarsSite:@"/newForgetAPI.do?op=sendResetEmailByAccount" sucessBlock:^(id content) {
                    NSLog(@"sendResetEmailByAccount: %@", content);

                    [self hideProgressView];
                    if (content) {
                        if ([content[@"success"] integerValue] == 0) {
                            if ([content[@"msg"] integerValue] ==501) {
                                [self showAlertViewWithTitle:@"" message:root_youJian_shiBai cancelButtonTitle:root_Yes];
                            }
                            else if ([content[@"msg"] integerValue] ==502) {
                                [self showAlertViewWithTitle:@"" message:root_zhaoBuDao_yongHu cancelButtonTitle:root_Yes];
                            }else if ([content[@"msg"] integerValue] ==503) {
                                [self showAlertViewWithTitle:@"" message:root_server_error cancelButtonTitle:root_Yes];
                            }
                        }else{
                            NSString *email=content[@"msg"];
                            [self showAlertViewWithTitle:@"" message:email cancelButtonTitle:root_Yes];
                            
                        }
                    }
                }failure:^(NSError *error) {
                    [self hideProgressView];
                    [self showToastViewWithTitle:root_Networking];
                }];
            }
        }
    }failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


@end
