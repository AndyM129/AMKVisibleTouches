AMKVisibleTouches
======
![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)
![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)

![AMKVisibleTouches](https://github.com/AndyM129/AMKVisibleTouches/blob/master/AMKVisibleTouchesDemo.gif)

PS：这是我开源的第一个项目，一个UIWindow的category。

Features
==============
一句话让“触摸”可见——就这么神奇（请自觉用小岳岳的语气说）~~


Installation
------

### CocoaPods
由于是第一次开源，还不知道如何让[CocoaPods](http://cocoapods.org)支持，只能先下载到本地再使用了~~


### Manually
将该类添加到项目中，并引入该类的头文件即可。


How To Use It
------

### Initialization
```Objective-C
#import "AppDelegate.h"
#import "ViewController.h"
#import "UIWindow+AMKVisibleTouches.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.amk_touchesVisible = YES;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
```


Requirements
------
该软件 Xcode Version 7.1.1 上开发的，目标支持iOS7+，没有测试更早的iOS版本。


One More Thing
------
如果你有好的 idea 或 疑问，请随时提 issue 或 request。

如果你感兴趣该类的实现思路，具体可以参看我的简书 [http://www.jianshu.com/p/ab7d05f53c1e](http://www.jianshu.com/p/ab7d05f53c1e)


Author
------
如果你在开发过程中遇到什么问题，或对iOS开发有着自己独到的见解，再或是你与我一样同为菜鸟，都可以关注或私信我的微博。

* QQ: 564784408
* 微信：Andy_129
* 微博：[@Developer_Andy](http://weibo.com/u/5271489088)
* 简书：[Andy__M](http://www.jianshu.com/users/28d89b68984b)

>“Stay hungry. Stay foolish.”

与君共勉~

License
------
本软件 使用 MIT 许可证，详情见 LICENSE 文件。



