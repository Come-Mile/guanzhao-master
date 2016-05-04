//
//  FillNoteCell.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"
#import "QuenstionModel.h"
@interface FillNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IWTextView *fillTextView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configCellWithModel:(OptionalAnswerModel *)model atIndexPath:(NSIndexPath *)indexPath;
@end
