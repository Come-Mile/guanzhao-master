//
//  SingleNoteView.h
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"

@interface SingleNoteView : UIView
@property (nonatomic , weak)IWTextView *textView;
- (CGFloat )getHeight;
@end
