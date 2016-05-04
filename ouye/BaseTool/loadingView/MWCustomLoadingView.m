//
//  MWCustomLoadingView.m
//
//  Created by Sino on 16/3/18.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MWCustomLoadingView.h"
#import "AppDelegate.h"

#define MScreenW [[UIScreen mainScreen] bounds].size.width
#define MScreenH [[UIScreen mainScreen] bounds].size.height

#define floaH [[UIScreen mainScreen] bounds].size.height/736.0
@interface MWCustomLoadingView()

@property (nonatomic , weak)UIActivityIndicatorView *activityIndicator;

@end

static MWCustomLoadingView *loadingView =nil;
@implementation MWCustomLoadingView

+ (MWCustomLoadingView *)shareCustomLoadingView
{
    if (loadingView ==nil) {
        loadingView = [[MWCustomLoadingView alloc]init];
        loadingView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    }
    return loadingView;
    
}

- (void)showLoadingViewWithTitle:(NSString *)title InView:(UIView *)view
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frame = view.frame;

    CGFloat centerX = view.frame.size.width /2.0;
    CGFloat centerY = view.frame.size.height/2.0;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:CGPointMake(centerX-32.0f,centerY)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
    
    CGRect tempRect = {{0.0f,0.0f},{100,activityIndicator.frame.size.height}};
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:tempRect];
    textLabel.center = CGPointMake(centerX+32.0f, centerY);
    textLabel.font = [UIFont systemFontOfSize:13.0];
    textLabel.text = title;
    textLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:textLabel];
    
   
    
    [view.superview addSubview:self];
    
    [activityIndicator startAnimating];
}

- (void)stopShow
{
    [self.activityIndicator stopAnimating];
    [self removeFromSuperview];
}
@end
