//
//  FZProgressHudView.m
//
//  Created by Zhang Cheng on 13-12-13.
//  Copyright (c) 2013年 Zhang Cheng. All rights reserved.
//

#import "FZProgressHudView.h"
#import <QuartzCore/QuartzCore.h>

#define HUDWIDTH 140
#define STATUSIMAGEWIDTH 40 //状态提示图片的长，宽，该数字根据图片大小自行设定
#define FONT [UIFont systemFontOfSize:17]
#define LABELHEIGHT 20 //文字label的默认高度是20
#define SPACE 8  //把每个subview 之间的间距定位5

@implementation FZProgressHudView

+ (FZProgressHudView *)shareInstance
{
    static FZProgressHudView * hud = nil;
    @synchronized(self) {
        if (!hud) {
            hud = [[FZProgressHudView alloc]init];
        }
    }
    return hud;
}

- (id)initWithTargetView:(UIView *) view
{
    if (self = [super init])
    {
        CGRect rect = CGRectMake((HUDWIDTH - STATUSIMAGEWIDTH) / 2, SPACE, STATUSIMAGEWIDTH, STATUSIMAGEWIDTH);

        self.activityIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
        self.activityIndicatorImageView.hidden = YES;
        self.activityIndicatorImageView.frame = rect;
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:rect];
        self.statusImageView.hidden = YES;
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.statusLabel.numberOfLines = 0;
        self.statusLabel.font = FONT;
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        
//        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
//        effe.frame = rect;
        
        self.hudView = [[UIView alloc]init];
        self.hudView.layer.cornerRadius = 8;
        self.hudView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        [self.hudView addSubview:self.activityIndicatorImageView];
        [self.hudView addSubview:self.statusLabel];
        [self.hudView addSubview:self.statusImageView];
        [self addSubview:self.hudView];
        
        self.targetView = view;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

#pragma mark 开始一项等待工作
- (void)startWork:(NSString *)workName
{
    if (self.activityIndicatorImageView.hidden == YES)
    {
        self.activityIndicatorImageView.hidden = NO;
        [self imageAnimation];
        self.statusImageView.hidden = YES;
    }
    [self calculateContentSize:workName];
}

- (void)calculateContentSize:(NSString *) workName
{
    if (self.superview == nil)
    {
        self.frame = self.targetView.bounds;
        [self.targetView addSubview:self];
        self.alpha = 1.0f;
    }
    CGSize size = [workName boundingRectWithSize:CGSizeMake(HUDWIDTH - 2 * SPACE, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT,NSFontAttributeName, nil] context:NULL].size;
    CGFloat height = (size.height < LABELHEIGHT) ? LABELHEIGHT : size.height;
    self.statusLabel.text = workName;
    self.statusLabel.frame = CGRectMake(SPACE, SPACE * 2 + STATUSIMAGEWIDTH, HUDWIDTH - 2 * SPACE, size.height);
    self.hudView.frame = CGRectMake(0, 0, HUDWIDTH, 3 * SPACE + STATUSIMAGEWIDTH + height);
    
    CGPoint windowCenter = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    self.hudView.center = [self convertPoint:windowCenter fromView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark 工作结束，显示失败或成功
- (void)hideHudWithSuccess:(NSString *)successString andDuration:(NSTimeInterval)duration
{
    [self startWork:successString];
    [self hideStatusView:NO andDuration:duration];
}

- (void)hideHudWIthFailure:(NSString *)failureString andDuration:(NSTimeInterval)duration
{
    NSRange range = [failureString rangeOfString:@"请求超时"];
    if ((range.length > 0) && (range.location != NSNotFound)) {
        failureString = @"请求超时";
    }
    NSRange range2 = [failureString rangeOfString:@"互联网的连接"];
    if ((range2.length > 0) && (range2.location != NSNotFound)) {
        failureString = @"网络连接失败,请稍后重试";
    }
    
    [self startWork:failureString];
    [self hideStatusView:YES andDuration:duration];
}

#pragma mark 直接显示提示信息
- (void)showHudWithSuccess:(NSString *)successString andDuration:(NSTimeInterval)duration
{
    [self startWork:successString];
    [self hideStatusView:NO andDuration:duration];
}

- (void)showHudWithFailure:(NSString *)failureString andDuration:(NSTimeInterval)duration
{
    NSRange range = [failureString rangeOfString:@"请求超时"];
    if ((range.length > 0) && (range.location != NSNotFound)) {
        failureString = @"请求超时";
    }
    
    NSRange range2 = [failureString rangeOfString:@"互联网的连接"];
    if ((range2.length > 0) && (range2.location != NSNotFound)) {
        failureString = @"网络连接失败,请稍后重试";
    }
    
    [self startWork:failureString];
    [self hideStatusView:YES andDuration:duration];
}

#pragma mark 隐藏
- (void)hideStatusView:(BOOL) isError andDuration:(NSTimeInterval)duration
{
    self.activityIndicatorImageView.hidden = YES;
    self.statusImageView.hidden = NO;
    if (isError)
        self.statusImageView.image = [UIImage imageNamed:@"alert_error_icon"];
    else
        self.statusImageView.image = [UIImage imageNamed:@"alert_success_icon"];
    
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}

- (void)timerFired
{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.alpha = 0.0;
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)hideHudImmediately
{
    if (self.superview)
    {
        [self.activityIndicatorImageView.layer removeAllAnimations];
        self.activityIndicatorImageView.hidden = YES;
        [self removeFromSuperview];
    }
}

- (void)imageAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.toValue = [NSNumber numberWithDouble:M_PI_2];
	animation.duration = 0.2f;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [self.activityIndicatorImageView.layer addAnimation:animation forKey:@"activityIndicatorAnimation"];
}

- (void)resumeAnimation
{
    if (self.superview)
    {
        [self imageAnimation];
    }
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
