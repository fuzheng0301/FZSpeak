//
//  ISEResultReadSentence.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/7.
//
//

#import "ISEResultReadSentence.h"
#import "ISEResultTools.h"

@implementation ISEResultReadSentence

-(instancetype)init{
    if(self=[super init]){
        self.category=@"read_sentence";
    }
    return self;
}

-(NSString*) toString{
    NSString* buffer = [[NSString alloc] init];
    
    if ([@"cn" isEqualToString:self.language]) {
        buffer=[buffer stringByAppendingFormat:@"[ISE Results]\n"];
        buffer=[buffer stringByAppendingFormat:@"Content：%@\n" ,self.content];
        buffer=[buffer stringByAppendingFormat:@"Duration：%d\n",self.time_len];
        buffer=[buffer stringByAppendingFormat:@"Total Score：%f\n",self.total_score];
        buffer=[buffer stringByAppendingFormat:@"[Read Details]：%@\n",[ISEResultTools formatDetailsForLanguageCN:self.sentences]];
        
    } else {
        if (self.is_rejected) {
             buffer=[buffer stringByAppendingFormat:@"Dirty Read，"];
            
             buffer=[buffer stringByAppendingFormat:@"except_info:%@\n\n",self.except_info];
        }
        
        buffer=[buffer stringByAppendingFormat:@"[ISE Results]\n"];
        buffer=[buffer stringByAppendingFormat:@"Content：%@\n",self.content];
//        buffer=[buffer stringByAppendingFormat:@"Duration：%d\n",self.time_len];
        buffer=[buffer stringByAppendingFormat:@"Total Score：%f\n",self.total_score];
        buffer=[buffer stringByAppendingFormat:@"[Read Details]：%@\n",[ISEResultTools formatDetailsForLanguageEN:self.sentences]];
    }
    
    return buffer;
}

@end
