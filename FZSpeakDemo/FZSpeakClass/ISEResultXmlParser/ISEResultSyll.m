//
//  ISEResultSyll.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import "ISEResultSyll.h"
#import "ISEResultTools.h"

@implementation ISEResultSyll

/**
 * Get the standard phonetic symbol of content（en）
 */
- (NSString*) getStdSymbol{

    NSArray* symbols=[self.content componentsSeparatedByString:@" "];
    NSString* stdSymbol=[[NSString alloc] init];
        
    for (int i = 0; i < [symbols count]; ++i) {
        stdSymbol = [stdSymbol stringByAppendingString:[ISEResultTools toStdSymbol:symbols[i]]];
    }
    
    return stdSymbol;
}

@end
