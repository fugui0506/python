#import <Flutter/Flutter.h>

@interface CaptchaPluginFlutterPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventSink eventSink;

@property FlutterMethodChannel *channel;
@end
