//
//  UIWindow+AMKVisibleTouches.m
//  AMKitLab
//
//  Created by Andy__M on 16/4/16.
//  Copyright © 2016年 Andy__M. All rights reserved.
//

#import "UIWindow+AMKVisibleTouches.h"
#import "NSObject+AMKMethodSwizzling.h"

/// 触摸视图
@interface AMTouchView : UIView @end

@implementation AMTouchView
-(instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 50, 50)];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.916 alpha:1.000];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 5;
    }
    return self;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// 触摸波纹视图
@interface AMTouchRippleView : UIView @end

@implementation AMTouchRippleView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 50, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.916 alpha:1.000];
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
    return self;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static void * UIWINDOW_TOUCHES_VISIBLE_KEY = &UIWINDOW_TOUCHES_VISIBLE_KEY;
static void * UIWINDOW_TOUCH_VIEW_REUSE_POOL_KEY = &UIWINDOW_TOUCH_VIEW_REUSE_POOL_KEY;
static void * UIWINDOW_TOUCH_RIPPLE_VIEW_REUSE_POOL_KEY = &UIWINDOW_TOUCH_RIPPLE_VIEW_REUSE_POOL_KEY;
static void * UIWINDOW_TOUCH_CONTAINER_VIEW_KEY = &UIWINDOW_TOUCH_CONTAINER_VIEW_KEY;

@interface UIWindow ()
@property(nonatomic, strong) NSMutableSet<AMTouchView *> *touchViewReusePool;                   //!< 触摸点视图的复用池
@property(nonatomic, strong) NSMutableSet<AMTouchRippleView *> *touchRippleViewReusePool;       //!< 触摸波纹视图的复用池
@property(nonatomic, strong) UIView *touchContainerView;                                        //!< 触摸点容器视图
@end

@implementation UIWindow (AMKVisibleTouches)

#pragma mark - Life Circle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIWindow amk_swizzleInstanceMethod:@selector(sendEvent:) with:@selector(amk_sendEvent:)];
        [UIWindow amk_swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(amk_layoutSubviews)];
    });
}

#pragma mark - Propertys

- (BOOL)amk_touchesVisible {
    NSNumber *touchesVisible = objc_getAssociatedObject(self, UIWINDOW_TOUCHES_VISIBLE_KEY);
    return  (touchesVisible)?([touchesVisible boolValue]):NO;
}

