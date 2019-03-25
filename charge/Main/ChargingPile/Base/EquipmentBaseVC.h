//
//  EquipmentBaseVC.h
//  ShinePhone
//
//  Created by mac on 2018/6/2.
//  Copyright © 2018年 qwl. All rights reserved.
//
#import "BaseViewController.h"
//#import "RootPickerView.h"
//#import "EquimentButton.h"
//#import "InformationView.h"
#import "CircelView.h"
#import "TabButton.h"
#import "TabCenterButton.h"
#import "TabLeftRightButton.h"


@interface EquipmentBaseVC : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UICollectionView *devCollectView;

@property (nonatomic, copy)NSString *currentDevType;

/// duqueueReusavleCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
