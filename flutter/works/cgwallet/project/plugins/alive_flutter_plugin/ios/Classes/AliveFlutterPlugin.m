#import "AliveFlutterPlugin.h"
#import <NTESLiveDetect/NTESLiveDetect.h>
#import "AlivePlatformViewFactory.h"
#if __has_include(<alive_flutter_plugin/alive_flutter_plugin-Swift.h>)
#import <alive_flutter_plugin/alive_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "alive_flutter_plugin-Swift.h"

#endif

@interface AliveFlutterPlugin()

@property (nonatomic, strong) NTESLiveDetectManager *detector;
@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, copy) NSString *businessID;
@property (nonatomic, assign) int timeout;

@end

@implementation AliveFlutterPlugin

+ (AliveFlutterPlugin *)sharedInstance {
    static dispatch_once_t onceToken = 0;
    static AliveFlutterPlugin *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[AliveFlutterPlugin alloc] init];
    });
    
    return sharedObject;
}

NSObject<FlutterPluginRegistrar>* _jv_registrar;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"alive_flutter_plugin" binaryMessenger:[registrar messenger]];
    _jv_registrar = registrar;
    AliveFlutterPlugin* instance = [[AliveFlutterPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];

    FlutterEventChannel* eventChannel= [FlutterEventChannel eventChannelWithName:@"yd_alive_flutter_event_channel" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:[AliveFlutterPlugin sharedInstance]];
    
    [registrar registerViewFactory:[AlivePlatformViewFactory sharedInstance] withId:@"com.flutter.alive.imageview"];
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                      eventSink:(FlutterEventSink)events {
      if (events) {
          [AliveFlutterPlugin sharedInstance].eventSink = events;
      }

    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *methodName = call.method;
    if ([methodName isEqualToString:@"startLiveDetect"]) {
        [self startLiveDetect:call result:result];
    } else if ([methodName isEqualToString:@"stopLiveDetect"]) {
        [self stopLiveDetect];
    } else if ([methodName isEqualToString:@"init"]) {
        [self init:call result:result];
    }  else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
    NSDictionary *arguments = call.arguments;
    self.timeout = 0;
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        self.businessID = [arguments objectForKey:@"businessID"];
        int time = [[arguments objectForKey:@"timeout"] intValue];
        if (time <= 0) {
            self.timeout = 30;
        } else {
            self.timeout = time;
        }
    }
}

- (void)startLiveDetect:(FlutterMethodCall*)call result:(FlutterResult)resultDict {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self stopLiveDetect];
    AlivePlatformViewObject *object = [AlivePlatformViewFactory sharedInstance].myPlatformViewObject;
    UIImageView *imageView = object.imageView;
    self.detector = [[NTESLiveDetectManager alloc] initWithImageView:imageView withDetectSensit:NTESSensitEasy];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    
    [self.detector setTimeoutInterval:(NSTimeInterval)self.timeout];
    __weak __typeof(self)weakSelf = self;
    [self.detector startLiveDetectWithBusinessID:self.businessID  actionsHandler:^(NSDictionary * _Nonnull params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *actions = [params objectForKey:@"actions"];
            NSDictionary *callbackDict = nil;
            if (actions && actions.length != 0) {
                callbackDict = @{
                    @"data":@{
                        @"actions": actions?:@"",
                    },
                    @"method":@"onConfig"
                };
                resultDict(callbackDict);
            } else {
                callbackDict = @{
                    @"data":@{@"message": @"活体检测获取配置失败",@"code":@(-1)},
                    @"method":@"onError",
                };
                resultDict(params);
            }
        });
     } checkingHandler:^{
             
     } completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
         dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.params = params;
             [weakSelf showToastWithLiveDetectStatus:status];
         });
     }];
  });
}

