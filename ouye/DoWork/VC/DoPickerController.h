//
//  DoPickerController.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkListModel;
@class DeviderWorkModel;
@interface DoPickerController : UIViewController

@property (nonatomic, strong)DeviderWorkModel *DeviderItem;
@property (nonatomic ,strong)WorkListModel *workItem;
@end
