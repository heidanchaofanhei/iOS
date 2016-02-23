//
//  ViewController.m
//  视频操作--猜图
//
//  Created by Shenglin on 15/12/27.
//  Copyright © 2015年 Shenglin. All rights reserved.
//

#import "ViewController.h"
#import "HMQuestion.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (nonatomic,strong) UIButton *cover;
@property (nonatomic,strong) NSArray *questions;
@property (nonatomic,assign) int index;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

@end

@implementation ViewController

- (NSArray *)questions{
    if (_questions == nil) {
        _questions = [HMQuestion questions
                      ];
    }
    return _questions;
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UIButton *)cover{
    if (_cover == nil) {
        //添加蒙版
        _cover = [[UIButton alloc]initWithFrame:self.view.bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self.view addSubview:_cover];
        _cover.alpha = 0.0;
        //添加监听
        [_cover addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cover;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"%@",self.questions);
    
    [self nextQuestion];
}

- (void)arrayWith:(NSArray *)array{
    
    
}

- (IBAction)bigImage {
    
    if (self.cover.alpha == 0) {
        [self cover];
        //将小图按钮提前
        [self.view bringSubviewToFront:self.iconButton];
        
        
        //放大按钮图像(开始无法放大，取消自动布局就好了)
        CGFloat w = self.view.bounds.size.width;
        CGFloat h = w;
        CGFloat y = (self.view.bounds.size.height - w) * 0.5;
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame = CGRectMake(0, y, w, h);
            self.cover.alpha = 1.0;
        }];

    }else{
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame = CGRectMake(85, 85, 150, 150);
                    self.
            cover.alpha = 0.0;
//            self.cover.hidden = YES;
            //        [cover addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
            
        }completion:^(BOOL finished) {
            //        [cover removeFromSuperview];
        }];
    }

    

}

//button的alpha属性设置为0，意味着hidden = YES

- (IBAction)nextQuestion{
//    self.index++;
    HMQuestion *question = self.questions[self.index];
    
    //3.设置基本信息
    self.noLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.questions.count];
    self.titleLabel.text = question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    //如果到达最后一题，禁用下一按钮
    self.nextQuestionButton.enabled = (self.index < self.questions.count - 1);
    self.index++;

    //4.设置答案按钮
#define kButtonWidth 35
#define kButtonHeight 35
#define kButtonMargin 10
    
    //由于答案区出现按钮叠加，所以要先清楚  然后新建
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    
    //创建所有答案的按钮
    CGFloat answerW = self.answerView.bounds.size.width;
    int lenth = question.answer.length;
    CGFloat answerX = (answerW - kButtonWidth * lenth - kButtonMargin * (lenth - 1))*0.5;
    
    for (int i = 0; i<lenth; i++) {
        CGFloat x = answerX + (kButtonMargin + kButtonWidth) * i;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, kButtonWidth, kButtonHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        
        [self.answerView addSubview:btn];
    }
    
    
    
}

@end
