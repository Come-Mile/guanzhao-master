//
//  WorkListCell.m
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WorkListCell.h"
#import "WorkListModel.h"
@interface WorkListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imaView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation WorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WorkListCellId";
    WorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"WorkListCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)setItem:(WorkListModel *)item
{
    _item = item;
    
    [self setUpDatas];
}

- (void)setUpDatas
{
    self.titleLabel.text = self.item.task_name;
    if ([self.item.task_type isEqualToString:@"1"]) {
        self.imaView.image = [UIImage imageNamed:@"_zhaoxiang"];
    }else if([self.item.task_type isEqualToString:@"2"]){
        self.imaView.image = [UIImage imageNamed:@"_shexiang-0"];
    }else if([self.item.task_type isEqualToString:@"3"]){
        self.imaView.image = [UIImage imageNamed:@"_shuju"];
    }else if([self.item.task_type isEqualToString:@"4"]){
        self.imaView.image = [UIImage imageNamed:@"weizhi"];
    }
}

@end
