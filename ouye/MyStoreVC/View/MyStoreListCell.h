//
//  MyStoreListCell.h
//  ouye
//
//  Created by Sino on 16/4/5.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreListItem;

@interface MyStoreListCell : UITableViewCell

@property (strong ,nonatomic)StoreListItem *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
