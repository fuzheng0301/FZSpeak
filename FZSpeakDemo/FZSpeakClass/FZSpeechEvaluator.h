//
//  FZSpeechEvaluator.h
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//
//	语音评测

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h> // 引入讯飞语音库

typedef enum : NSUInteger {
	XF_Audio_Evaluation_Begain = 0,	//开始录音
	XF_Audio_Evaluation_Volume,		//录音音量
	XF_Audio_Evaluation_End,		//停止录音
	XF_Audio_Evaluation_Cancel,		//取消录音
	XF_Audio_Evaluation_Result,		//评测结果
	XF_Audio_Evaluation_Error,		//评测失败
} XF_Audio_Evaluation_Type;	//语音测评状态

typedef void (^XFAudioEvaCallback)(XF_Audio_Evaluation_Type type, float progress, NSString *resultMsg);

@interface FZSpeechEvaluator : NSObject

@property (nonatomic, assign) XF_Audio_Evaluation_Type evaluationType;

@property(nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;        // 定义语音测评对象

@property(nonatomic, copy) XFAudioEvaCallback xf_evacallback;

+ (instancetype)sharedInstance;

/**
 语音测评
 
 @param text 评测内容
 @param callback 评测结果返回
 */
+ (void)xf_AudioEvaluationOfText: (NSString *)text callback:(void(^)(XF_Audio_Evaluation_Type type, float progress, NSString *resultMsg))callback;

/*!
 *  停止录音<br>
 *  调用此函数会停止录音，并开始进行语音识别
 */
- (void)stopListening;

/*!
 *  取消本次会话
 */
- (void)cancel;

@end
