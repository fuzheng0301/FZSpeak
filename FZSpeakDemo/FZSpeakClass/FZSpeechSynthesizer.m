//
//  FZSpeechSynthesizer.m
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//

#import "FZSpeechSynthesizer.h"

@interface FZSpeechSynthesizer()<IFlySpeechSynthesizerDelegate>

@property(nonatomic, copy) NSString *people;

@end

@implementation FZSpeechSynthesizer

+ (instancetype)sharedInstance {
	static id sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

#pragma mark --- 语音合成
/**
 * 懒加载getter方法
 */
- (IFlySpeechSynthesizer *)iFlySpeechSynthesizer {
	if(!_iFlySpeechSynthesizer) {
		// 初始化语音合成
		_iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
		_iFlySpeechSynthesizer.delegate = self;
		// 语速【0-100】
		[_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
		// 音量【0-100】
		[_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
		// 发音人【小燕：xiaoyan；小宇：xiaoyu；凯瑟琳：catherine；亨利：henry；玛丽：vimary；小研：vixy；小琪：vixq；小峰：vixf；小梅：vixl；小莉：vixq；小蓉(四川话)：vixr；小芸：vixyun；小坤：vixk；小强：vixqa；小莹：vixying；小新：vixx；楠楠：vinn；老孙：vils】
		if (!_people) {
			_people = @"xiaoyan";
		}
		[_iFlySpeechSynthesizer setParameter:_people forKey:[IFlySpeechConstant VOICE_NAME]];
		// 音频采样率【8000或16000】
		[_iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
		// 保存音频路径(默认在Document目录下)
		[_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
		//文本编码格式
		[_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
	}
	return _iFlySpeechSynthesizer;
}

#pragma mark --- 合成语音
+ (void)xf_AudioSynthesizeOfText:(NSString *)text callback:(void (^)(XF_Audio_Synthesize_Type type,NSInteger progress))callback
{
	// 1.开始合成说话
	[[FZSpeechSynthesizer sharedInstance].iFlySpeechSynthesizer startSpeaking:text];
	[FZSpeechSynthesizer sharedInstance].xf_syncallback = callback;
}
+ (void)xf_AudioSynthesizeOfText:(NSString *)text fromPeople:(NSString *)people callback:(void (^)(XF_Audio_Synthesize_Type type,NSInteger progress))callback
{
	[[FZSpeechSynthesizer sharedInstance] setPeople:people];
	[FZSpeechSynthesizer xf_AudioSynthesizeOfText:text callback:nil];
	[FZSpeechSynthesizer sharedInstance].xf_syncallback = callback;
}

/*!
 *  暂停/恢复播放<br>
 *  暂停播放之后，合成不会暂停，仍会继续，如果发生错误则会回调错误`onCompleted`
 *	自动判断是否是暂停状态，如果是暂停，调用后恢复播放；如果是播放，调用后暂停播放。
 */
- (void)resumeOrPauseSpeaking
{
	if (_iFlySpeechSynthesizer.isSpeaking) {
		[_iFlySpeechSynthesizer pauseSpeaking];
	} else {
		[_iFlySpeechSynthesizer resumeSpeaking];
	}
}

/*!
 *  停止播放并停止合成
 */
- (void)stopSpeaking
{
	if (_iFlySpeechSynthesizer.isSpeaking) {
		[_iFlySpeechSynthesizer stopSpeaking];
	}
}

/**
 * 设置发音人
 */
- (void)setPeople:(NSString *)people {
	_people = people;
	_iFlySpeechSynthesizer = nil;
}

#pragma mark --- 语音合成代理方法
/**
 * 合成缓冲进度【0-100】
 */
- (void)onBufferProgress:(int)progress message:(NSString *)msg {
	NSLog(@"合成缓冲进度：%d/100",progress);
	if ([FZSpeechSynthesizer sharedInstance].xf_syncallback != nil) {
		[FZSpeechSynthesizer sharedInstance].xf_syncallback(0,progress);
	}
}
/**
 * 合成开始
 */
- (void)onSpeakBegin {
	NSLog(@"合成播放开始！");
	if ([FZSpeechSynthesizer sharedInstance].xf_syncallback != nil) {
		[FZSpeechSynthesizer sharedInstance].xf_syncallback(1,0);
	}
}
/**
 * 合成播放进度【0-100】
 */
- (void)onSpeakProgress:(int)progress beginPos:(int)beginPos endPos:(int)endPos {
	NSLog(@"合成播放进度：%d/100",progress);
	if ([FZSpeechSynthesizer sharedInstance].xf_syncallback != nil) {
		[FZSpeechSynthesizer sharedInstance].xf_syncallback(2,progress);
	}
}
/**
 * 合成结束
 */
- (void)onCompleted:(IFlySpeechError *)error {
	NSLog(@"合成结束！");
	//语音合成
	if ([FZSpeechSynthesizer sharedInstance].xf_syncallback != nil) {
		[FZSpeechSynthesizer sharedInstance].xf_syncallback(3,100);
	}
}

@end
