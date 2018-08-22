//
//  ISEResult.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import <Foundation/Foundation.h>

/**
 *  ISE Result
 */
@interface ISEResult : NSObject

/**
 * Language：English（en）、Chinese（cn）
 */
@property(nonatomic,strong)NSString* language;

/**
 * Category：read_syllable（cn）、read_word、read_sentence
 */
@property(nonatomic,strong)NSString* category;

/**
 * Beginning of frame，10ms per frame
 */
@property(nonatomic,assign)int beg_pos;

/**
 * End of frame
 */
@property(nonatomic,assign)int end_pos;

/**
 * Content of ISE
 */
@property(nonatomic,strong)NSString* content;

/**
 * Total score
 */
@property(nonatomic,assign)float total_score;

/**
 * Duration（cn）
 */
@property(nonatomic,assign)int time_len;

/**
 * Exception info（en）
 */
@property(nonatomic,strong)NSString* except_info;

/**
 * Whether or not dirty read（cn）
 */
@property(nonatomic,assign)BOOL is_rejected;

/**
 * The lable of sentence in xml results
 */
@property(nonatomic,strong)NSMutableArray* sentences;

-(NSString*) toString;

@end
