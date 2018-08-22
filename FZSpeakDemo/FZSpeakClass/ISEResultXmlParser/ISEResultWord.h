//
//  ISEResultWord.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import <Foundation/Foundation.h>

/**
 *  The lable of Word in xml results
 */
@interface ISEResultWord : NSObject

/**
 * Beginning of frame，10ms per frame
 */
@property(nonatomic, assign)int beg_pos;

/**
 * End of frame
 */
@property(nonatomic, assign)int end_pos;

/**
 * Content of Word
 */
@property(nonatomic, strong)NSString* content;

/**
 * Read message：0（Right），16（Skip），32（Duplicate），64（Readback），128（Replace）
 */
@property(nonatomic, assign)int dp_message;

/**
 * The index of Word in chapter（en）
 */
@property(nonatomic, assign)int global_index;

/**
 * The index of Word in sentense（en）
 */
@property(nonatomic, assign)int index;

/**
 * Pin Yin（cn），number represents tone，5 represents light tone，for example, fen1
 */
@property(nonatomic, strong)NSString* symbol;

/**
 * Duration（cn）
 */
@property(nonatomic, assign)int time_len;

/**
 * Total score（en）
 */
@property(nonatomic, assign)float total_score;

/**
 * Syll array in Word
 */
@property(nonatomic, strong)NSMutableArray* sylls;

@end
