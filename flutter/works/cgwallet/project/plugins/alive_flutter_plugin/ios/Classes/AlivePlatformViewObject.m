//
//  AlivePlatformViewObject.m
//  alive_flutter_plugin
//
//  Created by 罗礼豪 on 2020/11/25.
//

#import "AlivePlatformViewObject.h"

@interface AlivePlatformViewObject()

@property (nonatomic, strong) UIView *myNativeView;

@end

@implementation AlivePlatformViewObject
{
CGRect _frame;
int64_t _viewId;
id _args;
}

- (id)initWithFrame:(CGRect)frame viewId:(int64_t)viewId args:(id)args {
    if (self = [super init]) {
        _frame = frame;
        _viewId = viewId;
        _args = args;
        NSDictionary *dict = _args;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        int radius = 0.0;
        if ([_args isKindOfClass:[NSDictionary class]]) {
            width = [[dict objectForKey:@"width"] floatValue];
            height = [[dict objectForKey:@"height"] floatValue];
            radius = [[dict objectForKey:@"radius"] intValue];
        }
        if (!_myNativeView) {
            _myNativeView = [[UIView alloc] init];
            _myNativeView.frame = CGRectMake(0, 0, width, height);
            _myNativeView.layer.cornerRadius = radius;
            _myNativeView.layer.masksToBounds = YES;
        }
    }
    return self;
}

- (UIView *)view {
    NSDictionary *dict = _args;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    int radius = 0.0;
    if ([_args isKindOfClass:[NSDictionary class]]) {
        width = [[dict objectForKey:@"width"] floatValue];
        height = [[dict objectForKey:@"height"] floatValue];
        radius = [[dict objectForKey:@"radius"] intValue];
    }
    if (!self.imageView) {
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(0, 0, width, height);;
        img.layer.cornerRadius = radius;
        img.layer.masksToBounds = YES;
        self.imageView = img;
        [_myNativeView addSubview:img];
    }
    return _myNativeView;
}

@end
