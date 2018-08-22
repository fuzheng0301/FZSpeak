//
//  FZSpeechSynthesizer.h
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//
//	语音合成

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h> // 引入讯飞语音库

typedef enum : NSUInteger {
	XF_Audio_Synthesize_Progress = 0,	//合成进度
	XF_Audio_Speak_Begain,				//开始播放
	XF_Audio_Speak_Progress,			//播放进度
	XF_Audio_Speak_End,					//播放结束
} XF_Audio_Synthesize_Type;	//语音合成

typedef void (^XFAudioSynCallback)(XF_Audio_Synthesize_Type type, NSInteger progress);

@interface FZSpeechSynthesizer : NSObject

@property(nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;    // 定义语音合成对象

@property(nonatomic, copy) XFAudioSynCallback xf_syncallback;

+ (instancetype)sharedInstance;

/**
 语音合成
 
 @param text 合成内容
 @param callback 回调结果
 */
+ (void)xf_AudioSynthesizeOfText: (NSString *)text callback:(void (^)(XF_Audio_Synthesize_Type type,NSInteger progress))callback;

/**
 语音合成
 
 @param text 合成内容
 @param people 设置发音人
 @param callback 回调结果
 */
+ (void)xf_AudioSynthesizeOfText: (NSString *)text fromPeople:(NSString *)people callback:(void (^)(XF_Audio_Synthesize_Type type,NSInteger progress))callback;

/*!
 *  暂停/恢复播放<br>
 *  暂停播放之后，合成不会暂停，仍会继续，如果发生错误则会回调错误`onCompleted`
 *	自动判断是否是暂停状态，如果是暂停，调用后恢复播放；如果是播放，调用后暂停播放。
 */
- (void) resumeOrPauseSpeaking;

/*!
 *  停止播放并停止合成
 */
- (void) stopSpeaking;

@end
