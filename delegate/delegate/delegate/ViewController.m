//
//  ViewController.m
//  delegate
//
//  Created by Shenglin on 16/3/10.
//  Copyright © 2016年 Shenglin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.countText becomeFirstResponder];
    // Do any additional setup after loading the view, typically from a nib.
    self.clickButton.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login
{
    NSLog(@"%@  %@",self.countText.text,self.pwdText.text);
}


//文本框中回车处理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.countText == textField) {
        [self.pwdText becomeFirstResponder];
    }else if (self.pwdText == textField){
        //收起键盘（交出第一响应者身份）
        [textField resignFirstResponder];
        //收起键盘
//        [self.view endEditing:YES];
        [self login];
    }
    return YES;
}


#pragma mark - 文本框代理方法

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"%@  %@",NSStringFromRange(range),string);
//    
//    //限制输入的长度
//    int loc = range.location;
//    return (loc < 6);
//    
////    if (loc < 6) {
////        return YES;
////    }else{
////        return NO;
////    }
//    
//    //如果返回NO，就不向文本框中添加字符
//    //return NO;
//}

@end
