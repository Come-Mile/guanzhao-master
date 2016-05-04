//
//  MainTypeCell.m
//  ouye
//
//  Created by Sino on 16/3/22.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MainTypeCell.h"
#import "MainTypeItem.h"

@interface MainTypeCell()

@property (nonatomic , strong)UIImageView *AimageView;
@property (nonatomic, weak) UIView *divider;

@end

@implementation MainTypeCell


- (UIImageView *)AimageView
{
    if (_AimageView == nil) {
        _AimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectCellarrow"]];
        
    }
    return _AimageView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mainTypeCellId";
    MainTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MainTypeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        
        // 1.初始化背景
        [self setupBg];
        
        // 2.初始化子控件
        [self setupSubviews];
        
        // 3.初始化分割线
      
        [self setupDivider];
    }
    return self;
}
/**
 *  初始化背景
 */
- (void)setupBg
{
    // 设置普通背景
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bg;

}

/**
 *  初始化子控件
 */
- (void)setupSubviews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor blackColor];
    divider.alpha = 0.2;
    [self.contentView addSubview:divider];
    self.divider = divider;
}

/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    if (!iOS7) {
        CGFloat padding = 10;
        frame.size.width += padding * 2;
        frame.origin.x = -padding;
    }
    [super setFrame:frame];
}

/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置分割线的frame
    CGFloat dividerH = 1;
     CGFloat dividerX = 10;
    CGFloat dividerW = [UIScreen mainScreen].bounds.size.width -dividerX;
   
    CGFloat dividerY = self.contentView.frame.size.height - dividerH;
    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
}

- (void)setItem:(MainTypeItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

- (void)setupRightContent{
    
    if (self.item.select) {
       self.accessoryView = self.AimageView;
    }else{
        self.accessoryView = nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
   
}
@end
