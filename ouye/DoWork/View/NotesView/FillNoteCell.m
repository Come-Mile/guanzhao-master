//
//  FillNoteCell.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "FillNoteCell.h"
#import "IWTextView.h"

@interface FillNoteCell()

@property (nonatomic, copy) NSIndexPath *indexPath;
@end

@implementation FillNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 1.添加textView
    self.fillTextView.font = [UIFont systemFontOfSize:15];

    // 垂直方向上永远可以拖拽
    self.fillTextView.alwaysBounceVertical = YES;
//    self.fillTextView.delegate = self;
    self.fillTextView.placeholder = @"请输入填空题的答案...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FillNoteCellId";
    FillNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"FillNoteCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)configCellWithModel:(OptionalAnswerModel *)model atIndexPath:(NSIndexPath *)indexPath {

    self.indexPath = [indexPath copy];
    
    self.fillTextView.text = model.fillNotes;
    
}



@end
