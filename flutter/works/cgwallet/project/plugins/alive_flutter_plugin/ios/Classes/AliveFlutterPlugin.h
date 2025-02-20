#import <Flutter/Flutter.h>

@interface AliveFlutterPlugin : NSObject<FlutterPlugin,FlutterStreamHandler>

@property FlutterMethodChannel *channel;

@property (nonatomic, strong) FlutterEventSink eventSink;

@end
