//
//  ViewController.m
//  视频操作--猜图
//
//  Created by Shenglin on 15/12/27.
//  Copyright © 2015年 Shenglin. All rights reserved.
//

#import "ViewController.h"
#import "HMQuestion.h"

#define kButtonWidth 35
#define kButtonHeight 35
#define kButtonMargin 10
#define kTotolCol 7

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
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

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

#pragma mark - 大小图切换

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

#pragma mark - 下一题按钮

- (IBAction)nextQuestion{
    //    self.index++;
    
    //如果index到达最后一题，提示用户奖励
    if (self.index == self.questions.count) {
        NSLog(@"%d",self.index);
        return;
    }
    
    //2.从数组中按照索引取出题目模型数据
    HMQuestion *question = self.questions[self.index];
    //3.设置基本信息
    [self setupBasicInfo:question];
    //4.创建答案的按钮
    [self createAnswerButton:question];
    //5.备选区答案
    [self createOptionButton:question];
    //打印一下options中的子视图的数量
    NSLog(@"%d",self.optionsView.subviews.count);
    

    //1.当前答题索引，所以递增

    self.index++;

}

//设置基本信息
- (void)setupBasicInfo:(HMQuestion *)question
{
    self.noLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.questions.count];
    self.titleLabel.text = question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    //如果到达最后一题，禁用下一按钮
    self.nextQuestionButton.enabled = (self.index < self.questions.count - 1);

}

//创建答案区按钮
- (void)createAnswerButton:(HMQuestion *)question
{
    //由于答案区出现按钮叠加，所以要先清楚  然后新建
    //这个UIButton替换成UIView也可以，所有控件都继承自UIView，多态作用
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    
    CGFloat answerW = self.answerView.bounds.size.width;
    int lenth = question.answer.length;
    CGFloat answerX = (answerW - kButtonWidth * lenth - kButtonMargin * (lenth - 1))*0.5;
    
    for (int i = 0; i<lenth; i++) {
        CGFloat x = answerX + (kButtonMargin + kButtonWidth) * i;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, kButtonWidth, kButtonHeight)];
        //        btn.backgroundColor = [UIColor whiteColor];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerView addSubview:btn];
        
        //添加监听
        [btn addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}

/** 创建备选区按钮 */
- (void)createOptionButton:(HMQuestion *)question
{
    //问题：每一次调用下一题方法时，都会创建21个按钮
    //解决：如果按钮已经存在，并且是21个，只需要更改标题即可
    if (self.optionsView.subviews.count != question.options.count) {
        //清除上一题的子视图
        for (UIView *btn in self.optionsView.subviews) {
            [btn removeFromSuperview];
        }
        CGFloat optionsW = self.optionsView.bounds.size.width;
        CGFloat optionsX = (optionsW - kTotolCol * kButtonWidth - (kTotolCol - 1) * kButtonMargin) * 0.5;
        
        for (int i = 0; i < question.options.count; i++) {
            CGFloat row = i / kTotolCol;
            CGFloat col = i % kTotolCol;
            CGFloat x = optionsX + col * (kButtonMargin + kButtonWidth);
            CGFloat y = row * (kButtonHeight + kButtonMargin);
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, kButtonWidth, kButtonHeight)];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
            
            //设置备选答案
            [btn setTitle:question.options[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [self.optionsView addSubview:btn];
            
            //给按钮添加监听
            [btn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        }
                }
    
    //如果按钮已经存在，不需要新建按钮，只需要设置标题即可
    int i = 0;
//    [question randomOtions];
    for (UIButton *btn in self.optionsView.subviews) {
        [btn setTitle:question.options[i++] forState:UIControlStateNormal];
        
        //按钮被显示
        btn.hidden = NO;
        
    }
}

#pragma mark - 候选按钮点击方法

- (void)optionClick:(UIButton *)button
{
    NSLog(@"%s",__func__);
    //1.在答案区找到第一个titile为空的按钮
    UIButton *btn = [self firstAnswerButton];
    
    //如果没找到为空按钮，直接返回
    if (btn == nil) {
        return;
    }
    
    //2.将buttn的标题设置给答案区的按钮
    [btn setTitle:button.currentTitle forState:UIControlStateNormal];
    
    //3.按钮隐藏
    button.hidden = YES;
    
    //4.判定
    [self judge];
}

//判定答案
- (void)judge
{
    NSMutableString *strM = [NSMutableString string];
    
    //四个按钮都有文字才能判定结果
    //遍历所有答案区按钮
    BOOL isFull = YES;
    
    for (UIButton * btn in self.answerView.subviews) {
        if (btn.currentTitle.length ==0) {
            isFull = NO;
            break;
        }else{
            [strM appendString:btn.currentTitle];

        }
    }
    
    if (isFull) {
        NSLog(@"都有字----%@",strM);
        //判断答案是否一致
        //根据self.index获得当前question
        HMQuestion * question = self.questions[self.index-1];
        
        //如果一致，进入下一题
        if ([strM isEqualToString:question.answer]) {
            NSLog(@"yes");
            [self setAnswerButtonColor:[UIColor blueColor]];
            
            //等待一秒中，进入下一题
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:1.0];
            [self changeScore:800];
            //如果不一致，提示用户修改
        }else{
            NSLog(@"no");
            [self setAnswerButtonColor:[UIColor redColor]];
        }
    }
}

//修改答题区按钮颜色
- (void)setAnswerButtonColor:(UIColor *)color
{
    for (UIButton *btn in self.answerView.subviews) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}

//在答案区找到第一个文字为空的按钮
- (UIButton *)firstAnswerButton
{
    //取按钮的标题
    //遍历所有答案区按钮
    for (UIButton * btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0) {
            return btn;
        }
    }
    return nil;
}

#pragma mark - 点击答案区按钮

- (void)answerButtonClick:(UIButton *)button
{
    NSLog(@"%s",__func__);
    if (button.currentTitle.length == 0)  return;
    UIButton *btn = [self optionButtonWithTitle:button.currentTitle isHidden:YES];
    [button setTitle:@"" forState:UIControlStateNormal];
    btn.hidden = NO;
    [self setAnswerButtonColor:[UIColor blackColor]];
}

-(UIButton *)optionButtonWithTitle:(NSString *)title isHidden:(BOOL)isHidden
{
    //从答案区找到标题为title的按钮
    for (UIButton *btn in self.optionsView.subviews) {
        if ([btn.currentTitle isEqualToString:title] && btn.hidden == isHidden) {
            return btn;
        }
    }
    return nil;
}

- (IBAction)tipClick
{
    for (UIButton *btn in self.answerView.subviews) {
        [self answerButtonClick:btn];
    }
    //找到答案中第一个字
    HMQuestion *question = self.questions[self.index-1];
    NSString *first = [question.answer substringToIndex:1];
    NSLog(@"%@",first);

    //将第一个字遍历答案区按钮title，模拟点击那个按钮
    UIButton *btn = [self optionButtonWithTitle:first isHidden:NO];
    [self optionClick:btn];
    
    [self changeScore:-1000];
}

#pragma mark - 修改分数
- (void)changeScore:(int)value
{
    //intvalue是将字符串变成数字
    int currentscore = self.scoreButton.currentTitle.intValue;
    currentscore += value;
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d",currentscore] forState:UIControlStateNormal];
}


@end
