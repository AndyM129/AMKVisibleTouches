//
//  UIWindow+AMKVisibleTouches.h
//  AMKitLab
//
//  Created by Andy__M on 16/4/16.
//  Copyright © 2016年 Andy__M. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 可视化触摸
@interface UIWindow (AMKVisibleTouches)
@property(nonatomic, assign) BOOL amk_touchesVisible;               //!< 触摸是否可见
@end
