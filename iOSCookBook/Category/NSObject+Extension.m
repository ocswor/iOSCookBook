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

/*
 注意事项 http://www.tanhao.me/pieces/160626.html/
 block触发的线程与对象释放时的线程一致,请注意后续操作的线程安全.
 不要在block中强引用对象,否则引用循环释放不了;
 不要在block中通过weak引用对象,因为此时会返回nil;
 (根据WWDC2011,Session322对对象释放时间的描述，associated objects清除在对象生命周期中很晚才执行，通过被NSObject -dealloc方法调用的object_dispose()函数完成);
 */
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
