//
//  CheckAddCell.h
//  Research
//
//  Created by pang on 15/2/1.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CheckAddCellDelegate <NSObject>

-(void)addImage;

@end
@interface CheckAddCell : UITableViewCell
@property(nonatomic,strong)id <CheckAddCellDelegate>delegate;
@end
