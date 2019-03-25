//
//  changManeger.m
//  shinelink
//
//  Created by sky on 16/4/21.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "changManeger.h"
#import "LoginViewController.h"

@interface changManeger ()
@property (nonatomic, strong)UITextField *textField0;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UITextField *textField1;
@property (nonatomic, strong)UITextField *textField2;
@property (nonatomic, strong)UITextField *textField3;
@property (nonatomic, strong)UITextField *textField4;
@property (nonatomic, strong) NSString *param1;
@property (nonatomic, strong) NSString *param2;
@property (nonatomic, strong) NSString *param3;
@property (nonatomic, strong) NSString *param1Name;
@property (nonatomic, strong) NSString *param2Name;
@property (nonatomic, strong) NSString *param3Name;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *address;
@end

@implementation changManeger

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];
    
}

-(void)initUI{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

    float Size1=40*XLscaleH;
    
      if([_type isEqualToString:@"0"]){
          
          UILabel *PV0=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,75*XLscaleH+10*XLscaleH-Size1, 140*XLscaleW,30*XLscaleH )];
          PV0.text=root_old_pwd;
          PV0.textAlignment=NSTextAlignmentRight;
          PV0.textColor=colorblack_51;
          PV0.font = [UIFont systemFontOfSize:16*XLscaleH];
          PV0.adjustsFontSizeToFitWidth=YES;
          [self.view addSubview:PV0];
          
          _textField0 = [[UITextField alloc] initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleH+10*XLscaleH-Size1, 150*XLscaleW,30*XLscaleH )];
          _textField0.layer.borderWidth=1;
          _textField0.textAlignment=NSTextAlignmentLeft;
          _textField0.layer.cornerRadius=5;
          _textField0.layer.borderColor=colorblack_222.CGColor;
          _textField0.textColor = colorblack_51;
          _textField0.tintColor = colorblack_51;
          _textField0.font = [UIFont systemFontOfSize:16*XLscaleH];
          //_textField.delegate=self;
          [self.view addSubview:_textField0];
          
          
            UILabel *PV1=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,75*XLscaleH+10*XLscaleH, 140*XLscaleW,30*XLscaleH )];
            PV1.text=root_Alet_user_pwd;
            PV1.textAlignment=NSTextAlignmentRight;
            PV1.textColor=colorblack_51;
            PV1.font = [UIFont systemFontOfSize:16*XLscaleH];
                  PV1.adjustsFontSizeToFitWidth=YES;
            [self.view addSubview:PV1];

            _textField = [[UITextField alloc] initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleH+10*XLscaleH, 150*XLscaleW,30*XLscaleH )];
            _textField.layer.borderWidth=1;
            _textField.textAlignment=NSTextAlignmentLeft;
            _textField.layer.cornerRadius=5;
            _textField.layer.borderColor=colorblack_222.CGColor;
            _textField.textColor = colorblack_51;
            _textField.tintColor = colorblack_51;
            _textField.font = [UIFont systemFontOfSize:16*XLscaleH];
            //_textField.delegate=self;
            [self.view addSubview:_textField];
          
          UILabel *PV2=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,75*XLscaleH+10*XLscaleH+Size1, 140*XLscaleW,30*XLscaleH )];
          PV2.text=root_chongFu_miMa;
          PV2.textAlignment=NSTextAlignmentRight;
          PV2.textColor=colorblack_51;
          PV2.font = [UIFont systemFontOfSize:16*XLscaleH];
          PV2.adjustsFontSizeToFitWidth=YES;
          [self.view addSubview:PV2];

          
          _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleH+10*XLscaleH+Size1, 150*XLscaleW,30*XLscaleH )];
          _textField1.layer.borderWidth=1;
          _textField1.layer.cornerRadius=5;
          _textField1.layer.borderColor=colorblack_222.CGColor;
          _textField1.textAlignment=NSTextAlignmentLeft;
          _textField1.textColor = colorblack_51;
          _textField1.tintColor = colorblack_51;
          _textField1.font = [UIFont systemFontOfSize:16*XLscaleH];
          //_textField.delegate=self;
          [self.view addSubview:_textField1];
          
      }

    if([_type isEqualToString:@"1"]){
        UILabel *PV2=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,75*XLscaleH+10*XLscaleH+Size1, 140*XLscaleW,30*XLscaleH )];
        PV2.text=root_DianHua;
        PV2.textAlignment=NSTextAlignmentCenter;
        PV2.textColor=colorblack_51;
        PV2.font = [UIFont systemFontOfSize:16*XLscaleH];
         PV2.adjustsFontSizeToFitWidth=YES;
        [self.view addSubview:PV2];
        
