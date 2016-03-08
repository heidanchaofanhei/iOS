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
        [self random];
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

-(void)randomOtions
{
    self.options = [self.options sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int random = arc4random_uniform(2);
        if (random) {
            return [str1 compare:str2];
        }else{
            return [str2 compare:str1];
        }
    }];
    NSLog(@"%@",self.options);
}
- (void)random
{
    self.options = [self.options sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        }else{
            return [str2 compare:str1];
        }
    }];
}
@end
