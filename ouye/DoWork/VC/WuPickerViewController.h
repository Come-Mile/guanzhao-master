//
//  WuPickerViewController.h
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviderWorkModel;
@class WorkListModel;
@interface WuPickerViewController : UIViewController

@property (nonatomic, strong)DeviderWorkModel *DeviderItem;
@property (nonatomic ,strong)WorkListModel *workItem;


@end
