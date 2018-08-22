//
//  FZSpeechRecognizer.h
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//
//	语音听写

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h> // 引入讯飞语音库

typedef void (^XFAudioRecognizerCallback)(NSString *resText,NSError *eroor);

@interface FZSpeechRecognizer : NSObject

@property(nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;      // 定义语音听写对象

@property(nonatomic, copy) XFAudioRecognizerCallback xf_recogcallback;

+ (instancetype)sharedInstance;

/**
 语音听写
 
 @param callback 听写结果回调
 */
+ (void)xf_AudioRecognizerResult: (void(^)(NSString *resText,NSError *error))callback;

/*!
 *  停止录音<br>
 *  调用此函数会停止录音，并开始进行语音识别
 */
- (void) stopListening;

/*!
 *  取消本次会话
 */
- (void) cancel;

@end
