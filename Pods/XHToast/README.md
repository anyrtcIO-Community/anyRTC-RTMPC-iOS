# XHToast
#### 简洁轻便提示工具,一行代码,既可完成提示信息显示.

[![AppVeyor](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg?maxAge=2592000)](https://github.com/CoderZhuXH/XHToast)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/CoderZhuXH/XHToast)
[![Version Status](https://img.shields.io/cocoapods/v/XHToast.svg?style=flat)](http://cocoadocs.org/docsets/XHToast)
[![Support](https://img.shields.io/badge/support-iOS%207%2B-brightgreen.svg)](https://github.com/CoderZhuXH/XHToast)
[![Pod Platform](https://img.shields.io/cocoapods/p/XHToast.svg?style=flat)](http://cocoadocs.org/docsets/XHToast)
[![Pod License](https://img.shields.io/cocoapods/l/XHToast.svg?style=flat)](https://github.com/CoderZhuXH/XHToast/blob/master/LICENSE)

==============

#### Swift版本请戳这里>>> https://github.com/CoderZhuXH/XHToastSwift

### 技术交流群(群号:537476189)

## 效果
![image](http://h.hiphotos.baidu.com/image/pic/item/023b5bb5c9ea15ce2973e439be003af33a87b264.jpg)

## 使用方法
### 1.普通调用
```objc
    
    //您只需要调用一行代码,既可完成提示信息显示
 
    //1.在window上显示toast

    /**
    中间显示
    */
    [XHToast showCenterWithText:@"您要显示的提示信息"];

    /*
    上方显示
    */
    [XHToast showTopWithText:@"您要显示的提示信息"];

    /*
    下方显示
    */
    [XHToast showBottomWithText:@"您要显示的提示信息"];


    //2.你也可以这样调用,在view上显示toast

    /**
    *  中间显示
    */
    [self.view showXHToastCenterWithText:@"您要显示的提示信息"];

    /**
    *  上方显示
    */
    [self.view showXHToastTopWithText:@"您要显示的提示信息"];

    /**
    *  下方显示
    */
    [self.view showXHToastBottomWithText:@"您要显示的提示信息"];

```
### 2.自定义Toast停留时间+到屏幕上端/下端距离(见如下方法)

#### 1.显示至window(通过XHToast调用)

```objc
#pragma mark-中间显示

/**
*  中间显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
+ (void)showCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark-上方显示

/**
*  上方显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
+ (void)showTopWithText:(NSString *)text duration:(CGFloat)duration;

/**
*  上方显示+自定义距顶端距离
*
*  @param text      内容
*  @param topOffset 到顶端距离
*/
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;

/**
*  上方显示+自定义距顶端距离+自定义停留时间
*
*  @param text      内容
*  @param topOffset 到顶端距离
*  @param duration  停留时间
*/
+ (void)showTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

#pragma mark-下方显示

/**
*  下方显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
+ (void)showBottomWithText:(NSString *)text duration:(CGFloat)duration;

/**
*  下方显示+自定义距底端距离
*
*  @param text         内容
*  @param bottomOffset 距底端距离
*/
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;

/**
*  下方显示+自定义距底端距离+自定义停留时间
*
*  @param text         内容
*  @param bottomOffset 距底端距离
*  @param duration     停留时间
*/
+ (void)showBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

```

#### 2.在view上显示(通过view调用)

```objc
#pragma mark-中间显示

/**
*  中间显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
- (void)showXHToastCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark-上方显示

/**
*  上方显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
- (void)showXHToastTopWithText:(NSString *)text duration:(CGFloat)duration;

/**
*  上方显示+自定义距顶端距离
*
*  @param text      内容
*  @param topOffset 到顶端距离
*/
- (void)showXHToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;

/**
*  上方显示+自定义距顶端距离+自定义停留时间
*
*  @param text      内容
*  @param topOffset 到顶端距离
*  @param duration  停留时间
*/
- (void)showXHToastTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

#pragma mark-下方显示

/**
*  下方显示+自定义停留时间
*
*  @param text     内容
*  @param duration 停留时间
*/
- (void)showXHToastBottomWithText:(NSString *)text duration:(CGFloat)duration;

/**
*  下方显示+自定义距底端距离
*
*  @param text         内容
*  @param bottomOffset 距底端距离
*/
- (void)showXHToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;

/**
*  下方显示+自定义距底端距离+自定义停留时间
*
*  @param text         内容
*  @param bottomOffset 距底端距离
*  @param duration     停留时间
*/
- (void)showXHToastBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

```

##  安装
### 1.手动添加:<br>
*   1.将 XHToast 文件夹添加到工程目录中<br>
*   2.导入 XHToast.h

### 2.CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'XHToast'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 XHToast.h

### 3.Tips
*   1.如果发现pod search XHToast 搜索出来的不是最新版本，需要在终端执行cd desktop退回到desktop，然后执行pod setup命令更新本地spec缓存（需要几分钟），然后再搜索就可以了
*   2.如果你发现你执行pod install后,导入的不是最新版本,请删除Podfile.lock文件,在执行一次 pod install

##  系统要求
*   该项目最低支持 iOS 7.0 和 Xcode 7.0

##  许可证
XHToast 使用 MIT 许可证，详情见 LICENSE 文件



