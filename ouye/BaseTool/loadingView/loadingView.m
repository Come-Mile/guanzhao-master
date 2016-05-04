//
//  loadingView.m
//  lianhelihua
//
//  Created by Sino on 16/2/25.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "loadingView.h"

@interface loadingView()

@property (nonatomic ,weak)UIAlertView *loadingAlert;

@end

@implementation loadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setAlertTitle:(NSString *)alertTitle
{
    _alertTitle = alertTitle;
    [self setUpLoadingView];
}

- (void)setUpLoadingView
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:self.alertTitle];
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(140,
                                80,
                                CGRectGetWidth(alert.frame),
                                CGRectGetHeight(alert.frame));
    
    [alert addSubview:activity];
    [activity startAnimating];
    [alert show];
    self.loadingAlert = alert;
    self.backgroundColor = [UIColor clearColor];
}

- (void)removeFromSuperview
{
    [self.loadingAlert dismissWithClickedButtonIndex:0 animated:NO];
    [super removeFromSuperview];
   
  
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect tempRect = self.frame;
    tempRect.size = self.loadingAlert.frame.size;
    self.frame = tempRect;
}
@end
