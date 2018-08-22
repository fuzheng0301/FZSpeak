//
//  ISEResultSentence.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import <Foundation/Foundation.h>

/**
 *  The lable of sentence in xml results
 */
@interface ISEResultSentence : NSObject

/**
 * Beginning of frame，10ms per frame
 */
@property(nonatomic, assign)int beg_pos;

/**
 * End of frame
 */
@property(nonatomic, assign)int end_pos;

/**
 * Content of Sentence
 */
@property(nonatomic, strong)NSString* content;

/**
 * Total score
 */
@property(nonatomic, assign)float total_score;

/**
 * Duration（cn）
 */
@property(nonatomic, assign)int time_len;

/**
 * The index of Sentence（en）
 */
@property(nonatomic, assign)int index;

/**
 * Count of words in Sentence（en）
 */
@property(nonatomic, assign)int word_count;

/**
 * Word array in Sentence
 */
@property(nonatomic, strong)NSMutableArray* words;

@end
