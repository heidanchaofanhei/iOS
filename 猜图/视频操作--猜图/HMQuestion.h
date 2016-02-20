//
//  HMQuestion.h
//  视频操作--猜图
//
//  Created by Shenglin on 16/1/11.
//  Copyright © 2016年 Shenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMQuestion : NSObject

@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,strong) NSArray *options;



/**字典转模型 三步走*/
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;
+ (NSArray *)questions;

@end
