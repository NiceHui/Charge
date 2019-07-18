//
//  HSWiFiOperationPromptVC.m
//  charge
//
//  Created by growatt007 on 2019/6/15.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSWiFiOperationPromptVC.h"

@interface HSWiFiOperationPromptVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HSWiFiOperationPromptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_caozuozhiyin;
    
    [self createUI];
}


- (void)createUI{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = CGRectMake(0, 0, ScreenWidth, 10*XLscaleH);
    lineLayer.backgroundColor = colorblack_222.CGColor;
    [_scrollView.layer addSublayer:lineLayer];
    
    
    NSArray *titleArray = @[root_caozuoyindao_1, root_caozuoyindao_2, root_caozuoyindao_3];
    NSArray *imageArray = @[@"直连操作1_cn", @"直连操作2_cn", @"直连操作3_cn"];
    if (![self.languageType isEqualToString:@"0"]) {
        imageArray = @[@"直连操作1_en", @"直连操作2_en", @"直连操作3_en"];
    }
    NSArray *sizeArray = @[[NSNumber numberWithFloat:260.0/482.0], [NSNumber numberWithFloat:267.0/429.0], [NSNumber numberWithFloat:529.0/482.0]];
    
    CGFloat marginLF = 15*XLscaleW;
    CGFloat lblNumW = 20*XLscaleH, lblNumH = 20*XLscaleH; // 圆的宽，高
    CGFloat lblTitleW = ScreenWidth-3*marginLF-lblNumW; // 标题的宽
    CGFloat imgW = ScreenWidth-100*XLscaleW;
    CGFloat SumY = marginLF;
    for (int i = 0; i < 3; i++) {
        // 序号
        UILabel *lblNum = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, SumY+5, lblNumW, lblNumH)];
        lblNum.font = FontSize(14*XLscaleH);
        lblNum.text = [NSString stringWithFormat:@"%d",i+1];
        lblNum.textColor = COLOR(255,255,255, 1);
        lblNum.textAlignment = NSTextAlignmentCenter;
        lblNum.backgroundColor = COLOR(247,134,59, 1);
        XLViewBorderRadius(lblNum, lblNumW/2, 0, kClearColor);
        [_scrollView addSubview:lblNum];
        
        // 计算内容高度
        NSString*snString=titleArray[i];
        CGSize size = [snString boundingRectWithSize:CGSizeMake(lblTitleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 14*XLscaleH]} context:nil].size;
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(2*marginLF+lblNumW, SumY, lblTitleW, size.height+10*XLscaleH)];
        lblTitle.text = titleArray[i];
        lblTitle.font = FontSize(14*XLscaleH);
        lblTitle.textColor = colorblack_102;
        lblTitle.numberOfLines = 0;
        [_scrollView addSubview:lblTitle];
        SumY += size.height + marginLF +10*XLscaleH;
        
        // 图片
        float imgH = [sizeArray[i] floatValue] * imgW;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(50*XLscaleW, SumY, imgW, imgH)];
        imgV.image = IMAGE(imageArray[i]);
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imgV];
        
        SumY += imgH + marginLF;
    }
    _scrollView.contentSize = CGSizeMake(ScreenWidth, SumY);
}


@end
