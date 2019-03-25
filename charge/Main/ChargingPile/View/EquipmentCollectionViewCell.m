//
//  EquipmentCollectionViewCell.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/2.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "EquipmentCollectionViewCell.h"

@interface EquipmentCollectionViewCell()

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UILabel *label;

@end

@implementation EquipmentCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        [self createUI];

    }

    return self;
}

- (void)createUI{

    self.tintColor = [UIColor clearColor];
    
    CGRect cellFrame = self.bounds;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    int imageWidth = 40*XLscaleW;
    int imageHeight = 40*XLscaleH;
    self.imageView.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]init];
    self.label = label;
    label.textAlignment = NSTextAlignmentCenter;
    
    imageView.xmg_x = cellFrame.origin.x + (cellFrame.size.width - imageView.xmg_size.width)/2.f;
    imageView.xmg_y = (cellFrame.size.height - imageView.xmg_size.width - label.font.lineHeight)/2.f;
    if ([self.string containsString:@"\n"]) {
        imageView.xmg_y = (cellFrame.size.height - imageView.xmg_size.width - 2*label.font.lineHeight)/2;
        label.frame = CGRectMake(cellFrame.origin.x, CGRectGetMaxY(imageView.frame)-7, cellFrame.size.width, 2*label.font.lineHeight);
        
    }else{
        label.frame = CGRectMake(cellFrame.origin.x, CGRectGetMaxY(imageView.frame), cellFrame.size.width, label.font.lineHeight);
    }
    [self addSubview:label];

    XLViewBorderRadius(self, 5, 0, [UIColor clearColor]);
    
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongTouchWithCell)];
    longpress.minimumPressDuration = 0.5f;
    [self addGestureRecognizer:longpress];
}

- (void)setCellTitle:(NSString *)title withImage:(NSString *)imageStr BgColor:(UIColor *)bgColor{
    
    self.string = title;
    UIImage *image = [UIImage imageNamed:imageStr];
    if (!image) {
        image = [UIImage imageNamed:imageStr];
    }
    
    self.imageView.image = image;
    self.label.textColor = COLOR(255, 255, 255, 1);
    self.label.text = title;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
//    self.label.font = [UIFont systemFontOfSize:14*XLscaleH];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.backgroundColor = bgColor;
    
}

// 长按cell
- (void)LongTouchWithCell{
    
    if(self.longTouchDeleteWithCharge){
        self.longTouchDeleteWithCharge(self.sn);
    }
    
}


@end
