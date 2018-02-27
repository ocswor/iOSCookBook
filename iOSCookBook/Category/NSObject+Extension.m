//
//  NSObject+Extension.m
//  iOSCookBook
//
//  Created by eric on 2018/2/27.
//  Copyright © 2018年 Eric. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@interface Parasite : NSObject
@property (nonatomic, copy) void(^deallocBlock)(void);
@end
@implementation Parasite
- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
}
@end


@implementation NSObject (Extension)

- (void)guard_addDeallocBlock:(void(^)(void))block {
    @synchronized (self) {
        static NSString *kAssociatedKey = nil;
        NSMutableArray *parasiteList = objc_getAssociatedObject(self, &kAssociatedKey);
        //数组 的话 可以添加多个寄生对象
        if (!parasiteList) {
            parasiteList = [NSMutableArray new];
            objc_setAssociatedObject(self, &kAssociatedKey, parasiteList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        Parasite *parasite = [Parasite new];
        parasite.deallocBlock = block;
        [parasiteList addObject: parasite];
    }
}


@end
