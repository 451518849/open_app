#import "OpenAppPlugin.h"


@interface OpenAppPlugin()
@property (nonatomic, copy) FlutterResult completedBlock;
@end

@implementation OpenAppPlugin

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static OpenAppPlugin *instance;
    dispatch_once(&onceToken, ^{
        instance = [[OpenAppPlugin alloc] init];
    });
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"open_app"
            binaryMessenger:[registrar messenger]];
  OpenAppPlugin* instance = [[OpenAppPlugin alloc] init];
    instance = [OpenAppPlugin defaultManager];
    [registrar addApplicationDelegate:instance];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"openApp" isEqualToString:call.method]){
          NSString *openUrl = call.arguments[@"openUrl"];
          [self openUrl:openUrl completed:result];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)openUrl:(NSString *)openUrl completed:(FlutterResult)completedBlock{
    if(completedBlock){
        
        //这里不能使用self.completedBlock，因为调用当前方法的对象由系统创建，并不是单例
        [OpenAppPlugin defaultManager].completedBlock = [completedBlock copy];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
}

-(BOOL)handleOpenURL:(NSURL *)url{

    //这个方法有我们自己控制，因此可以保证是单例，可以使用self.completedBlock
    if(self.completedBlock) {
        NSLog(@"completedBlock");
        self.completedBlock(url.absoluteURL.absoluteString);
        return YES;
    }

    return NO;
}


/** iOS9及以后 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"callback1");
    BOOL result = [[OpenAppPlugin defaultManager] handleOpenURL:url];
    if (!result) {//这里处理其他SDK(例如QQ登录,微博登录等)
        
    }
    return result;
}

/** iOS9以下 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"callback2");
    BOOL result = [[OpenAppPlugin defaultManager] handleOpenURL:url];
    if (!result) {//这里处理其他SDK(例如QQ登录,微博登录等)
        
    }
    return result;
}

@end
