//
//  EquipmentBaseVC.m
//  ShinePhone
//
//  Created by mac on 2018/6/2.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "EquipmentBaseVC.h"
#import "meViewController.h"

@interface EquipmentBaseVC ()<UIScrollViewDelegate>

@end

@implementation EquipmentBaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    // 底图颜色设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:COLOR(35, 70, 108, 0)] forBarMetrics:UIBarMetricsDefault];
    // 字体颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:colorblack_51}];
    // 底图颜色设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:COLOR(255, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault];
    // 字体颜色
    [self.navigationController.navigationBar setTintColor:colorblack_51];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeadView];
    [self creatViews];
    [self createEmpty];
}

- (void)createHeadView{
    // 个人信息
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 24, 24);
    [leftBtn setTintColor:COLOR(0, 156, 255, 1)];
    [leftBtn setImage:[IMAGE(@"user_index") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(myInfomation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)creatViews{
    
    
    UIImageView *bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90*XLscaleH+kNavBarHeight)];
    bgImageView1.image = IMAGE(@"charging_bg");
    [self.view addSubview:bgImageView1];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90*XLscaleH+kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-90*XLscaleH-kBottomBarHeight)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 0);
    self.scrollView.backgroundColor = colorblack_222;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *))
    {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //    bottom_bg
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollView.xmg_height-74*XLscaleH, ScreenWidth, 74*XLscaleH)];
    bgImgView.image = IMAGE(@"bottom_bg");
    bgImgView.userInteractionEnabled = YES;
    self.bgImgView = bgImgView;
    [self.scrollView addSubview:bgImgView];
    
    // collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 13;
    flowLayout.minimumInteritemSpacing = 16*XLscaleH;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *devCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, 90*XLscaleH) collectionViewLayout:flowLayout];
    devCollectView.backgroundColor = COLOR(0, 0, 0, 0);
    devCollectView.delegate = self;
    devCollectView.dataSource = self;
    devCollectView.contentInset = UIEdgeInsetsMake(13, 16*XLscaleH, 13, 16*XLscaleH);
    devCollectView.alwaysBounceHorizontal = YES;
    devCollectView.showsHorizontalScrollIndicator = NO;
    self.devCollectView = devCollectView;
    [devCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.view addSubview:devCollectView];

}


- (void)createEmpty{
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emptyView];
    [self.view bringSubviewToFront:emptyView];
    self.emptyView = emptyView;
    self.emptyView.hidden = YES;
    
    UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100*XLscaleW, ScreenHeight/2-150*XLscaleH, 200*XLscaleW, 120*XLscaleH)];
    emptyImageView.image = IMAGE(@"empty.png");
    [emptyView addSubview:emptyImageView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100*XLscaleW,CGRectGetMaxY(emptyImageView.frame)+20*XLscaleH, 200*XLscaleW, 14*XLscaleH)];
    tipLabel.font = FontSize(14*XLscaleW);
    tipLabel.textColor = colorblack_222;
    tipLabel.text = HEM_meiyoushebei;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:tipLabel];
    
    UIButton *emptyBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-75*XLscaleW,CGRectGetMaxY(tipLabel.frame)+30*XLscaleH, 150*XLscaleW, 45*XLscaleH)];
    [emptyBtn setTitle:HEM_tianjiashebei forState:UIControlStateNormal];
    [emptyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emptyBtn setBackgroundColor:mainColor];
    XLViewBorderRadius(emptyBtn, 22*XLscaleH, 0, kClearColor);
    [emptyView addSubview:emptyBtn];
    [emptyBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchBottomButton:(UIButton *)sender{
//    [self showToastViewWithTitle:HEM_zanWuQuanXian];
}

// 个人信息
- (void)myInfomation:(UIButton *)button{
    meViewController *vc = [[meViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


/// duqueueReusavleCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count == 0) {
        self.emptyView.hidden = NO;
        [self.scrollView bringSubviewToFront:self.emptyView];
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }else{
        self.emptyView.hidden = YES;
        self.scrollView.backgroundColor = colorblack_222;
    }
    return self.dataSource.count + 1;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(100*XLscaleW, 62*XLscaleH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [self collectionView:collectionView dequeueReusableCellWithIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    id object = [self.dataSource objectAtIndex:indexPath.row];
    
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    
    return cell;
}

// 懒加载
- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}


@end
