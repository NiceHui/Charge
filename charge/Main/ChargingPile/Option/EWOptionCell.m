//
//  EWOptionCell.m
//  EasyWork
//
//  Created by Ryan on 16/7/28.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionCell.h"
#import "Masonry.h"


@interface EWOptionCell ()

@property(nonatomic, strong, readwrite) UIImageView *rightIconImageView;

@property(nonatomic, strong, readwrite) UILabel *detailTitleLabel;

@property(nonatomic, strong, readwrite) UILabel *titleLabel;

@property(nonatomic, strong) UIView *diverLine;

@property(nonatomic, strong, readwrite) UISwitch *st;

@property(nonatomic, strong, readwrite) UIImageView *leftIconImageView;

@end

@implementation EWOptionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *const identifier = @"option_cell";
    EWOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EWOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftIconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightIconImageView];
        [self.contentView addSubview:self.detailTitleLabel];
        [self.contentView addSubview:self.diverLine];
    }
    return self;
}

- (void)setItem:(EWOptionItem *)item {
    _item = item;

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel.text = item.title;
	
	if (item.isDisable) {
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
	} else {
		self.backgroundColor = [UIColor whiteColor];
	}

    if (item.icon) {
        [self.leftIconImageView setHidden:NO];
        UIImage *iconImage = [UIImage imageNamed:item.icon];
        self.leftIconImageView.image = iconImage;
        [self.leftIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconImage.size.width, iconImage.size.height));
            make.left.mas_equalTo(20*XLscaleW);
            make.centerY.mas_equalTo(self.contentView);
        }];
    } else {
        [self.leftIconImageView setHidden:YES];
    }

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIconImageView.mas_right).offset(10*XLscaleW);
        make.top.bottom.mas_equalTo(self.contentView);
		make.width.mas_greaterThanOrEqualTo(66*XLscaleW);
    }];

    if (item.accessoryIcon) {
        [self.rightIconImageView setHidden:NO];
        self.rightIconImageView.image = [UIImage imageNamed:item.accessoryIcon];
        [self.rightIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16*XLscaleH, 16*XLscaleH));
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
    } else {
        [self.rightIconImageView setHidden:YES];
    }

    if ([item isMemberOfClass:[EWOptionSwitchItem class]]) {
        [self addSubview:self.st] ;
        // 设置开关状态
        self.st.on = [(EWOptionSwitchItem *) item isOn];
    } else {
//        self.accessoryView = nil;
        [self.st removeFromSuperview] ;
    }

    // 如果箭头Item
    if ([item isMemberOfClass:[EWOptionArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([item isMemberOfClass:[EWOptionItem class]]) { // 如果是普通Item
        self.accessoryType = UITableViewCellAccessoryNone;
    }

//    CGFloat disclosureIndicatorW = 33;

    if (item.detailTitle) {
        [self.detailTitleLabel setHidden:NO];
        self.detailTitleLabel.text = item.detailTitle;
        [self.detailTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            // 如果有accessoryType，则contentView的mas_right就是accessoryType的左边
            // 如果没有accessoryType，则contentView的mas_right就是屏幕的最右边。
            if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-5*XLscaleW);
            } else if (self.accessoryType == UITableViewCellAccessoryNone) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-15*XLscaleW);
            }
            make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).offset(20*XLscaleW);
            make.top.bottom.mas_equalTo(self.contentView);
			make.width.mas_lessThanOrEqualTo(200*XLscaleW);
        }];
    } else {
        [self.detailTitleLabel setHidden:YES];
    }

    [self.diverLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.left.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
	
	
}

- (UIImageView *)rightIconImageView {
    if (!_rightIconImageView) {
        _rightIconImageView = [[UIImageView alloc] init];
    }
    return _rightIconImageView;
}

- (UIImageView *)leftIconImageView {
    if (!_leftIconImageView) {
        _leftIconImageView = [[UIImageView alloc] init];
    }
    return _leftIconImageView;
}

- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.textAlignment = NSTextAlignmentRight;
        _detailTitleLabel.numberOfLines = 0;
        _detailTitleLabel.font = FontSize(14*XLscaleH);
        _detailTitleLabel.textColor = HexRGB(0xadadad);
    }
    return _detailTitleLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = FontSize(15*XLscaleH);
        _titleLabel.textColor = HexRGB(0x464646);
    }
    return _titleLabel;
}

- (UIView *)diverLine {
    if (!_diverLine) {
        _diverLine = [[UIView alloc] init];
        _diverLine.backgroundColor = HexRGB(0xeeeeee);
    }
    return _diverLine;
}

- (UISwitch *)st {
    if (!_st) {
        _st = [[UISwitch alloc] init];
        [_st setOnTintColor:mainColor] ;
        _st.frame = CGRectMake(ScreenWidth - 70*XLscaleW, 8*XLscaleH, 3*XLscaleW, 30*XLscaleH) ;
        _st.transform = CGAffineTransformScale(_st.transform, 0.85, 0.85) ;
        [_st addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _st;
}

- (void)switchValueChange:(UISwitch *)sender {
    if ([self.item isMemberOfClass:[EWOptionSwitchItem class]]) {
        EWOptionSwitchItem *switchItem = (EWOptionSwitchItem *) self.item;
        if (switchItem.switchItemBlock) {
            switchItem.switchItemBlock(sender.isOn);
        }
    }
}

- (void)setHideSeparatorLine:(BOOL)hideSeparatorLine {
    _hideSeparatorLine = hideSeparatorLine;

    [self.diverLine setHidden:hideSeparatorLine];
}

- (void)setIconLeftPadding:(CGFloat)iconLeftPadding {
    _iconLeftPadding = iconLeftPadding;

    [self.leftIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconLeftPadding);
    }];
}

@end
