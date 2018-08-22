//
//  ISEResultSyll.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import <Foundation/Foundation.h>

/**
 *  The lable of Syll in xml results
 */
@interface ISEResultSyll : NSObject

/**
 * Beginning of frame，10ms per frame
 */
@property(nonatomic, assign)int beg_pos;

/**
 * End of frame
 */
@property(nonatomic, assign)int end_pos;

/**
 * Content of Syll
 */
@property(nonatomic, strong)NSString* content;

/**
 * Pin Yin（cn），number represents tone，5 represents light tone，for example, fen1
 */
@property(nonatomic, strong)NSString* symbol;

/**
 * Read message：0（Right），16（Skip），32（Duplicate），64（Readback），128（Replace）
 */
@property(nonatomic, assign)int dp_message;

/**
 * Duration（cn）
 */
@property(nonatomic, assign)int time_len;

/**
 * Phonetic array in Syll
 */
@property(nonatomic, strong)NSMutableArray* phones;

/**
 * Get the standard phonetic symbol of content（en）
 */
- (NSString*) getStdSymbol;

@end
