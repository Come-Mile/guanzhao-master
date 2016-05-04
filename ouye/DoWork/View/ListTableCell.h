//
//  ListTableCell.h
//  Questionnaire
//
//  Created by Sino on 16/3/9.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuenstionModel.h"
@interface ListTableCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configCellWithModel:(OptionalAnswerModel *)model atIndexPath:(NSIndexPath *)indexPath;
@end
