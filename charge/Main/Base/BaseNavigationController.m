//
//  BaseViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+ (void)initialize {
    if (self == [BaseNavigationController class]) {
        [self setupNavBarTheme];
    }
}

+ (void)setupNavBarTheme {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIImage *image = [UIImage createImageWithColor:[UIColor whiteColor]];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    NSMutableDictionary *muArr = [NSMutableDictionary dictionary];
    muArr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    muArr[NSForegroundColorAttributeName] = colorblack_51;
    [navBar setTitleTextAttributes:muArr];
    [navBar setTintColor:COLOR(67, 67, 67, 1)];
    
//    UITabBarItem *appearance = [UITabBarItem appearance];
//    NSMutableDictionary *tabbarDict = [NSMutableDictionary dictionary];
//    tabbarDict[NSFontAttributeName] = FontSize(15);
//    tabbarDict[NSForegroundColorAttributeName] = colorblack_51;
//    [appearance setTitleTextAttributes:tabbarDict forState:UIControlStateNormal];
//    [appearance setTitleTextAttributes:tabbarDict forState:UIControlStateHighlighted];
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
