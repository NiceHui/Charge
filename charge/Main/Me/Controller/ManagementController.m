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


@interface ManagementController ()<UITableViewDataSource,UITableViewDelegate>
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
    
    UIButton *registerUser =  [UIButton buttonWithType:UIButtonTypeCustom];
    registerUser.frame=CGRectMake((ScreenWidth-150*XLscaleW)/2,320*XLscaleH, 150*XLscaleW, 40*XLscaleH);
    XLViewBorderRadius(registerUser, 20*XLscaleH, 0, kClearColor);
    registerUser.backgroundColor = mainColor;
    registerUser.titleLabel.font=[UIFont systemFontOfSize: 16*XLscaleH];
    [registerUser setTitle:root_WO_zhuxiao_zhanhao forState:UIControlStateNormal];
    [registerUser setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    [registerUser addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:registerUser];

}


//-(void)initCoredata{
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GetDevice" inManagedObjectContext:_manager.managedObjContext];
//    [request setEntity:entity];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"deviceSN" ascending:NO];
//    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [request setSortDescriptors:sortDescriptions];
//    NSError *error = nil;
//    NSArray *fetchResult = [_manager.managedObjContext executeFetchRequest:request error:&error];
//    for (NSManagedObject *obj in fetchResult)
//    {
//        [_manager.managedObjContext deleteObject:obj];
//    }
//    BOOL isSaveSuccess = [_manager.managedObjContext save:&error];
//    if (!isSaveSuccess) {
//        NSLog(@"Error: %@,%@",error,[error userInfo]);
//    }else
//    {
//        NSLog(@"Save successFull");
//    }
//
//}






- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

-(void)registerUser{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *reUsername=[ud objectForKey:@"userName"];
    NSString *rePassword=[ud objectForKey:@"userPassword"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"F" forKey:@"LoginType"];
    [[UserInfo defaultUserInfo] setUserPassword:nil];
    [[UserInfo defaultUserInfo] setUserName:nil];
      [[UserInfo defaultUserInfo] setServer:nil];
    LoginViewController *login =[[LoginViewController alloc]init];
    if ([reUsername isEqualToString:@"guest"]) {
        login.oldName=nil;
        login.oldPassword=nil;
    }else{
    login.oldName=reUsername;
    login.oldPassword=rePassword;
    }

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
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