//        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleW+30*XLscaleW+Size1, 150*XLscaleW,1*XLscaleW )];
//        line4.backgroundColor=[UIColor whiteColor];
//        [self.view addSubview:line4];
        
        _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleH+10*XLscaleH+Size1,150*XLscaleW,30*XLscaleH )];
        _textField2.layer.borderWidth=1;
        _textField2.layer.cornerRadius=5;
        _textField2.textAlignment=NSTextAlignmentLeft;
        _textField2.layer.borderColor=colorblack_222.CGColor;
        _textField2.textColor = colorblack_51;
        _textField2.tintColor = colorblack_51;
        _textField2.font = [UIFont systemFontOfSize:16*XLscaleH];
        //_textField.delegate=self;
        [self.view addSubview:_textField2];
        
        UILabel *alertLable= [[UILabel alloc] initWithFrame:CGRectMake(10*XLscaleW,75*XLscaleH+48*XLscaleH+Size1,300*XLscaleW, 15*XLscaleH)];
        NSString *alertText1=root_budai_guojiahao;
        NSString *alertText=[NSString stringWithFormat:@"(%@)",alertText1];
        alertLable.text=alertText;
        alertLable.textColor=COLOR(255, 255, 255, 0.5);
        alertLable.font = [UIFont systemFontOfSize:10*XLscaleH];
        alertLable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:alertLable];
        
        
    }
    
    if([_type isEqualToString:@"2"]){
        UILabel *PV2=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,25*XLscaleH+10*XLscaleH+Size1, 300*XLscaleW,30*XLscaleH )];
        PV2.text=root_WO_shuru_youxiang;
        PV2.textAlignment=NSTextAlignmentCenter;
        PV2.textColor=colorblack_51;
        PV2.font = [UIFont systemFontOfSize:16*XLscaleH];
        [self.view addSubview:PV2];
        
//        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleW+30*XLscaleW+Size1, 150*XLscaleW,1*XLscaleW )];
//        line4.backgroundColor=[UIColor whiteColor];
//        [self.view addSubview:line4];
        
        _textField3 = [[UITextField alloc] initWithFrame:CGRectMake(70*XLscaleW,75*XLscaleH+10*XLscaleH+Size1, 180*XLscaleW,30*XLscaleH )];
        _textField3.layer.borderWidth=1;
        _textField3.layer.cornerRadius=5;
        _textField3.textAlignment=NSTextAlignmentCenter;
        _textField3.layer.borderColor=colorblack_222.CGColor;
        _textField3.textColor = colorblack_51;
        _textField3.tintColor = colorblack_51;
        _textField3.font = [UIFont systemFontOfSize:16*XLscaleH];
        //_textField.delegate=self;
        [self.view addSubview:_textField3];
    }
    
    if([_type isEqualToString:@"3"]){
        UILabel *PV2=[[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW,25*XLscaleH+10*XLscaleH+Size1, 300*XLscaleW,30*XLscaleH )];
        PV2.text=root_WO_shuru_dailishang;
        PV2.textAlignment=NSTextAlignmentCenter;
        PV2.textColor=colorblack_51;
        PV2.font = [UIFont systemFontOfSize:16*XLscaleH];
        [self.view addSubview:PV2];
        
//        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(160*XLscaleW,75*XLscaleW+30*XLscaleW+Size1, 150*XLscaleW,1*XLscaleW )];
//        line4.backgroundColor=[UIColor whiteColor];
//        [self.view addSubview:line4];
        
        _textField4 = [[UITextField alloc] initWithFrame:CGRectMake(70*XLscaleW,75*XLscaleH+10*XLscaleH+Size1, 180*XLscaleW,30*XLscaleH )];
        _textField4.layer.borderWidth=1;
        _textField4.layer.cornerRadius=5;
         _textField4.textAlignment=NSTextAlignmentLeft;
        _textField4.layer.borderColor=colorblack_222.CGColor;
        _textField4.textColor = colorblack_51;
        _textField4.tintColor = colorblack_51;
        _textField4.font = [UIFont systemFontOfSize:16*XLscaleH];
        //_textField.delegate=self;
        [self.view addSubview:_textField4];
    }
    
    UIButton *goBut =  [UIButton buttonWithType:UIButtonTypeCustom];
    goBut.frame=CGRectMake(ScreenWidth/2-100*XLscaleW,210*XLscaleH, 200*XLscaleW, 40*XLscaleH);
    goBut.titleLabel.font=[UIFont systemFontOfSize: 16*XLscaleH];
    XLViewBorderRadius(goBut, 20*XLscaleH, 0, kClearColor);
    [goBut setTitle:root_OK forState:UIControlStateNormal];
    goBut.backgroundColor = mainColor;
    [goBut addTarget:self action:@selector(finishSet1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBut];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField0 resignFirstResponder];
}

