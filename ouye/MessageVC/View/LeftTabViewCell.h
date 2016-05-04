//
//  LeftTabViewCell.h
//  ouye
//
//  Created by Sino on 16/3/29.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnomentModel;
@interface LeftTabViewCell : UITableViewCell

+ (instancetype)cellWithTabView:(UITableView *)tableView;

@property (nonatomic ,strong)AnnomentModel *item;
@property (nonatomic ,copy)NSString *message;
@end
