//
//  GloablHelper.h
//  TaoLiWangGongHui
//
//  Created by apple on 14-3-13.
//  Copyright (c) 2014年 Hongli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHelper : NSObject

UINavigationController *selected_navigation_controller();

// 检查邮箱是否格式正确
+ (BOOL)isValidateEmail:(NSString *)email;

// 检查手机号码格式正确
+ (BOOL)isValidatePhone:(NSString *)phone;

// 检查邮编格式正确
+ (BOOL)isValidateZipCode:(NSString *)zipCode;

// 默认弹出框
+ (void)handerResultWithDelegate:(id)delegate withMessage:(NSString *)message;

// 自定义AlertView
+ (void)showWithTitle:(NSString *)title withMessage:(NSString *)message withCancelTitle:(NSString *)cancelTitle withOkTitle:(NSString *)okTitle withSelector:(SEL)selector withTarget:(id)target;

@end
