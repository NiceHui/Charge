//
//  EBDropdownList.m
//  DropdownListDemo
//
//  Created by HoYo on 2018/4/17.
//  Copyright © 2018年 HoYo. All rights reserved.
//

#import "EBDropdownListView.h"
@implementation EBDropdownListItem
- (instancetype)initWithItem:(NSString*)itemId itemName:(NSString*)itemName {
    self = [super init];
    if (self) {
        _itemId = itemId;
        _itemName = itemName;
    }
    return self;
}

- (instancetype)init {
    return [self initWithItem:nil itemName:nil];
}
@end


@interface EBDropdownListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSString *arrowImageName;
@property (nonatomic, copy) EBDropdownListViewSelectedBlock selectedBlock;
@end

static CGFloat const kArrowImgHeight= 10;
static CGFloat const kArrowImgWidth= 15;
static CGFloat const kTextLabelX = 5;
static CGFloat const kItemCellHeight = 30;

@implementation EBDropdownListView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupProperty];
    }
    return self;
}

- (instancetype)initWithDataSource:(NSArray*)dataSource andImage:(NSString *)imageName{
    _dataSource = dataSource;
    _arrowImageName = imageName;
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrame];
}

#pragma mark - Setup
- (void)setupProperty {
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:13*XLscaleH];
    _selectedIndex = 0;
    _textLabel.font = _font;
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.textColor = _textColor;
    
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    [_textLabel addGestureRecognizer:tapLabel];

    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewExpand:)];
    [_arrowImg addGestureRecognizer:tapImg];
}

- (void)setupView {
    [self addSubview:self.textLabel];
    [self addSubview:self.arrowImg];
}

- (void)setupFrame {
    CGFloat viewWidth = CGRectGetWidth(self.bounds)
    , viewHeight = CGRectGetHeight(self.bounds);
  
    _textLabel.frame = CGRectMake(kTextLabelX*XLscaleW, 0, viewWidth - 2*kTextLabelX*XLscaleW - kArrowImgWidth*XLscaleW , viewHeight);
    _arrowImg.frame = CGRectMake(CGRectGetWidth(_textLabel.frame), viewHeight / 2 - kArrowImgHeight*XLscaleH / 2, kArrowImgWidth*XLscaleW, kArrowImgHeight*XLscaleH);
}

#pragma mark - Events
-(void)tapViewExpand:(UITapGestureRecognizer *)sender {
    [self rotateArrowImage];
    
    CGFloat tableHeight = _dataSource.count * kItemCellHeight*XLscaleH;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    [window addSubview:self.tbView];
    
    // 获取按钮在屏幕中的位置
    CGRect frame = [self convertRect:self.bounds toView:window];
    CGFloat tableViewY = frame.origin.y + frame.size.height;
    CGRect tableViewFrame;
    tableViewFrame.size.width = frame.size.width-6;
    tableViewFrame.size.height = tableHeight;
    tableViewFrame.origin.x = frame.origin.x+3;
    if (tableViewY + tableHeight < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        tableViewFrame.origin.y = tableViewY;
    }else {
        tableViewFrame.origin.y = frame.origin.y - tableHeight;
    }
    _tbView.frame = tableViewFrame;
    
    UITapGestureRecognizer *tagBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewDismiss:)];
    [_backgroundView addGestureRecognizer:tagBackground];
}

-(void)tapViewDismiss:(UITapGestureRecognizer *)sender {
    [self removeBackgroundView];
}

#pragma mark - Methods
- (void)setDropdownListViewSelectedBlock:(EBDropdownListViewSelectedBlock)block {
    _selectedBlock = block;
}

- (void)rotateArrowImage {
    // 旋转箭头图片
    _arrowImg.transform = CGAffineTransformRotate(_arrowImg.transform, M_PI);
}

- (void)removeBackgroundView {
    [_backgroundView removeFromSuperview];
    [_tbView removeFromSuperview];
    [self rotateArrowImage];
}

- (void)selectedItemAtIndex:(NSInteger)index {
    _selectedIndex = index;
    if (index < _dataSource.count) {
        EBDropdownListItem *item = _dataSource[index];
        _selectedItem = item;
        _textLabel.text = item.itemName;
    }
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = _font;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.textLabel.textColor = _textColor;
    EBDropdownListItem *item = _dataSource[indexPath.row];
    cell.textLabel.text = item.itemName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectedItemAtIndex:indexPath.row];
    [self removeBackgroundView];
    if (_selectedBlock) {
        _selectedBlock(self);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


#pragma mark - Setter

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count > 0) {
        [self selectedItemAtIndex:_selectedIndex];
        // 更新tableview大小
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat tableHeight = self->_dataSource.count * kItemCellHeight*XLscaleH;
            CGRect rect = self.tbView.frame;
            rect.size.height = tableHeight;
            self.tbView.frame = rect;
            [self.tbView reloadData];
        });
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self selectedItemAtIndex:selectedIndex];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textLabel.textColor = textColor;
}
#pragma mark - Getter
- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.userInteractionEnabled = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView*)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [UIImageView new];
        _arrowImg.image = [UIImage imageNamed:_arrowImageName];
        _arrowImg.userInteractionEnabled = YES;
    }
    return _arrowImg;
}

- (UITableView*)tbView {
    if (!_tbView) {
        _tbView = [UITableView new];
        _tbView.dataSource = self;
        _tbView.delegate = self;
        _tbView.tableFooterView = [UIView new];
        _tbView.backgroundColor = [UIColor whiteColor];
        _tbView.layer.shadowOffset = CGSizeMake(4, 4);
        _tbView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _tbView.layer.shadowOpacity = 0.8;
        _tbView.layer.shadowRadius = 4;
        _tbView.layer.borderColor = _textColor.CGColor;
        _tbView.layer.borderWidth = 0.5;
        _tbView.layer.cornerRadius = 2;
        _tbView.clipsToBounds = NO;
        _tbView.bounces = NO;
        _tbView.rowHeight = kItemCellHeight*XLscaleH;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去虚线
    }
    return _tbView;
}

- (UIView*)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _backgroundView;
}
@end
