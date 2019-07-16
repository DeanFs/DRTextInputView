//
//  DRTextInputView.h
//  Records
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <DRPopAnimationView/DRPopAnimationView.h>

@class DRTextInputView;

typedef void (^DRTextInputViewSettingBlock)(DRTextInputView *inputView);
typedef BOOL (^DRTextInputViewCompleteBlock)(DRTextInputView *inputView, NSString *text);

@interface DRTextInputView : DRPopAnimationView

@property (weak, nonatomic) IBOutlet JXTextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/**
 显示带输入框的弹窗

 @param title 弹窗标题
 @param content 输入框内容反显
 @param placeHolder 占位提示文字
 @param settingBlock 其他个性设置
 @param confirmBlock 点击确认按钮的回调，block中return YES，则退出隐藏输入框
 */
+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          placeHolder:(NSString *)placeHolder
    otherSettingBlock:(DRTextInputViewSettingBlock)settingBlock
         confirmBlock:(DRTextInputViewCompleteBlock)confirmBlock;

@end
