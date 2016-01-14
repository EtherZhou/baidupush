//
//  BaiduPush.h
//
//
//  Created by xyz on 15/7/1.
//
//

#ifndef _____BaiduPush_h
#define _____BaiduPush_h

#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>
#import "BPush.h"

static NSDictionary *launchOptions = nil;
static BOOL setFlag = false;
static CDVInvokedUrlCommand *clickCallback = nil;
static CDVInvokedUrlCommand *arriveCallback = nil;
static CDVPluginResult *pluginResult = nil;
static id delegate = nil;

@interface BaiduPush : CDVPlugin

+ (void)setLaunchOptions:(NSDictionary*)options;

+ (void)receiveNotification:(NSDictionary *)userInfo inBackground:(BOOL) background;

- (void)startWork:(CDVInvokedUrlCommand*)command;

- (void)stopWork:(CDVInvokedUrlCommand*)command;

- (void)resumeWork:(CDVInvokedUrlCommand*)command;

- (void)setTags:(CDVInvokedUrlCommand*)command;

- (void)delTags:(CDVInvokedUrlCommand*)command;

- (void)listTags:(CDVInvokedUrlCommand*)command;

- (void)listenNotificationClicked:(CDVInvokedUrlCommand*)command;

- (void)listenNotificationArrived:(CDVInvokedUrlCommand*)command;


@end


#endif
