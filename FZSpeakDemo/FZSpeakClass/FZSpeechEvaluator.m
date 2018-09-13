//
//  FZSpeechEvaluator.m
//  CorrectSpeak
//
//  Created by 付正 on 2018/8/15.
//  Copyright © 2018年 付正. All rights reserved.
//

#import "FZSpeechEvaluator.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"

@interface FZSpeechEvaluator()<IFlySpeechEvaluatorDelegate,ISEResultXmlParserDelegate,UIAlertViewDelegate>

@end

@implementation FZSpeechEvaluator

+ (instancetype)sharedInstance {
	static id sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

#pragma mark --- 语音测评
/**
 * 懒加载getter方法
 */
- (IFlySpeechEvaluator *)iFlySpeechEvaluator {
	if (!_iFlySpeechEvaluator) {
		// 初始化语音测评
		_iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
		_iFlySpeechEvaluator.delegate = self;
		// 设置测评语种【中文：zh_cn，中文台湾：zh_tw，美英：en_us】
		[_iFlySpeechEvaluator setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
		// 设置测评题型【read_syllable(英文评测不支持):单字;read_word:词语;read_sentence:句子;read_chapter(待开放):篇章】
		[_iFlySpeechEvaluator setParameter:@"read_sentence" forKey:[IFlySpeechConstant ISE_CATEGORY]];
		// 设置试题编码类型
		[_iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
		// 设置前、后端点超时【0-10000(单位ms)】
		[_iFlySpeechEvaluator setParameter:@"5000" forKey:[IFlySpeechConstant VAD_BOS]]; // 默认5000ms
		[_iFlySpeechEvaluator setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]]; // 默认1800ms
		// 设置录音超时，设置成-1则无超时限制(单位：ms，默认30000)
		[_iFlySpeechEvaluator setParameter:@"-1" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
		// 设置结果等级，不同等级对应不同的详细程度【complete：完整 ；plain：简单】
		[_iFlySpeechEvaluator setParameter:@"complete" forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
	}
	return _iFlySpeechEvaluator;
}

#pragma mark --- 语音评测
+ (void)xf_AudioEvaluationOfText:(NSString *)text callback:(void (^)(XF_Audio_Evaluation_Type type, float progress, NSString *resultMsg))callback
{
	// 2.开始语音测评
//	NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
	Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
	NSMutableData *buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
	[buffer appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
	[[FZSpeechEvaluator sharedInstance].iFlySpeechEvaluator startListening:buffer params:nil];
	
	[FZSpeechEvaluator sharedInstance].xf_evacallback = callback;
}

/*!
 *  停止录音<br>
 *  调用此函数会停止录音，并开始进行语音识别
 */
- (void)stopListening
{
	[_iFlySpeechEvaluator stopListening];
}

/*!
 *  取消本次会话
 */
- (void)cancel
{
	[_iFlySpeechEvaluator cancel];
}

/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer
{
	NSLog(@"音量...");
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_Volume,volume,nil);
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onCompleted:函数
 */
- (void)onBeginOfSpeech
{
	NSLog(@"开始录音");
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_Begain,0,nil);
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onCompleted:函数
 */
- (void)onEndOfSpeech
{
	NSLog(@"停止录音");
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_End,100,nil);
}

/*!
 *  正在取消
 */
- (void)onCancel
{
	NSLog(@"正在取消");
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_Cancel,100,nil);
}

/*!
 *  评测错误回调
 *
 *  在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onCompleted:(IFlySpeechError *)errorCode
{
	NSLog(@"评测错误");
	if(errorCode && errorCode.errorCode!=0){
		NSLog(@"Error：%d %@",[errorCode errorCode],[errorCode errorDesc]);
	}
	if (errorCode.errorCode == 20001) {
		//没有网络
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"需要访问网络" message:@"请在系统设置中开启网络服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
		[alertView show];
		return;
	}
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_Error,errorCode.errorCode,errorCode.errorDesc);
}

/*!
 *  评测结果回调<br>
 *  在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast
{
	NSLog(@"评测结果");
	NSString *showText = @"";
	
	const char* chResult=[results bytes];
	
	BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
	NSString* strResults=nil;
	if(isUTF8){
		strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
	}else{
		NSLog(@"result encoding: gb2312");
		NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
		strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
	}
	if(strResults){
		showText = [showText stringByAppendingString:strResults];
	}
	NSLog(@"评测结果：%@",showText);
	
	ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
	parser.delegate=self;
	[parser parserXml:showText];
}

#pragma mark - ISEResultXmlParserDelegate
-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
	
}

-(void)onISEResultXmlParserResult:(ISEResult*)result
{
	NSLog(@"----%@",[result toString]);
	
	NSDictionary *resultDic = [self returnResultDicWithResultStr: [result toString]];
	float resultScore = [[resultDic objectForKey:@"Total Score"] floatValue];
	resultScore = resultScore*20;
	[FZSpeechEvaluator sharedInstance].xf_evacallback(XF_Audio_Evaluation_Result,resultScore,[resultDic objectForKey:@"Content"]);
}

#pragma mark --- 解析结果
-(NSDictionary *)returnResultDicWithResultStr:(NSString *)resultStr
{
	NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]init];
	//分割整体和局部
	NSArray *allArr = [resultStr componentsSeparatedByString:@"[Read Details]："];
	//解析外部整体解析结果部分
	NSArray *totalArr = [allArr[0] componentsSeparatedByString:@"[ISE Results]"];
	NSMutableArray *totalArray = [NSMutableArray arrayWithArray:[[totalArr[1] stringByReplacingOccurrencesOfString:@"\n" withString:@"："] componentsSeparatedByString:@"："]];
	[totalArray removeObjectAtIndex:0];
	[totalArray removeObjectAtIndex:totalArray.count-1];
	for (int i = 0; i < totalArray.count; i++) {
		[resultDict setObject:totalArray[i+1] forKey:totalArray[i]];
		i++;
	}
	//解析局部数据结果部分
	NSArray *bodyArr = [allArr[1] componentsSeparatedByString:@"\n\n"];
	NSMutableArray *bodyArray = [[NSMutableArray alloc]init];
	for (int i = 0; i < bodyArr.count-1; i++) {
		NSString *str = [bodyArr[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSArray *arr = [str componentsSeparatedByString:@"└"];
		NSString *bodyResult = arr[0];
		NSArray *bodyStr = [bodyResult componentsSeparatedByString:@" "];
		NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc]init];
		[bodyDict setObject:[bodyResult substringWithRange:NSMakeRange(5, 1)] forKey:@"word"];
		[bodyDict setObject:bodyStr[1] forKey:@"pinyin"];
		[bodyDict setObject:[bodyStr[3] substringWithRange:NSMakeRange(4, 1)] forKey:@"Dur"];
		[bodyArray addObject:bodyDict];
	}
	
	[resultDict setObject:bodyArray forKey:@"bodyList"];
	
	return resultDict;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		if( [[UIApplication sharedApplication]canOpenURL:url] ) {
			[[UIApplication sharedApplication]openURL:url];
		}
	}
}

@end
