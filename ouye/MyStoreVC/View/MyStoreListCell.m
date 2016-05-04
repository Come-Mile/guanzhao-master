//
//  MyStoreListCell.m
//  ouye
//
//  Created by Sino on 16/4/5.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MyStoreListCell.h"
#import "StoreListItem.h"


@interface MyStoreListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation MyStoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.5];
    self.selectedBackgroundView = selectedBg;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyStoreListCellId";
    MyStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"MyStoreListCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)setItem:(StoreListItem *)item
{
    _item = item;
    
    [self setUpData];
    
}

- (void)setUpData
{
    self.titleLabel.text = self.item.p_name;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.item.money];
}

@end
