//
//  NSObject+AMKMethodSwizzling.m
//  AMKitLab
//
//  Created by Andy__M on 16/3/22.
//  Copyright © 2016年 Andy__M. All rights reserved.
//

#import "NSObject+AMKMethodSwizzling.h"

@implementation NSObject (AMKMethodSwizzling)

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSelector   Selector 1.
 @param newSelector        Selector 2.
 @return              YES if swizzling succeed; otherwize, NO.
 */
+ (BOOL)amk_swizzleInstanceMethod:(SEL)originalSelector with:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSelector,
                    class_getMethodImplementation(self, newSelector),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSelector),
                                   class_getInstanceMethod(self, newSelector));
    return YES;
}

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSelector   Selector 1.
 @param newSelector        Selector 2.
 @return              YES if swizzling succeed; otherwize, NO.
 */
+ (BOOL)amk_swizzleClassMethod:(SEL)originalSelector with:(SEL)newSelector {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

@end