- (void)stopLiveDetect {
    [self.detector stopLiveDetect];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getSDKVersion:(FlutterMethodCall*) call result:(FlutterResult)resultDict {
    NSString *version = [self.detector getSDKVersion];
    NSDictionary *dict = @{@"version":version?:@""};
    resultDict(dict);
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
    NSDictionary *userInfo = infoNotification.userInfo;
    NSLog(@"userInfo：%@", userInfo);
    NSString *value = [userInfo objectForKey:@"exception"];
    NSDictionary *infoDict = [userInfo objectForKey:@"action"];
    NSNumber *key = [[infoDict allKeys] firstObject];
    if (value) {
        NSDictionary *callbackDict = Nil;
        NSString *statusText = @"";
        switch ([value intValue]) {
            case 1:
                statusText = @"保持面部在框内";
                break;
            case 2:
                statusText = @"环境光线过暗";
                break;
            case 3:
                statusText = @"环境光线过亮";
                break;
            case 4:
                statusText = @"请勿抖动手机";
                break;
            default:
                statusText = @"";
                break;
            }
        
        callbackDict = @{
            @"data":@{
                @"code": @(-1),
                @"message": statusText?:@"",
            },
            @"method":@"onError"
        };
        if ([AliveFlutterPlugin sharedInstance].eventSink) {
            [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
        }
        dispatch_async(dispatch_get_main_queue(), ^(){

        });
        return;
      
        }
    NSDictionary *callbackDict = Nil;
    switch ([key intValue]) {
        case 0:
            callbackDict = @{
                @"data":@{
                    @"currentStep": @(0),
                    @"message": @"请正对手机屏幕",
                },
                @"method":@"onChecking"
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){

            });
            break;
        case 1:
            callbackDict = @{
                @"data":@{
                    @"currentStep": @(1),
                    @"message": @"慢慢右转头",
                },
                @"method":@"onChecking"
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){

            });
            break;
        case 2:
            callbackDict = @{
                @"data":@{
                    @"currentStep": @(2),
                    @"message": @"慢慢左转头",
                },
                @"method":@"onChecking"
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
      
            });
            break;
        case 3:
            callbackDict = @{
                @"data":@{
                    @"currentStep": @(3),
                    @"message": @"请张张嘴",
                },
                @"method":@"onChecking"
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
    
            });
            break;
        case 4:
            callbackDict = @{
                @"data":@{
                    @"currentStep": @(4),
                    @"message": @"请眨眨眼",
                },
                @"method":@"onChecking"
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
    
            });
            break;
        case -1:
            break;
        default:
            break;
       }
}

- (void)showToastWithLiveDetectStatus:(NTESLDStatus)status {
    NSString *token;
    if ([self.params isKindOfClass:[NSDictionary class]]) {
        token = [self.params objectForKey:@"token"];
    }
    NSDictionary *callbackDict;
    switch (status) {
        case NTESLDCheckPass:
           callbackDict = @{
                @"method":@"onChecked",
                @"data":@{@"isPassed":@(YES),@"token":token ?:@""}
           };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                 
            });
            break;
        case NTESLDCheckNotPass:
            callbackDict = @{
                @"method":@"onChecked",
                @"data":@{@"isPassed":@(NO),@"token":token ?:@""}
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
             
            });
            break;
        case NTESLDOperationTimeout:
            callbackDict = @{
                 @"method":@"overTime",
                 @"data":@{}
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                    
            });
            break;
        case NTESLDGetConfTimeout:
            callbackDict = @{
                @"data":@{@"message": @"活体检测获取配置信息超时",@"code":@(-1)},
                @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                     
            });
            break;
        case NTESLDOnlineCheckTimeout:
            callbackDict = @{
                @"data":@{@"message": @"云端检测结果请求超时",@"code":@(-1)},
                @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                       
            });
            break;
        case NTESLDOnlineUploadFailure:
            callbackDict = @{
                @"data":@{@"message": @"云端检测上传图片失败",@"code":@(-1)},
                @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        case NTESLDNonGateway:
            callbackDict = @{
                @"data":@{@"message": @"网络未连接",@"code":@(-1)},
                @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        case NTESLDSDKError:
            callbackDict = @{
                @"data":@{@"message": @"SDK内部错误",@"code":@(-1)},
                @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        case NTESLDCameraNotAvailable:
            callbackDict = @{
                 @"data":@{@"message": @"App未获取相机权限",@"code":@(-1)},
                 @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        default:
            callbackDict = @{
                 @"data":@{@"message": @"未知错误",@"code":@(-1)},
                 @"method":@"onError",
            };
            if ([AliveFlutterPlugin sharedInstance].eventSink) {
                [AliveFlutterPlugin sharedInstance].eventSink(callbackDict);
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
    }
}

@end
