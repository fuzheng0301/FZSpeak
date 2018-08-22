//
//  ISEResultPhone.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/6.
//
//

#import "ISEResultPhone.h"
#import "ISEResultTools.h"

@implementation ISEResultPhone

/**
 * Get the standard phonetic symbol of content（en）
 */
- (NSString*) getStdSymbol{
    
    if(self.content){
        NSString* stdSymbol=[ISEResultTools toStdSymbol:self.content];
        return stdSymbol?stdSymbol:self.content;
    }
    
    return self.content;
}

@end
