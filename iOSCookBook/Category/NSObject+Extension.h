//
//  NSObject+Extension.h
//  iOSCookBook
//
//  Created by eric on 2018/2/27.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

/**
 @brief 添加一个block,当该对象释放时被调用
 **/
- (void)guard_addDeallocBlock:(void(^)(void))block;
@end
