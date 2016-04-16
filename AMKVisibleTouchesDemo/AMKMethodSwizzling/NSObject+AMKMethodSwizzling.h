//
//  NSObject+AMKMethodSwizzling.h
//  AMKitLab
//
//  Created by Andy__M on 16/3/22.
//  Copyright © 2016年 Andy__M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (AMKMethodSwizzling)

/// 交换实例方法
+ (BOOL)amk_swizzleInstanceMethod:(SEL)originalSelector with:(SEL)newSelector;

/// 交换类方法
+ (BOOL)amk_swizzleClassMethod:(SEL)originalSelector with:(SEL)newSelector;
@end
