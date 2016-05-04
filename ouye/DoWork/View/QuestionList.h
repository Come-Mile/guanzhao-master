//
//  QuestionList.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionListDelegate <NSObject>

- (void)scrollShouldScrollWith:(CGRect )rect;

/**
 *  解决键盘遮挡
 */
- (void)keyBoardShow:(CGPoint )point;

@end

@interface QuestionList : UIView

+(CGFloat )getHeightWith:(NSMutableArray *)array;

@property (nonatomic ,weak)id<QuestionListDelegate>delegate;

@property (nonatomic ,strong)NSMutableArray *questionArray;


/**
 *  list数据源
 */
@property (nonatomic ,strong)NSMutableArray *dataSoure;

@end
