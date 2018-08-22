//
//  ISEResultFinal.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/3/7.
//
//

#import "ISEResultFinal.h"

@implementation ISEResultFinal

-(NSString*) toString{
    NSString* resultString=[NSString stringWithFormat:@"Returned Value：%d，Total Score：%f",self.ret,self.total_score];
    return resultString;
}

@end