- (void)setAmk_touchesVisible:(BOOL)touchesVisible {
    objc_setAssociatedObject(self,UIWINDOW_TOUCHES_VISIBLE_KEY, @(touchesVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet<AMTouchView *> *)touchViewReusePool {
    NSMutableSet *touchViewReusePool = objc_getAssociatedObject(self, UIWINDOW_TOUCH_VIEW_REUSE_POOL_KEY);

    if (!touchViewReusePool) {
        touchViewReusePool = [NSMutableSet set];
        self.touchViewReusePool = touchViewReusePool;
    }
    return touchViewReusePool;
}

- (void)setTouchViewReusePool:(NSMutableSet<AMTouchView *> *)touchViewReusePool {
    objc_setAssociatedObject(self,UIWINDOW_TOUCH_VIEW_REUSE_POOL_KEY, touchViewReusePool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet<AMTouchRippleView *> *)touchRippleViewReusePool {
    NSMutableSet *touchRippleViewReusePool = objc_getAssociatedObject(self, UIWINDOW_TOUCH_RIPPLE_VIEW_REUSE_POOL_KEY);
    
    if (!touchRippleViewReusePool) {
        touchRippleViewReusePool = [NSMutableSet set];
        self.touchRippleViewReusePool = touchRippleViewReusePool;
    }
    return touchRippleViewReusePool;
}

- (void)setTouchRippleViewReusePool:(NSMutableSet<AMTouchRippleView *> *)touchRippleViewReusePool {
    objc_setAssociatedObject(self,UIWINDOW_TOUCH_RIPPLE_VIEW_REUSE_POOL_KEY, touchRippleViewReusePool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)touchContainerView {
    UIView *touchContainerView = objc_getAssociatedObject(self, UIWINDOW_TOUCH_CONTAINER_VIEW_KEY);
    
    if (!touchContainerView) {
        touchContainerView = [[UIView alloc] initWithFrame:self.bounds];
        touchContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        touchContainerView.backgroundColor = [UIColor clearColor];
        touchContainerView.alpha = 0.5;
        touchContainerView.userInteractionEnabled = NO;
        [self addSubview:touchContainerView];
        self.touchContainerView = touchContainerView;
    }
    return touchContainerView;
}

- (void)setTouchContainerView:(UIView *)touchContainerView {
    objc_setAssociatedObject(self,UIWINDOW_TOUCH_CONTAINER_VIEW_KEY, touchContainerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Actions

- (void)amk_sendEvent:(UIEvent *)event {
    //  获取所有的触摸对象
    NSSet *allTouches = [event allTouches];
    
    //  为每一个触摸添加圆点视图
    for (UITouch *touch in [allTouches allObjects]) {
        AMTouchView *touchView;
        switch (touch.phase) {
            case UITouchPhaseBegan: {   //  触摸开始
                //  从复用池中取出一个触摸视图：若有则将其从复用池中移除，否则创建一个
                touchView = self.touchViewReusePool.anyObject;
                if (touchView) {
                    [self.touchViewReusePool removeObject:touchView];
                } else {
                    touchView = [[AMTouchView alloc] init];
                }
                
                //  设置该触摸视图的tag值为触摸的hash值，方便在之后该触摸移动时通过tag找到该触摸的视图并修改其位置，最后将其添加到视图上
                touchView.tag = touch.hash;
                touchView.center = [touch locationInView:self.touchContainerView];
                [self.touchContainerView addSubview:touchView];
                break;
            }
            case UITouchPhaseMoved: {   //  触摸移动
                //  获取该触摸的圆点视图，修改其位置为触摸的位置
                if (!touchView) touchView = (AMTouchView *)[self.touchContainerView viewWithTag:touch.hash];
                touchView.center = [touch locationInView:self.touchContainerView];
                
                //  从复用池中取出一个触摸波纹视图，若有则将其从复用池中移除，否则创建一个
                AMTouchRippleView *touchRippleView = self.touchRippleViewReusePool.anyObject;
                if (touchRippleView) {
                    [self.touchRippleViewReusePool removeObject:touchRippleView];
                } else {
                    touchRippleView = [[AMTouchRippleView alloc] init];
                }
                
                //  设置该触摸波纹视图的位置为触摸的位置，最后将其添加到视图上，并以动画使其淡出并放回复用池中
                touchRippleView.center = [touch locationInView:self.touchContainerView];
                [self.touchContainerView insertSubview:touchRippleView belowSubview:touchView];
                [UIView animateWithDuration:0.4 animations:^{
                    touchRippleView.alpha = 0;
                    touchRippleView.transform = CGAffineTransformMakeScale(0.2, 0.2);
                } completion:^(BOOL finished) {
                    [touchRippleView removeFromSuperview];
                    touchRippleView.alpha = 1;
                    touchRippleView.transform = CGAffineTransformIdentity;
                    [self.touchRippleViewReusePool addObject:touchRippleView];
                }];
                break;
            }
            case UITouchPhaseStationary: {  //  当有多个同时触摸时，有的在移动，而另外没移动的触摸会处于UITouchPhaseStationary状态
                //  获取该触摸的圆点视图，修改其位置为触摸的位置
                if (!touchView) touchView = (AMTouchView *)[self.touchContainerView viewWithTag:touch.hash];
                touchView.center = [touch locationInView:self.touchContainerView];
                break;
            }
            case UITouchPhaseEnded:         //  触摸结束
            case UITouchPhaseCancelled: {   //  触摸被取消了
                //  获取该触摸的圆点视图，设置其tag为初始值0，并以动画淡出视图并移除，最后将该触摸原点视图放回复用池
                if (!touchView) touchView = (AMTouchView *)[self.touchContainerView viewWithTag:touch.hash];
                touchView.tag = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    touchView.alpha = 0;
                } completion:^(BOOL finished) {
                    [touchView removeFromSuperview];
                    touchView.alpha = 1;
                    [self.touchViewReusePool addObject:touchView];
                }];
                break;
            }
        }
    }
    
    //  调用回系统的实现
    [self amk_sendEvent:event];
}

- (void)amk_layoutSubviews {
    //  先调用一下系统的实现
    [self amk_layoutSubviews];
    //  保持触摸视图在window的最上方显示
    [self bringSubviewToFront:self.touchContainerView];
}

@end
