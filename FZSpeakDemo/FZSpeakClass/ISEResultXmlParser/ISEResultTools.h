//
//  ISEResultTools.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString* const KCIFlyResultNormal;
FOUNDATION_EXPORT NSString* const KCIFlyResultMiss;
FOUNDATION_EXPORT NSString* const KCIFlyResultAdd;
FOUNDATION_EXPORT NSString* const KCIFlyResultRepeat;
FOUNDATION_EXPORT NSString* const KCIFlyResultReplace;

FOUNDATION_EXPORT NSString* const KCIFlyResultNoise;
FOUNDATION_EXPORT NSString* const KCIFlyResultMute;


@interface ISEResultTools : NSObject

/*!
 *  Get the standard phonetic symbol of symbol
 *
 *  @param symbol iFlytek phonetic symbol
 *
 *  @return if not exit,return symbol itself
 */
+(NSString*) toStdSymbol:(NSString*) symbol;


/*!
 *  Get the message of dpMessage
 */
+ (NSString*)translateDpMessageInfo:(int)dpMessage;

/*!
 *  Get the message of content
 */
+ (NSString*)translateContentInfo:(NSString*) content;


/**
 * Get the format details from sentences in chinese
 *
 * @param sentences sentences in chinese
 * @return the format details
 */
+ (NSString*)formatDetailsForLanguageCN:(NSArray*) sentences ;

/**
 * Get the format details from sentences in english
 *
 * @param sentences sentences in english
 * @return the format details
 */
+ (NSString*)formatDetailsForLanguageEN:(NSArray*) sentences ;

@end
