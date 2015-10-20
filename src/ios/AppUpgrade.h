#import <Cordova/CDVPlugin.h>

@interface AppUpgrade : CDVPlugin
{
    NSString *_upgradeURL;
}
@property(nonatomic,strong)NSString * upgradeURL;

- (void)checkUpdate:(CDVInvokedUrlCommand*) command;

- (void)getAppName:(CDVInvokedUrlCommand*)command;

- (void)getPackageName:(CDVInvokedUrlCommand*)command;

- (void)getVersionNumber:(CDVInvokedUrlCommand*)command;

- (void)getVersionCode:(CDVInvokedUrlCommand*)command;

@end