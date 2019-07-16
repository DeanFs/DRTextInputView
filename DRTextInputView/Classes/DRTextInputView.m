//
//  DRTextInputView.m
//  Records
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRTextInputView.h"
#import <DRMacroDefines/DRMacroDefines.h>

@interface  DRTextInputView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCenterY;

@property (nonatomic, copy) DRTextInputViewCompleteBlock confirmBlock;
@property (nonatomic, copy) NSString *oldString;

@end

@implementation DRTextInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setFrame:[UIScreen mainScreen].bounds];
    self.confirmButton.enabled = NO;
    UIColor *disableColor = [UIColor colorWithRed:187.0/255.0
                                            green:187.0/255.0
                                             blue:187.0/255.0
                                            alpha:1.0];
    [self.confirmButton setTitleColor:disableColor
                             forState:UIControlStateDisabled];
    
    KDR_ADD_OBSERVER(UIKeyboardWillShowNotification, @selector(onKeybordFrameChange:))
    KDR_ADD_OBSERVER(UIKeyboardWillHideNotification, @selector(onKeybordHide))
    KDR_ADD_OBSERVER(UITextFieldTextDidChangeNotification, @selector(onTextChange))
    
    [kDRWindow addSubview:self];
}

- (void)dealloc {
    kDR_REMOVE_OBSERVER
}

- (void)onKeybordFrameChange:(NSNotification *)notice {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat duration = [[notice.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect keyboardFrame = [[notice.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardHeight = CGRectGetHeight(keyboardFrame);
        CGFloat bottom = CGRectGetHeight(kDRWindow.bounds) - self.containerView.jx_y - self.containerView.jx_height;
        if (bottom < keyboardHeight + 10) {
            [UIView animateWithDuration:duration animations:^{
                self.viewCenterY.constant = bottom - (keyboardHeight + 10);
                [self layoutIfNeeded];
            }];
        }
    });
}

- (void)onKeybordHide {
    [UIView animateWithDuration:kDRAnimationDuration animations:^{
        self.viewCenterY.constant = 0;
        [self layoutIfNeeded];
    }];
}

- (void)onTextChange {
    if ([self.textField.text isEqualToString:self.oldString]) {
        self.confirmButton.enabled = NO;
    } else {
        self.confirmButton.enabled = YES;
    }
}

+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          placeHolder:(NSString *)placeHolder
    otherSettingBlock:(DRTextInputViewSettingBlock)settingBlock
         confirmBlock:(DRTextInputViewCompleteBlock)confirmBlock {
    if (!confirmBlock) {
        return;
    }
    DRTextInputView *alertView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
    alertView.titleLabel.text = title;
    alertView.textField.text = content;
    alertView.textField.placeholder = placeHolder;
    alertView.confirmBlock = confirmBlock;
    alertView.oldString = content;
    kDR_SAFE_BLOCK(settingBlock, alertView);
    [alertView show];
}

#pragma mark - Private Method
- (void)show {
    self.layer.opacity = 0.0;
    [UIView animateWithDuration:kDRAnimationDuration animations:^{
        self.layer.opacity = 1.0;
    }];
    [self.containerView popToShow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
}

- (void)dismiss {
    [UIView animateWithDuration:kDRAnimationDuration animations:^{
        self.layer.opacity = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.containerView popToDismiss];
}

#pragma mark - Event Response
- (IBAction)closeAction:(id)sender {
    [self endEditing:YES];
    [self dismiss];
}

- (IBAction)enterAction:(id)sender {
    [self endEditing:YES];
    if (self.confirmBlock(self, self.textField.text)) {
        [self dismiss];
    }
}

@end
