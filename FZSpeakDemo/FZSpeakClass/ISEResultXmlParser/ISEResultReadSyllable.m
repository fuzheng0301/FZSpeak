//
//  ISEResultReadSyllable.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/7.
//
//

#import "ISEResultReadSyllable.h"
#import "ISEResultTools.h"

@implementation ISEResultReadSyllable


-(instancetype)init{
    if(self=[super init]){
        self.category = @"read_syllable";
        self.language = @"cn";
    }
    return self;
}

-(NSString*) toString{
    NSString* buffer = [[NSString alloc] init];

    buffer=[buffer stringByAppendingFormat:@"[ISE Results]\n"];
    buffer=[buffer stringByAppendingFormat:@"Content：%@\n" ,self.content];
    buffer=[buffer stringByAppendingFormat:@"Duration：%d\n",self.time_len];
    buffer=[buffer stringByAppendingFormat:@"Total Score：%f\n",self.total_score];
    buffer=[buffer stringByAppendingFormat:@"[Read Details]：%@\n",[ISEResultTools formatDetailsForLanguageCN:self.sentences]];

    return buffer;
}

@end
