//
//  LZQStratViewController_25.m
//  SupperSupper
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LZQStratViewController_25.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"

#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height


@interface LZQStratViewController_25 () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    
    UIButton *_btn;
}
@end

@implementation LZQStratViewController_25

- (void)viewDidLoad {
    [super viewDidLoad];
    
       [self.navigationController setNavigationBarHidden:YES];
    
    [self addSrollView];
  //  [self addTimer];
    
    [self addBtn];
}

- (void)addSrollView{
    //初始化滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H)];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSMutableArray *imageName=[NSMutableArray array];
    
    if ([currentLanguage hasPrefix:@"zh-Hans"] ){
        [imageName addObject:@"引导页1"];
        [imageName addObject:@"引导页2"];
        [imageName addObject:@"引导页3"];
    }else if ([currentLanguage hasPrefix:@"en"]) {
        [imageName addObject:@"引导页1"];
        [imageName addObject:@"引导页2"];
        [imageName addObject:@"引导页3"];
    }else{
        [imageName addObject:@"引导页1"];
        [imageName addObject:@"引导页2"];
        [imageName addObject:@"引导页3"];
    }
    
    for (int i = 0; i < imageName.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_W * i, 0, SCR_W, SCR_H)];
        imageView.image = [UIImage imageNamed:imageName[i]];
        [_scrollView addSubview:imageView];
    }
    //设置滚动视图区域
    _scrollView.contentSize = CGSizeMake(SCR_W * imageName.count, 0);
    //设置分页显示，一页的宽度是我们视图的宽度
    _scrollView.pagingEnabled = YES;
    //设置滚动风格
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
          //  UIScrollViewIndicatorStyleDefault, // 黑色
          //  UIScrollViewIndicatorStyleBlack,   // 黑色
          //  UIScrollViewIndicatorStyleWhite    // 白色
    
    //隐藏水平导航栏
    _scrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    // 关闭弹簧效果
    // _scrollView.bounces = NO;
    // 关闭滑动效果
    //_scrollView.scrollEnabled = NO;
    
    
    //分页控制器（小圆点－－位置）
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCR_H - 55*XLscaleH, SCR_W, 40*XLscaleH)];
    _pageControl.backgroundColor = mainColor;
    //设置小圆点个数
    _pageControl.numberOfPages = imageName.count;
//    [self.view addSubview:_pageControl];
}

//- (void)addTimer{
//    //添加定时器
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
//    //scheduled--时刻表  interval--间隔  target--目标  repeats-- 重写   Info--信息
//}

//static BOOL reverse = NO;
//reverse -- 相反情况

//- (void)startTimer{
//    NSInteger count = 3;
//    static NSInteger page = 0;
//    
//  //  if (page < count - 1) {
//    
//        page ++;
//        if (page == count) {
//            LZQDidStartViewController_25 *lzqSVC = [[LZQDidStartViewController_25 alloc] init];
//            [self presentViewController:lzqSVC animated:YES completion:nil];
//        }
//    
// //   }
//    CGFloat offSetX = page * SCR_W;
//    CGPoint offset = CGPointMake(offSetX, 0);
//    [_scrollView setContentOffset:offset animated:YES];
//}

- (void)addBtn{
    
    UIButton *goBut =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IS_IPHONE_X) {
        goBut.frame=CGRectMake(ScreenWidth*5/2-100*XLscaleW, SCR_H - 130*XLscaleH, 200*XLscaleW, 35*XLscaleH);
    }else{
        goBut.frame=CGRectMake(ScreenWidth*5/2-100*XLscaleW, SCR_H - 100*XLscaleH, 200*XLscaleW, 35*XLscaleH);
    }
    [goBut setBackgroundImage:IMAGE(@"btn1.png") forState:UIControlStateNormal];
    goBut.titleLabel.font=[UIFont systemFontOfSize: 16*XLscaleH];
    [goBut setTitleColor:mainColor forState:UIControlStateNormal];
    [goBut setTitle:root_liji_tiyan forState:UIControlStateNormal];
    [goBut addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    //  goBut.highlighted=[UIColor grayColor];
    [_scrollView addSubview:goBut];
    
//    _btn = [[UIButton alloc] initWithFrame:CGRectMake(SCR_W * 2 + SCR_W / 2, 300, 100, 30)];
//    _btn.backgroundColor = [UIColor redColor];
//    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
//    [_btn setTitle:@"点击计入App" forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_scrollView addSubview:_btn];
}

- (void)clickBtn{
    
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[LoginViewController new]];
    KEYWINDOW.rootViewController = nav;
    [KEYWINDOW makeKeyAndVisible];
}

#pragma mark - UIScrollViewDelegate
#pragma mark - 只要视图滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置_pageControl当前小圆点的位置
    _pageControl.currentPage = _scrollView.contentOffset.x / SCR_W;
}

#pragma mark - 移除
- (void)dealloc
{
    // 移除定时器
    [_timer invalidate];
    _timer = nil;
}
@end
