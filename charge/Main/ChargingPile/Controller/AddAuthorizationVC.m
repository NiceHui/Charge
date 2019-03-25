//
//  AddAuthorizationVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/10.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "AddAuthorizationVC.h"
#import "RegistrationUserVC.h"
#import "DeviceManager.h"

@interface AddAuthorizationVC ()

@property (nonatomic, strong)UITextField *authorNameTF;

@property (nonatomic, strong)UITextField *passWordTF;

@end

@implementation AddAuthorizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    
    self.title = HEM_tianjiashouquan;
    
    UIButton *rightBarbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [rightBarbtn setTitle:HEM_zhucexinyonghu forState:UIControlStateNormal];
    [rightBarbtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
    rightBarbtn.titleLabel.font = FontSize(17);
    rightBarbtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBarbtn addTarget:self action:@selector(RegistrationUserAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc]initWithCustomView:rightBarbtn];
    self.navigationItem.rightBarButtonItem = rightbarButton;
}


- (void)setupSubview{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*XLscaleH, ScreenWidth, 40*XLscaleH)];
    titleLabel.text = HEM_tianjiashouquanyonghu;
    titleLabel.font = FontSize(17*XLscaleW);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = colorblack_51;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35*XLscaleW, 12*XLscaleH)];
    leftView.image = IMAGE(@"nameLogin");
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.backgroundColor = COLOR(242, 242, 242, 1);
    
    UITextField *authorNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 150*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    authorNameTF.attributedPlaceholder = [NSAttributedString.alloc initWithString:root_Alet_user_messge attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:FontSize(14*XLscaleH)}];
    authorNameTF.font = FontSize(14*XLscaleH);
    authorNameTF.leftViewMode = UITextFieldViewModeAlways;
    authorNameTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:authorNameTF];
    self.authorNameTF = authorNameTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(authorNameTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    UIImageView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33*XLscaleW, 12*XLscaleH)];
    leftView2.image = IMAGE(@"passwordLogin");
    leftView2.contentMode = UIViewContentModeScaleAspectFit;
    leftView2.backgroundColor = COLOR(242, 242, 242, 1);
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*XLscaleW, 250*XLscaleH, ScreenWidth-80*XLscaleW, 50*XLscaleH)];
    [enterBtn setTitle:root_finish forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = FontSize(18*XLscaleH);
    [enterBtn setBackgroundColor:mainColor];
    XLViewBorderRadius(enterBtn, 25*XLscaleH, 0, kClearColor);
    [enterBtn addTarget:self action:@selector(addNewAuthor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}

#pragma mark -- 注册新用户
- (void)RegistrationUserAction{
    RegistrationUserVC *registVC = [[RegistrationUserVC alloc]init];
    registVC.sn = self.sn;
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark -- Http request
// 添加新授权用户
- (void)addNewAuthor{
    if (self.authorNameTF.text.length == 0) {
        [self showToastViewWithTitle:root_WO_buneng_weikong];
        return;
    }
    
    [self showProgressView];
    __weak typeof(self) weakSelf = self;
    [[DeviceManager shareInstenced] GetUserIdWithUserAccount:self.authorNameTF.text success:^(id data) {
       
        if ([data[@"result"] isEqualToNumber:@1]) {
            [[DeviceManager shareInstenced] AddAuthorChargingPileWithUserId:weakSelf.authorNameTF.text ownerId:[UserInfo defaultUserInfo].userName sn:self.sn userName:weakSelf.authorNameTF.text success:^(id obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideProgressView];
                    [weakSelf showToastViewWithTitle:obj[@"data"]];
                    if ([obj[@"code"] isEqualToNumber:@0]) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
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
