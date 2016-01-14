//
//  BaiduPush.m
//
//
//  Created by xyz on 15/7/1.
//
//

#import "BaiduPush.h"
#import "Cordova/CDV.h"
#import "AppDelegate.h"

@implementation BaiduPush


+ (void)setLaunchOptions:(NSDictionary *)options
{
    launchOptions = options;
    setFlag = true;
}

+ (void)receiveNotification:(NSDictionary *)userInfo inBackground:(BOOL)background
{
    if(delegate == nil){
        return;
    }

    if(arriveCallback != nil){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
        [pluginResult setKeepCallbackAsBool:true];
        [delegate sendPluginResult:pluginResult callbackId:arriveCallback.callbackId];
    }

    if(clickCallback != nil && background){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [delegate sendPluginResult:pluginResult callbackId:clickCallback.callbackId];
    }

}



- (void)startWork:(CDVInvokedUrlCommand*)command
{
    NSLog(@"startWork");
    delegate = self.commandDelegate;

    [self returnNoResult:command];


    NSString* apikey = [command.arguments objectAtIndex:0];
    if(apikey == nil || apikey.length == 0 || !setFlag){
        //NSLog(@"something error");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }

        //
        [BPush registerChannel:launchOptions apiKey:apikey pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:false];

        //
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            NSLog(@"Bind channel id");
            NSLog(@"%@", result);

            //
            NSDictionary *jsondata = [NSDictionary dictionaryWithObjectsAndKeys:
                        [BPush getAppId], @"appId",
                        [BPush getChannelId], @"channelId",
                        [BPush getUserId], @"userId",
                        @"4", @"deviceType",
                        [result objectForKey:@"error_code"], @"errorCode",
                        [result objectForKey:@"request_id"], @"requestId", nil];

            NSDictionary *jsonResult = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"onBind", @"type",
                          jsondata, @"data",
                          nil];

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonResult];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
}



- (void)stopWork:(CDVInvokedUrlCommand*)command
{
    NSLog(@"stopWork");
    [self returnNoResult:command];
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        NSLog(@"%@", result);
        //组装返回的json数据
        NSDictionary *jsondata = [NSDictionary dictionaryWithObjectsAndKeys:
                    [result objectForKey:@"error_code"], @"errorCode",
                    [result objectForKey:@"request_id"], @"requestId",
                    nil];

        NSDictionary *jsonResult = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"onUnbind", @"type",
                      jsondata, @"data",
                      nil];


        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonResult];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)resumeWork:(CDVInvokedUrlCommand*)command
{
    NSLog(@"resumeWork");
    [self returnNoResult:command];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        //组装返回的json数据
        NSDictionary *jsondata = [NSDictionary dictionaryWithObjectsAndKeys:
                    [result objectForKey:@"error_code"], @"errorCode",
                    [result objectForKey:@"request_id"], @"requestId",
                    nil];

        NSDictionary *jsonResult = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"onUnbind", @"type",
                      jsondata, @"data",
                      nil];


        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonResult];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)setTags:(CDVInvokedUrlCommand *)command
{
    NSLog(@"setTags");
    [self returnNoResult:command];
    NSArray* tags = [command.arguments objectAtIndex:0];

    [BPush setTags:tags withCompleteHandler:^(id result, NSError *error) {
        NSLog(@"setTags");
        NSLog(@"%@", result);


        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self analyzeTags:result type:@"onSetTags"]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)delTags:(CDVInvokedUrlCommand *)command
{
    NSLog(@"delTags");
    [self returnNoResult:command];
    NSArray* tags = [command.arguments objectAtIndex:0];

    [BPush delTags:tags withCompleteHandler:^(id result, NSError *error) {
        NSLog(@"delTags");
        NSLog(@"%@", result);

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self analyzeTags:result type:@"onDelTags"]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}


- (void)listTags:(CDVInvokedUrlCommand*)command
{
    NSLog(@"listTags");
    [self returnNoResult:command];

    [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
        NSLog(@"listTags");
        NSLog(@"%@", result);

        NSMutableArray *tags = [NSMutableArray arrayWithCapacity: 0];
        NSArray *response_tags = [[result objectForKey:@"response_params"] objectForKey:@"tags"];
        for(id tag in response_tags){
            [tags addObject:[tag objectForKey:@"name"]];
        }


        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              tags, @"tags",
                              [result objectForKey:@"error_code"], @"errorCode",
                              [result objectForKey:@"request_id"], @"requestId", nil];

        NSDictionary *jsonResult = [NSDictionary dictionaryWithObjectsAndKeys:
                                    data, @"data",
                                    @"onListTags", @"type", nil];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonResult];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)listenNotificationClicked:(CDVInvokedUrlCommand *)command
{
    [self returnNoResult:command];
    clickCallback = command;
}


- (void) listenNotificationArrived:(CDVInvokedUrlCommand *)command
{
    [self returnNoResult:command];
    arriveCallback = command;
}


- (void) returnNoResult:(CDVInvokedUrlCommand *)command
{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallbackAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (NSDictionary*) analyzeTags:(id) result type:(NSString *) type
{
    NSArray *array = [[result objectForKey:@"response_params"] objectForKey:@"details"];
    NSMutableArray *successTags = [NSMutableArray arrayWithCapacity: 0];
    NSMutableArray *failTags = [NSMutableArray arrayWithCapacity: 0];

    for(id details in array){
        //NSLog(@"details.result = %@", [details objectForKey:@"result"]);
        if([[details objectForKey:@"result"] integerValue] == 0){
            [successTags addObject:[details objectForKey:@"tag"]];
        }
        else{
            [failTags addObject:[details objectForKey:@"tag"]];
        }
    }

    NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:
                              successTags, @"successTags",
                              failTags, @"failTags",
                              [result objectForKey:@"error_code"], @"errorCode",
                              [result objectForKey:@"request_id"], @"requestId", nil];

    NSDictionary *jsonResult = [NSDictionary dictionaryWithObjectsAndKeys:
                                type, @"type",
                                jsonData, @"data", nil];

    //NSLog(@"jsonResult = %@", jsonResult);
    return jsonResult;
}


@end
