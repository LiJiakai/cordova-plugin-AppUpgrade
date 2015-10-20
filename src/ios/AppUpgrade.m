/********* AppUpgrade.m Cordova Plugin Implementation *******/

#import "AppUpgrade.h"
#import <Cordova/CDVPluginResult.h>
#import "AFNetworking.h"

static NSString *UpgradeURL = @"http://www.niuqia.com/ios/getAppUpgradeURL";//获取更新URL的ajax或restful接口地址
static NSString *VersionURL = @"http://www.niuqia.com/ios/getAppVersion";//获取最新app版本的ajax或restful接口地址

@implementation AppUpgrade

@synthesize upgradeURL=_upgradeURL;

- (void) checkUpdate:(CDVInvokedUrlCommand*) command{
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    if(localVersion == nil){
        localVersion = [[[NSBundle mainBundle] infoDictionary]objectForKeyedSubscript:@"CFBundleVersion"];
        if(localVersion == nil){
            NSLog(@"No local version info exist!");
            [self constructErrorResult:@"本地无版本信息" callback:command.callbackId];
            return;
        }
    }
    
    NSURL * getVersionURL = [NSURL URLWithString:VersionURL];
    NSURLRequest * versionRequest = [NSURLRequest requestWithURL:getVersionURL];
    AFHTTPRequestOperation * versionRequestOperion = [[AFHTTPRequestOperation alloc] initWithRequest:versionRequest];
    versionRequestOperion.responseSerializer = [AFJSONResponseSerializer serializer];
    [versionRequestOperion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        NSNumber *result = [responseObject valueForKey:@"result"];
        if([result intValue] != 1){
            NSString * message = responseObject[@"message"];
            NSLog(message);
            [self constructErrorResult:message callback:command.callbackId];
            return;
        }
        
        NSString * newVersion = responseObject[@"mdata"][@"version"];
        if (![newVersion isEqualToString:localVersion]) {
            [self showUpgradeView:command.callbackId];
            return;
        }
        [self contructSuccessResult:0 callback:command.callbackId];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求最新版本信息有误！");
        [self constructErrorResult:@"请求最新版本信息有误" callback:command.callbackId];
        return;
    }];
    [[NSOperationQueue mainQueue] addOperation:versionRequestOperion];
}

- (void) showUpgradeView:(NSString *) callbackId{
    NSURL * getUpgradeURL = [NSURL URLWithString:UpgradeURL];
    NSURLRequest *upgradeURLRequest = [NSURLRequest requestWithURL:getUpgradeURL];
    AFHTTPRequestOperation *upgradeURLOperation = [[AFHTTPRequestOperation alloc]initWithRequest:upgradeURLRequest];
    upgradeURLOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [upgradeURLOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        NSNumber *result = [responseObject valueForKey:@"result"];
        if([result intValue] != 1){
            NSString * message = responseObject[@"messge"];
            NSLog(message);
            [self constructErrorResult:message callback:callbackId];
            return;
        }
        
        NSString *upgradeURL = responseObject[@"mdata"][@"upgradeURL"];
        [self setUpgradeURL:upgradeURL];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"版本有更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
        [alertView show];
        
        [self contructSuccessResult:1 callback:callbackId];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        NSLog(@"获取更新URL出错！");
        [self constructErrorResult:@"获取更新URL出错" callback:callbackId];
    }];
    [[NSOperationQueue mainQueue] addOperation:upgradeURLOperation];
}

- (void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSURL *upgradeURL = [NSURL URLWithString:self.upgradeURL];
        [[UIApplication sharedApplication]openURL:upgradeURL];
    }
    exit(0);
    
}

- (void) constructErrorResult:(NSString *)message callback:(NSString *)callbackId{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)contructSuccessResult:(int) updateFlag callback:(NSString *)callbackId{
    NSMutableDictionary * resultInfoDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [resultInfoDictionary setObject:[NSNumber numberWithInt:updateFlag] forKey:@"update"];
    NSDictionary * resultInfo = [NSDictionary dictionaryWithDictionary:resultInfoDictionary];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultInfo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)getAppName:(CDVInvokedUrlCommand*)command{
    NSString *callbackId = command.callbackId;
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:appName];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)getPackageName:(CDVInvokedUrlCommand*)command{
    NSString *callbackId = command.callbackId;
    NSString *packageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:packageName];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)getVersionNumber:(CDVInvokedUrlCommand*)command{
    NSString *callbackId = command.callbackId;
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (versionNumber == nil) {
        NSLog(@"No short version string exist!");
         versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if (versionNumber == nil) {
            NSLog(@"No version number info exist!");
        }
        
    }
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:versionNumber];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)getVersionCode:(CDVInvokedUrlCommand*)command{
    NSString *callbackId = command.callbackId;
    NSString *versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:versionCode];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}
@end