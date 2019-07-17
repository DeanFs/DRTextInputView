//
//  DRViewController.m
//  DRTextInputView
//
//  Created by Dean_F on 07/14/2019.
//  Copyright (c) 2019 Dean_F. All rights reserved.
//

#import "DRViewController.h"
#import <DRTextInputView/DRTextInputView.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRInputLimitManager/DRInputLimitManager.h>
#import <DRToastView/DRToastView.h>

@interface DRViewController ()

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [DRTextInputView showWithTitle:@"交易金额" content:@"100" placeHolder:@"请输入金额" otherSettingBlock:^(DRTextInputView *inputView) {
        [DRInputLimitManager addTextLimitForInputView:inputView.textField textDidChangeNotice:UITextFieldTextDidChangeNotification limit:10 allowedCharTypes:DRInputCharTypesNumber checkDoneBlock:^(DRInputLimitManager *manager, UIView<UITextInput> *inputView, NSString *text, NSInteger limit, BOOL beyondLimit) {
            if (beyondLimit) {
                [DRToastView showWithMessage:@"超过10位数上限" upOffset:100 complete:nil];
            }
        }];
    } confirmBlock:^BOOL(DRTextInputView *inputView, NSString *text) {
        if (text.integerValue == 0) {
            [DRToastView showWithMessage:@"金额不小于1" upOffset:100 complete:nil];
            return NO;
        }
        return YES;
    }];
}

@end
