//
//  NotesScroll.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordModel;

@protocol NotesScrollDelegate <NSObject>

- (void)summitBtnHaveClick:(UIButton *)sender;

@end
@interface NotesScroll : UIScrollView

@property (nonatomic ,weak)id<NotesScrollDelegate>baseDelegate;

@property (nonatomic ,copy)NSString *detailText;

@property (nonatomic ,strong)RecordModel *RecoItem;

@end
