//
//  ViewController.m
//  FZSpeakDemo
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//

#import "ViewController.h"
#import "FZSpeakClass.h"
#import "FZProgressHudView.h"

@interface ViewController ()
{
	UITextView *textV;
	NSString *textVStr;
}

@property (nonatomic, strong) FZProgressHudView *hudView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.hudView = [[FZProgressHudView alloc] initWithTargetView:[[[UIApplication sharedApplication] windows] lastObject]];
	
	textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 150)];
	textV.layer.borderWidth = 0.5;
	textV.layer.borderColor = [UIColor lightGrayColor].CGColor;
	textV.text = @"百度一下，你就知道。";
	[self.view addSubview:textV];
	
	textVStr = @"";
	
	NSArray *titleArr = @[@"语音合成",@"语音评测",@"语音听写"];
	for (int i = 0; i < titleArr.count; i++) {
		UIButton *btn = [self buttonWithTitle:titleArr[i] frame:CGRectMake(10+i*(10+(SCREEN_WIDTH-40)/3), 180, (SCREEN_WIDTH-40)/3, 40) action:@selector(didClickBtn:) AddView:self.view];
		btn.tag = 1000+i;
	}
}

-(void)didClickBtn:(UIButton *)btn
{
	if (btn.tag == 1000) {
		//语音合成
		[self audioSynthesiz];
	} else if (btn.tag == 1001) {
		//语音评测
		[self AudioEvaluation];
	} else {
		//语音听写
		[self AudioRecognizerResult];
	}
}

#pragma mark --- 语音评测
-(void)AudioEvaluation
{
	//语音评测
	[FZSpeechEvaluator xf_AudioEvaluationOfText:textV.text callback:^(XF_Audio_Evaluation_Type type, float progress, NSString *resultMsg) {
		if (type == XF_Audio_Evaluation_Begain) {
			//开始录音
			[self.hudView startWork:@"开始录音"];
		} else if (type == XF_Audio_Evaluation_Volume) {
			//录音音量
			[self.hudView startWork:[NSString stringWithFormat:@"录音音量：%ld",(long)progress]];
		} else if (type == XF_Audio_Evaluation_End) {
			//停止录音
			[self.hudView startWork:@"停止录音"];
		} else if (type == XF_Audio_Evaluation_Cancel) {
			//取消录音
			[self.hudView startWork:@"取消录音"];
		} else if (type == XF_Audio_Evaluation_Result) {
			//评测结果
			if (progress == 0) {
				[self.hudView showHudWithFailure:@"你好像读的不对哦" andDuration:1.2];
			} else {
				[self.hudView showHudWithSuccess:[NSString stringWithFormat:@"评测“%@”结果评分：%.2f",resultMsg,progress] andDuration:2.0];
			}
		} else {
			//评测出错
			if (progress != 0) {
				[self.hudView showHudWithFailure:[NSString stringWithFormat:@"评测出错：code=%.2f，msg=%@",progress,resultMsg] andDuration:1.0];
			}
		}
	}];
}

#pragma mark --- 语音听写
-(void)AudioRecognizerResult
{
	//语音听写
	[self.hudView startWork:@"请讲话"];
	[FZSpeechRecognizer xf_AudioRecognizerResult:^(NSString *resText, NSError *error) {
		if (!error) {
			self->textVStr = [NSString stringWithFormat:@"%@%@",self->textVStr,resText];
			self->textV.text = self->textVStr;
			[self.hudView showHudWithSuccess:resText andDuration:2.0];
		} else {
			[self.hudView showHudWithFailure:[NSString stringWithFormat:@"eroorCode:%ld eroorMsg:%@",(long)[error code],[error localizedDescription]] andDuration:1.0];
		}
	}];
}

#pragma mark --- 语音合成
-(void)audioSynthesiz
{
	//语音合成
	[FZSpeechSynthesizer xf_AudioSynthesizeOfText:textV.text fromPeople:@"xiaoyan" callback:^(XF_Audio_Synthesize_Type type, NSInteger progress) {
		if (type == XF_Audio_Synthesize_Progress) {
			//语音合成进度
			[self.hudView startWork:[NSString stringWithFormat:@"正在合成,进度：%ld / 100",progress]];
		} else if (type == XF_Audio_Speak_Begain) {
			//开始播放
			[self.hudView startWork:@"开始播放"];
		} else if (type == XF_Audio_Speak_Progress) {
			//播放进度
			[self.hudView startWork:[NSString stringWithFormat:@"正在播放，进度：%ld / 100",progress]];
		} else {
			//播放结束
			[self.hudView showHudWithSuccess:@"播放结束" andDuration:0.5];
		}
	}];
}

#pragma mark --- 创建button公共方法
/**使用示例:[self buttonWithTitle:@"点 击" frame:CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 40)/3, 150, 40) action:@selector(didClickButton) AddView:self.view];*/
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	button.frame = frame;
	button.backgroundColor = [UIColor lightGrayColor];
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
	[view addSubview:button];
	return button;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
