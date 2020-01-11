# YAEasyProtector

<p align="center">
<a href="http://blog.chenyalun.com"><img src="https://img.shields.io/badge/Language-%20Objective--C%20-blue.svg"></a>
<a href="http://blog.chenyalun.com"><img src="https://img.shields.io/badge/platform-iOS-brightgreen.svg?style=flat"></a>
<a href="http://blog.chenyalun.com"><img src="http://img.shields.io/badge/license-MIT-orange.svg?style=flat"></a>
</p>

## Features
when these situations occur, it can avoid crash.

- [x] Unrecognized selector
- [x] Set value or get value with KVC
- [x] Add or remove elements repeatedly with KVO
- [x] Beyond bounds or null value with NSArray & NSMutableArray
- [x] Null value with NSDictionary & NSMutableDictionary
- [x] Circular reference with NSTimer

## Usage

Set callback when crash occurs.

```objective-c

YAEasyProtector *sharedProtector = YAEasyProtector.sharedProtector;
sharedProtector.crashHandler = ^(NSDictionary *userInfo) {
   Class cls = userInfo[kYAEasyProtectorItemClassKey];
   YACrashType type    = [userInfo[kYAEasyProtectorItemTypeKey] integerValue];
   NSString *selector  = userInfo[kYAEasyProtectorItemSELKey];
   NSString *callStack = userInfo[kYAEasyProtectorItemCallStackKey];
   NSString *otherInfo = userInfo[kYAEasyProtectorItemUserInfoKey];
   NSLog(@"%lu, %@, %@, %@, %@", (unsigned long)type, cls, selector, callStack, otherInfo);
};
```

## Article

[iOS中的Crash防护](https://blog.chenyalun.com/2019/09/11/iOS中的Crash防护/)

## Author
[Yalun, Chen](http://chenyalun.com)

## License

YAScrollPlaceView is available under the MIT license. See the LICENSE file for more info.




