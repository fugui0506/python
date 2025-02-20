//
//  AlivePlatformViewObject.h
//  alive_flutter_plugin
//
//  Created by 罗礼豪 on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlivePlatformViewObject : NSObject <FlutterPlatformView>

@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame viewId:(int64_t)viewId args:(id)args;

@end

NS_ASSUME_NONNULL_END