-(void)finishSet1{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDemo"] isEqualToString:@"isDemo"]) {
        
        [self showAlertViewWithTitle:@"" message:@"浏览用户禁止操作" cancelButtonTitle:root_Yes];
        return;
    }

    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *pass=[ud objectForKey:@"userName"];
    _accountName=[NSString stringWithString:pass];
    NSMutableDictionary *dataAll=[NSMutableDictionary new];
    
    
    if (_textField) {
        if ([_textField1.text isEqualToString:@""] || (_textField1.text==nil)) {
            [self showToastViewWithTitle:root_Alet_user_pwd];
               return;
        }
        
        if (![[_textField text]isEqualToString:[_textField1 text]])
        {
            [self showToastViewWithTitle:root_xiangTong_miMa];
            return;
        }else{
        _address=@"/newUserAPI.do?op=updateUserPassword";
        _param1Name=@"passwordOld";
            _param1=[_textField0 text];
            _param2Name=@"passwordNew";
            _param2=[_textField1 text];
        }
         [dataAll setObject:_accountName forKey:@"accountName"];
          [dataAll setObject:_param1 forKey:@"passwordOld"];
          [dataAll setObject:_param2 forKey:@"passwordNew"];
    }
    
    if (_textField2 || _textField3||_textField4) {
        _address=@"/newUserAPI.do?op=updateUser";
        _param1Name=@"PhoneNum";
         _param2Name=@"email";
        _param3Name=@"agentCode";
        if (_textField2) {
            _param1=[_textField2 text];
            _param2=@"";
            _param3=@"";
        }
        if (_textField3) {
            _param1=@"";
              _param3=@"";
            _param2=[_textField3 text];
        }
        if (_textField4) {
            _param1=@"";
             _param2=@"";
            _param3=[_textField4 text];
        }
        
        [dataAll setObject:_accountName forKey:@"accountName"];
        [dataAll setObject:_param1 forKey:@"phoneNum"];
        [dataAll setObject:_param2 forKey:@"email"];
        [dataAll setObject:_param3 forKey:@"agentCode"];
        
    }
    [self showProgressView];
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:dataAll paramarsSite:_address sucessBlock:^(id content) {
        //NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
        id  content1= [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"UserSet: %@", content1);
        [self hideProgressView];
        
        if (content1) {
            if ([content1[@"success"] integerValue] == 0) {
                if ([content1[@"msg"] integerValue] ==501) {
                    [self showAlertViewWithTitle:nil message:root_xitong_cuoWu cancelButtonTitle:root_Yes];
                    
                }else if ([content1[@"msg"] integerValue] ==502) {
                    if (_textField) {
                         [self showAlertViewWithTitle:nil message:root_yuan_mima_cuowu cancelButtonTitle:root_Yes];
                    }else{
                    [self showAlertViewWithTitle:nil message:root_WO_yonghu_bucunzai cancelButtonTitle:root_Yes];
                    }
                    
                    
                }else if ([content1[@"msg"] integerValue] ==701) {
                    [self showAlertViewWithTitle:nil message:root_zhanghu_meiyou_quanxian cancelButtonTitle:root_Yes];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showAlertViewWithTitle:nil message:root_CNJ_canshu_chenggong cancelButtonTitle:root_Yes];
                
                if([_type isEqualToString:@"0"]){
                
                    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                    NSString *reUsername=[ud objectForKey:@"userName"];
                    
                    [[UserInfo defaultUserInfo] setUserPassword:nil];
                    
                    LoginViewController *login =[[LoginViewController alloc]init];
                    login.oldName=reUsername;
                    
                    [login.navigationController setNavigationBarHidden:YES];
                    [self.navigationController pushViewController:login animated:YES];
                }else{
                    if([_type isEqualToString:@"1"]){
                      [[UserInfo defaultUserInfo] setTelNumber:_param1];
                    }else if ([_type isEqualToString:@"2"]){            
                           [[UserInfo defaultUserInfo] setEmail:_param2];
                    }else if ([_type isEqualToString:@"3"]){
                            [[UserInfo defaultUserInfo] setAgentCode:_param3];
                    }
                [self.navigationController popViewControllerAnimated:YES];
                    
                }
           
            }
        }
    } failure:^(NSError *error) {
         [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
    
}


@end
