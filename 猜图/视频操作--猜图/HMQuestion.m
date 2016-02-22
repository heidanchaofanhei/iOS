      //
//  HMQuestion.m
//  视频操作--猜图
//
//  Created by Shenglin on 16/1/11.
//  Copyright © 2016年 Shenglin. All rights reserved.
//

#import "HMQuestion.h"

@implementation HMQuestion

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

//+ (NSArray *)questions{
//    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil]];
//    NSMutableArray *arrayM = [NSMutableArray array];
//    for (NSDictionary *dict in array) {
//        [arrayM addObject:[self questionWithDict:dict]];
//    }
//    return arrayM;
//}

+ (NSArray *)questions{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrM addObject:[self questionWithDict:dict]];
    }
    return arrM;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ :%p----<answer :%@,titile :%@,icon :%@,options :%@",self.class,self,self.answer,self.title,self.icon,self.options];
}

@end
