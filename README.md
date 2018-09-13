# FZSpeak
语音听写、语音评测、语音合成

# 目录
1. [引言](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#引言)
2. [前言](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#前言)
3. [正文](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#正文)
4. [集成](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#集成)
5. [语音听写](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#语音听写)
6. [语音评测](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#语音评测)
7. [语音合成](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#语音合成)
8. [尾声](https://github.com/fuzheng0301/FZSpeak/blob/master/README.md#尾声)


## 引言
```
子弹短信，不仅支持语音输入、文本输入，同时还支持“语音输入、文字输出”。
```

## 前言
之前在讯飞人脸识别的基础上做了[活体人脸识别](https://github.com/fuzheng0301/FaceRecognition)，并在当时没有免费活体识别的大环境下，本着程序猿的互联网精神，在Git上第一个站出来开源出来，感谢大家的支持。

后来也一直打算拿出来讯飞的语音识别，做些事情方便大家，初衷是想做一款读书软件，后来拖延症晚期患者一直没上手。今年7月份偶然参加了一个活动，需要做一款APP参赛，后来决定做一个语音识别方面的，又重新找回讯飞语音识别，做了一个语音方面的APP。

赶巧制作过程中听闻锤子公司出了“子弹短信”，也是使用了语音识别的功能，想来后续会有很多同胞会应用到语音方面内容，故做完APP后，赶紧过来开源分享给大家。

## 正文
本次开源的语音识别是在讯飞语音的基础上，重新封装了语音评测、语音听写、语音朗读三个功能，集成更方便，使用更便捷。下面仍从集成和使用方面来讲解。

### 集成
集成可以参考[讯飞语音识别官方集成API](https://doc.xfyun.cn/msc_ios/%E9%9B%86%E6%88%90%E6%B5%81%E7%A8%8B.html)。同时在APP中需要首先初始化语音识别功能。

```
NSString*initString = [[NSStringalloc]initWithFormat:@"appid=%@",@"讯飞平台注册APPID"];

[IFlySpeechUtility createUtility:initString];
```
### 语音听写
语音听写功能用于识别输入语音，输出文字功能。

这里封装成了一个方法，通过Block回调识别结果resText和错误信息error。

```
/**
语音听写
@param callback 听写结果回调
*/
+ (void)xf_AudioRecognizerResult: (void(^)(NSString *resText,NSError *error))callback
```

### 语音评测
语音评测功能中，可以设置想要评测的内容，通过用户朗读内容，机器识别并对比评测，得到朗读评分。

这里把评测中的状态分了开始录音、录音音量、停止录音、取消录音、评测结果、评测失败 6种情况，在Block回调中可通过type获取状态，并进行判断。progress为各个状态情况下的数值，为0-100之间的有理数。resultMsg为评测结果、评测失败两种情况下返回的评测结果、失败内容。

```
/**
语音测评
@param text 评测内容
@param callback 评测结果返回
*/
+ (void)xf_AudioEvaluationOfText: (NSString*)text callback:(void(^)(XF_Audio_Evaluation_Type type,float progress,NSString *resultMsg))callback;
```

### 语音合成
语音合成即语音播报，给出内容，由机器朗读内容。

Block返回内容里type分为合成进度、开始播放、播放进度、播放结束四种合成状态。progress为各个阶段的进度值。

以下为默认播报语音发音人的方法：

```
/**
语音合成
@param text 合成内容
@param callback 回调结果
*/
+ (void)xf_AudioSynthesizeOfText: (NSString*)text callback:(void(^)(XF_Audio_Synthesize_Type type,NSInteger progress))callback;
```

以下为自定义语音发音人的语音合成调用方法:

```
/**
语音合成
@param text 合成内容
@param people 设置发音人
@param callback 回调结果
*/
+ (void)xf_AudioSynthesizeOfText: (NSString*)text fromPeople:(NSString*)people callback:(void(^)(XF_Audio_Synthesize_Typetype,NSIntegerprogress))callback;
```

## 尾声
如果能帮到大家，深感荣幸，感谢您的star。


