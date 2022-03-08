#import <Flutter/Flutter.h>

@interface OpenAppPlugin : NSObject<FlutterPlugin>
+(instancetype)defaultManager;
-(BOOL)handleOpenURL:(NSURL *)url;
@end
