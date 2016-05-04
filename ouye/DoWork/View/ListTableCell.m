//
//  ListTableCell.m
//  Questionnaire
//
//  Created by Sino on 16/3/9.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "ListTableCell.h"


@interface ListTableCell()

@property (nonatomic, strong) UILabel  *optionalAnswerLabel;
@property (nonatomic, strong) UIButton *radioButton;
@property (nonatomic, copy) NSIndexPath *indexPath;

@end

@implementation ListTableCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"clockCellId";
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpContentView];
    }
    return self;
}

- (void)setUpContentView
{
    self.radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.radioButton setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
    [self.radioButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [self.radioButton sizeToFit];
    self.radioButton.center = CGPointMake(self.radioButton.frame.size.width / 2 + 25,
                                          self.contentView.center.y);
    [self.contentView addSubview:self.radioButton];
    self.radioButton.userInteractionEnabled = NO;
    
    self.optionalAnswerLabel = [[UILabel alloc] init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat x = self.radioButton.frame.size.width + self.radioButton.frame.origin.x + 10;
    self.optionalAnswerLabel.frame = CGRectMake(x,
                                                0,
                                                screenWidth - x - 15,
                                                self.contentView.frame.size.height);
    self.optionalAnswerLabel.numberOfLines = 0;
    [self.contentView addSubview:self.optionalAnswerLabel];
}

- (void)configCellWithModel:(OptionalAnswerModel *)model atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = [indexPath copy];
    
    self.radioButton.selected = model.isSelected;
    self.optionalAnswerLabel.text = model.optionalAnswerSummary;
}

- (void)setCellSelected:(BOOL)selected {
    self.radioButton.selected = selected;
}

@end
