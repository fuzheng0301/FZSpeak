//
//  FZProgressHudView.h
//
//  Created by Zhang Cheng on 13-12-13.
//  Copyright (c) 2013年 Zhang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FZProgressHudView : UIView

@property (strong, nonatomic) UIView *hudView;
@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UIImageView *activityIndicatorImageView;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic)   UIView *targetView; //覆盖在哪一个view上面

- (id)initWithTargetView:(UIView *) view;
- (void)startWork:(NSString *)workName;
- (void)hideHudWithSuccess:(NSString *)successString andDuration:(NSTimeInterval)duration;
- (void)hideHudWIthFailure:(NSString *)failureString andDuration:(NSTimeInterval)duration;
- (void)showHudWithSuccess:(NSString *)successString andDuration:(NSTimeInterval)duration;
- (void)showHudWithFailure:(NSString *)failureString andDuration:(NSTimeInterval)duration;
- (void)hideHudImmediately;

+ (FZProgressHudView *)shareInstance;

@end
