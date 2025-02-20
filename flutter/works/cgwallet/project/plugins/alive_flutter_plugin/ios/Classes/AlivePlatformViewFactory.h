//
//  AlivePlatformViewFactory.h
//  alive_flutter_plugin
//
//  Created by 罗礼豪 on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "AlivePlatformViewObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivePlatformViewFactory : NSObject<FlutterPlatformViewFactory>

+ (AlivePlatformViewFactory *)sharedInstance;

@property (nonatomic, strong) AlivePlatformViewObject *myPlatformViewObject;

@end

NS_ASSUME_NONNULL_END
