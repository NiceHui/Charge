//
//  findViewController.m
//  shinelink
//
//  Created by sky on 16/2/15.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "meViewController.h"
#import "meTableViewCell.h"
#import "ManagementController.h"
#import "aboutViewController.h"
#import "LoginViewController.h"

@interface meViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *cameraImagePicker;
@property (nonatomic, strong) UIImagePickerController *photoLibraryImagePicker;

@end

@implementation meViewController
{
    UITableView *_tableView;
    UIPageControl *_pageControl;
    UIScrollView *_scrollerView;
    NSString *_indenty;
    
    NSArray *arrayImage;
    NSArray *arrayName;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_wode;
    self.view.backgroundColor = colorblack_222;
    //创建tableView的头视图
    [self _createHeaderView];
    //创建tableView的方法
    [self _createTableView];
}



- (void)_createTableView {
    
    arrayName=@[root_WO_zhiliao_guanli,root_WO_xiaoxi_zhongxin,root_WO_guanyu];
    arrayImage=@[@"ziliao",@"message",@"about"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200*XLscaleH, ScreenWidth, 200*XLscaleH)];
    _tableView.backgroundColor = COLOR(255, 255, 255, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //注册单元格类型
    [_tableView registerClass:[meTableViewCell class] forCellReuseIdentifier:@"indenty"];
    
}

- (void)_createHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,200*XLscaleH)];
    [self.view addSubview:headerView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,200*XLscaleH)];
    [bgImgView setImage:[UIImage imageNamed:@"geren_bg"]];
    [headerView addSubview:bgImgView];
    
//    [headerView sendSubviewToBack:bgImgView];
    
    double imageSize=90*XLscaleH;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSData *pic=[ud objectForKey:@"userPic"];
    
    UIImageView *userImage= [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imageSize)/2, (200*XLscaleH-imageSize)/2-10*XLscaleH, imageSize, imageSize)];
    userImage.layer.masksToBounds=YES;
    userImage.layer.cornerRadius=imageSize/2.0;
    [userImage setUserInteractionEnabled:YES];
    
    if((pic==nil) || (pic.length==0)){
        [userImage setImage:[UIImage imageNamed:@"touxiang.png"]];
    }else{
        UIImage *image = [UIImage imageWithData: pic];
        [userImage setImage:image];
    }
    
    UITapGestureRecognizer * longPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickUpImage)];
     [userImage addGestureRecognizer:longPressGesture];
    
    NSUserDefaults *ud1=[NSUserDefaults standardUserDefaults];
    NSString *reUsername=[NSString stringWithFormat:@"%@",[ud1 objectForKey:@"userName"]];
    if ([reUsername isEqualToString:@"ceshi00701"]) {
        reUsername = root_liulanzhanghu;
    }
    UILabel *PV2Lable=[[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-200*XLscaleW)/2, 150*XLscaleH-5*XLscaleH, 200*XLscaleW, 20*XLscaleH)];
    PV2Lable.text=reUsername;
    PV2Lable.textAlignment=NSTextAlignmentCenter;
    PV2Lable.textColor=[UIColor whiteColor];
    PV2Lable.font = [UIFont systemFontOfSize:14*XLscaleH];
    [headerView addSubview:PV2Lable];
    
    [headerView addSubview:userImage];

    
    UIButton *registerUser =  [UIButton buttonWithType:UIButtonTypeCustom];
    registerUser.frame=CGRectMake(75*XLscaleW, 450*XLscaleH, ScreenWidth-150*XLscaleW, 45*XLscaleH);
    XLViewBorderRadius(registerUser, 22*XLscaleH, 0, kClearColor);
    registerUser.backgroundColor = mainColor;
    registerUser.titleLabel.font=[UIFont systemFontOfSize: 16*XLscaleH];
    [registerUser setTitle:root_tuichudenglu forState:UIControlStateNormal];
    [registerUser setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    [registerUser addTarget:self action:@selector(registerUserAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerUser];
}

- (void)pickUpImage{
    NSLog(@"取照片");
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: root_paiZhao style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         //处理点击拍照
        self.cameraImagePicker = [[UIImagePickerController alloc] init];
        self.cameraImagePicker.allowsEditing = YES;
        self.cameraImagePicker.delegate = self;
        self.cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_cameraImagePicker animated:YES completion:nil];

    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: root_xiangkuang_xuanQu style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        self.photoLibraryImagePicker = [[UIImagePickerController alloc] init];
        self.photoLibraryImagePicker.allowsEditing = YES;
        self.photoLibraryImagePicker.delegate = self;
        self.photoLibraryImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_photoLibraryImagePicker animated:YES completion:nil];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: root_cancel style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
    }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [[UserInfo defaultUserInfo] setUserPic:imageData];
    
    [self _createHeaderView];
 
}

// 退出提示
- (void)registerUserAlert{
    UIAlertController *removeAlert = [UIAlertController alertControllerWithTitle:root_tuichu_zhanghu message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self registerUser];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
    [removeAlert addAction:enter];
    [removeAlert addAction:cancel];
    [self presentViewController:removeAlert animated:YES completion:nil];
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
    if ([reUsername isEqualToString:@"ceshi00701"]) {
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


#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55*XLscaleH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    meTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indenty" forIndexPath:indexPath];
    if (!cell) {
        cell=[[meTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_indenty];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell.imageLog setImage:[UIImage imageNamed:arrayImage[indexPath.row]]];
    cell.tableName.text = arrayName[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        ManagementController *vc = [[ManagementController alloc]init];
        vc.title = root_WO_zhiliao_guanli;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        
        [self showToastViewWithTitle:root_WO_zanweikaifang];
        
    }else if (indexPath.row == 2){
        
        aboutViewController *vc = [[aboutViewController alloc]init];
        vc.title = root_WO_guanyu;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
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
