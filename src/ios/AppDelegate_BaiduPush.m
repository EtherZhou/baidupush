//
//  AppDelegate_BaiduPush.m
//
//
//  Created by xyz on 15/7/1.
//
//
#import "AppDelegate_BaiduPush.h"
#import "MainViewController.h"
#import "BPush.h"
#import "BaiduPush.h"

@implementation AppDelegate(Notification)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
{

    CGRect screenBounds = [[UIScreen mainScreen] bounds];

#if __has_feature(objc_arc)
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;

#if __has_feature(objc_arc)
    self.viewController = [[MainViewController alloc] init];
#else
    self.viewController = [[[MainViewController alloc] init] autorelease];
#endif

    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";

    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [BaiduPush setLaunchOptions:launchOptions];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];


    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];
    NSLog(@"%@",userInfo);


    [BaiduPush receiveNotification:userInfo inBackground:([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end