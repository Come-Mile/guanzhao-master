//
//  LeftTabViewCell.m
//  ouye
//
//  Created by Sino on 16/3/29.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "LeftTabViewCell.h"
#import "UILabel+StringFrame.h"
#import "AnnomentModel.h"

@interface LeftTabViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;


@end


@implementation LeftTabViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.redLabel.layer.masksToBounds = YES;
    self.redLabel.layer.cornerRadius = 4;
}

+ (instancetype)cellWithTabView:(UITableView *)tableView
{
    static NSString *ID = @"LeftTabViewCellId";
    LeftTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTabViewCell" owner:self options:nil]lastObject];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setItem:(AnnomentModel *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    self.messageLabel.text = item.content;
    
    if (item.date.length>16) {
        self.dateLabel.text = [item.date substringToIndex:16];
    }else{
        self.dateLabel.text = item.date;
    }
    
    
    [self setUpContentData];
}
- (void)setUpContentData
{
    CGFloat messX = CGRectGetMinX(self.titleLabel.frame);
    CGFloat messY = CGRectGetMaxY(self.titleLabel.frame);
    //    CGSize temSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(self.messageLabel.frame.size.width, MAXFLOAT)];
    CGSize temSize = [self.messageLabel boundingRectWithSize:CGSizeMake(self.messageLabel.frame.size.width, MAXFLOAT)];
    float temHeight = temSize.height;
    self.messageLabel.frame = CGRectMake(messX, messY+3, temSize.width,  ceilf(temHeight/21.0)*21.0);
    
    CGRect temRect = self.frame;
    temRect.size.height = CGRectGetMaxY(self.messageLabel.frame);
    
    if (temRect.size.height <60) {
        temRect.size.height = 60;
    }
    self.frame = temRect;

    self.redLabel.hidden = [self.item.check isEqualToString:@"0"] ? NO:YES;

}
- (void)setMessage:(NSString *)message
{
    _message = message;
    
    self.messageLabel.text = message;
    [self setUpContentData];
   
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
