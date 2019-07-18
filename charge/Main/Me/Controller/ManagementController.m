//
//  ManagementController.m
//  shinelink
//
//  Created by sky on 16/4/21.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "ManagementController.h"
#import "LoginViewController.h"
#import "changManeger.h"
//#import "phoneRegisterViewController.h"
#import "OssMessageViewController.h"


@interface ManagementController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger numberOfExecutions; // 执行次数
}
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArray1;

@end

@implementation ManagementController

-(void)viewWillAppear:(BOOL)animated{
  [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_WO_zhiliao_guanli;
    self.view.backgroundColor=colorblack_222;
 
}


-(void)initUI{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *tel=[ud objectForKey:@"TelNumber"];
    NSString *email=[ud objectForKey:@"email"];
    NSString *agent=[ud objectForKey:@"agentCode"];
    
    self.dataArray1=[NSMutableArray array];
    [self.dataArray1 addObject:@""];
    [self.dataArray1 addObject:tel];
    [self.dataArray1 addObject:email];
    [self.dataArray1 addObject:agent];
    self.dataArray =[NSMutableArray arrayWithObjects:root_WO_xiugai_mima,root_WO_xiugai_shoujihao,root_WO_xiugai_youxiang,nil];

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 15*XLscaleH, ScreenWidth, 300*XLscaleH)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor=COLOR(255, 255, 255, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor=colorblack_222;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    UIButton *LogoutUser =  [UIButton buttonWithType:UIButtonTypeCustom];
    LogoutUser.frame=CGRectMake((ScreenWidth-150*XLscaleW)/2,320*XLscaleH, 150*XLscaleW, 40*XLscaleH);
    XLViewBorderRadius(LogoutUser, 20*XLscaleH, 0, kClearColor);
    LogoutUser.backgroundColor = mainColor;
    LogoutUser.titleLabel.font=[UIFont systemFontOfSize: 16*XLscaleH];
    [LogoutUser setTitle:root_zhuxiaozhanghu forState:UIControlStateNormal];
    [LogoutUser setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    [LogoutUser addTarget:self action:@selector(LogoutUserAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:LogoutUser];

}

// 注销提示
- (void)LogoutUserAction{
    UIAlertController *removeAlert = [UIAlertController alertControllerWithTitle:root_shifouzhuxiaozhaohu message:root_zhuxiaohoubeishanchu preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LogoutUser];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
    [removeAlert addAction:enter];
    [removeAlert addAction:cancel];
    [self presentViewController:removeAlert animated:YES completion:nil];
}


// 注销账户
-(void)LogoutUser{
    
    if ([[NSString stringWithFormat:@"%@",[UserInfo defaultUserInfo].userName] isEqualToString:@"guest"]) { // 浏览账户不能注销
        [self showToastViewWithTitle:root_zhanghu_meiyou_quanxian];
        return;
    }
    
    [self showProgressView];// 调用server的接口注销用户
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"accountName":[UserInfo defaultUserInfo].userName} paramarsSite:@"/newUserAPI.do?op=cancellationUser" sucessBlock:^(id content) {
        [self hideProgressView];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"/newUserAPI.do?op=cancellationUser: %@", jsonObj);
        if (jsonObj) {
            if ([jsonObj[@"result"] intValue]==1) {
                if ((jsonObj[@"obj"]==nil)||(jsonObj[@"obj"]==NULL)||([jsonObj[@"obj"] isEqual:@""])) {
                    NSLog(@"返回值为空");
                }else{

                }
            }else{

                if ([jsonObj[@"msg"] intValue]==200) {
                    [self showToastViewWithTitle:root_zhuxiaochenggong];
                    
                    self->numberOfExecutions = 0;
                    [self unbindingEquipment]; // 通知电桩服务器
                    
                }else if ([jsonObj[@"msg"] intValue]==500) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_zhuxiaoshibai cancelButtonTitle:root_Yes];
                }else if ([jsonObj[@"msg"] intValue]==501) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_xitongcuowu cancelButtonTitle:root_Yes];
                }else if ([jsonObj[@"msg"] intValue]==502) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_yonghubucunzai cancelButtonTitle:root_Yes];
                }else if ([jsonObj[@"msg"] intValue]==503) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_cunzailiulanzhanghu cancelButtonTitle:root_Yes];
                }else if ([jsonObj[@"msg"] intValue]==504) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_adminbunengzhuxiao cancelButtonTitle:root_Yes];
                }else if ([jsonObj[@"msg"] intValue]==701) {
                    [self showAlertViewWithTitle:root_Alet_user message:root_zhanghu_meiyou_quanxian cancelButtonTitle:root_Yes];
                }
            }
        }

    } failure:^(NSError *error) {
        [self hideProgressView];
    }];
}

// 通知电桩服务器账户已被注销，执行解绑设备等操作
- (void)unbindingEquipment{
    
    numberOfExecutions ++;
    
    [self showProgressView];// 注销用户接口
    [[DeviceManager shareInstenced] sendCommandWithParms:@{@"cmd":@"deleteUser", @"userId":[UserInfo defaultUserInfo].userID} success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSString stringWithFormat:@"%@", obj[@"code"]] isEqualToString:@"0"]) {
                NSLog(@"通知成功");
                [self signOut]; // 退出
            }else{
                if (self->numberOfExecutions < 3) { // 如果失败了就继续尝试发送
                    [self unbindingEquipment];
                }else{
                    [self signOut]; // 退出
                }
            }
            [self hideProgressView];
        });
    } failure:^(NSError *error) {
        [self hideProgressView];
        if (self->numberOfExecutions < 3) {
            [self unbindingEquipment];
        }else{
            [self signOut]; // 退出
        }
    }];
    
}

// 退出登录
- (void)signOut{
    [[NSUserDefaults standardUserDefaults] setValue:@"F" forKey:@"LoginType"];
    [[UserInfo defaultUserInfo] setUserPassword:nil];
    [[UserInfo defaultUserInfo] setUserName:nil];
    [[UserInfo defaultUserInfo] setServer:nil];
    LoginViewController *login =[[LoginViewController alloc]init];
    login.oldName=nil;
    login.oldPassword=nil;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellDentifier=@"cellDentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellDentifier"];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=_dataArray[indexPath.row];
    cell.textLabel.textColor=colorblack_154;
    cell.detailTextLabel.text=_dataArray1[indexPath.row];
    cell.detailTextLabel.textColor=colorblack_154;
    cell.textLabel.font=[UIFont systemFontOfSize: 14*XLscaleH];
    cell.detailTextLabel.font=[UIFont systemFontOfSize: 12*XLscaleH];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
   
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50*XLscaleH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.row==0)||(indexPath.row==3)) {
        changManeger *go=[[changManeger alloc]init];
        if (indexPath.row==0) {
            go.type=@"0";
        }else if (indexPath.row==3){
            go.type=@"3";
        }
        [self.navigationController pushViewController:go animated:YES];
    }
    
    if ((indexPath.row==1)||(indexPath.row==2)){
        OssMessageViewController *OSSView=[[OssMessageViewController alloc]init];
        OSSView.firstPhoneNum=_dataArray1[indexPath.row];
        if (indexPath.row==1){
               OSSView.addQuestionType=@"1";
        }else{
              OSSView.addQuestionType=@"2";
        }
        OSSView.changeType=@"1";
        [self.navigationController pushViewController:OSSView animated:NO];
    }

}

@end
