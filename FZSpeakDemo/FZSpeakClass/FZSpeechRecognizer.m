//
//  FZSpeechRecognizer.m
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//

#import "FZSpeechRecognizer.h"

@interface FZSpeechRecognizer()<IFlySpeechRecognizerDelegate>

@end

@implementation FZSpeechRecognizer

+ (instancetype)sharedInstance {
	static id sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

#pragma mark --- 语音听写
- (IFlySpeechRecognizer *)iFlySpeechRecognizer {
	if (!_iFlySpeechRecognizer) {
		_iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
		_iFlySpeechRecognizer.delegate = self;
		// 设置听写模式
		[_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
		// 设置录音保存文件名
		[_iFlySpeechRecognizer setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
		//set timeout of recording
		[_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
		//set VAD timeout of end of speech(EOS)
		[_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
		//set VAD timeout of beginning of speech(BOS)
		[_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
		//set network timeout
		[_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
	}
	return _iFlySpeechRecognizer;
}

#pragma mark --- 语音听写
+ (void)xf_AudioRecognizerResult:(void(^)(NSString *resText,NSError *error))callback
{
	// 3.开始语音听写
	[[FZSpeechRecognizer sharedInstance].iFlySpeechRecognizer startListening];
	[FZSpeechRecognizer sharedInstance].xf_recogcallback = callback;
}

/*!
 *  停止录音<br>
 *  调用此函数会停止录音，并开始进行语音识别
 */
- (void) stopListening
{
	[_iFlySpeechRecognizer stopListening];
}

/*!
 *  取消本次会话
 */
- (void) cancel
{
	[_iFlySpeechRecognizer cancel];
}

/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述
 */
- (void) onCompleted:(IFlySpeechError *) errorCode
{
	NSLog(@"听写出错");
	if (errorCode.errorCode == 0) {
		return;
	}
	NSString *desc = NSLocalizedString(@"fzh.correctSpeak", @"");
	NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
	NSError *resultError = [NSError errorWithDomain:errorCode.errorDesc
										 code:errorCode.errorCode
									 userInfo:userInfo];
	[FZSpeechRecognizer sharedInstance].xf_recogcallback(nil,resultError);
}

/*!
 *  识别结果回调
 *
 *  在识别过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。<br>
 *  使用results的示例如下：
 *  <pre><code>
 *  - (void) onResults:(NSArray *) results{
 *     NSMutableString *result = [[NSMutableString alloc] init];
 *     NSDictionary *dic = [results objectAtIndex:0];
 *     for (NSString *key in dic){
 *        [result appendFormat:@"%@",key];//合并结果
 *     }
 *   }
 *  </code></pre>
 *
 *  @param results  -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度。
 *  @param isLast   -[out] 是否最后一个结果
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
	NSLog(@"听写结果");
	NSMutableString *resultString = [[NSMutableString alloc] init];
	NSDictionary *dic = results[0];
	
	for (NSString *key in dic) {
		[resultString appendFormat:@"%@",key];
	}
	
	NSString * resultFromJson =  [self stringFromJson:resultString];
	
	NSLog(@"听到的结果：%@",resultFromJson);
	if (resultFromJson.length == 0) {
		resultFromJson = @"什么都没听到呢";
	}
	[FZSpeechRecognizer sharedInstance].xf_recogcallback(resultFromJson,nil);
}

#pragma mark --- 解析听到语音内容
/**
 parse JSON data
 params,for example：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 **/
- (NSString *)stringFromJson:(NSString*)params
{
	if (params == NULL) {
		return nil;
	}
	
	NSMutableString *tempStr = [[NSMutableString alloc] init];
	NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
								[params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
	
	if (resultDic!= nil) {
		NSArray *wordArray = [resultDic objectForKey:@"ws"];
		
		for (int i = 0; i < [wordArray count]; i++) {
			NSDictionary *wsDic = [wordArray objectAtIndex: i];
			NSArray *cwArray = [wsDic objectForKey:@"cw"];
			
			for (int j = 0; j < [cwArray count]; j++) {
				NSDictionary *wDic = [cwArray objectAtIndex:j];
				NSString *str = [wDic objectForKey:@"w"];
				[tempStr appendString: str];
			}
		}
	}
	return tempStr;
}

@end
