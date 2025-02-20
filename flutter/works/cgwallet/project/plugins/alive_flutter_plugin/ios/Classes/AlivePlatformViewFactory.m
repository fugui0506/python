//
//  AlivePlatformViewFactory.m
//  alive_flutter_plugin
//
//  Created by 罗礼豪 on 2020/11/25.
//

#import "AlivePlatformViewFactory.h"
#import "AlivePlatformViewObject.h"

@implementation AlivePlatformViewFactory

+ (AlivePlatformViewFactory *)sharedInstance {
    static dispatch_once_t onceToken = 0;
    static AlivePlatformViewFactory *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[AlivePlatformViewFactory alloc] init];
    });
    
    return sharedObject;
}

//设置参数的编码方式
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject <FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    self.myPlatformViewObject = [[AlivePlatformViewObject alloc] initWithFrame:frame viewId:viewId args:args];
    return self.myPlatformViewObject;
}

@end
