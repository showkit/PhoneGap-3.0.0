//
//  ShowKitPlugin.m
//  ShowKit-PhoneGapPlugin
//
//  Created by Yue Chang Hu on 5/3/13.
//
//

#import "ShowKitPlugin.h"
#import <ShowKit/ShowKit.h>

@implementation ShowKitPlugin

#pragma showkit initialize methods

- (void)initializeShowKit:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    API_KEY = [[NSString alloc] initWithString:(NSString *)[command.arguments objectAtIndex:0]];
    
    [self setupConferenceUIViews];
    
    if (API_KEY != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKUserMessageReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKRemoteClientStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChanged:) name:SHKConnectionStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMessageReceived:) name:SHKUserMessageReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteClientStatusChanged:) name:SHKRemoteClientStateChangedNotification object:nil];
}

#pragma conference view methods

- (void)setupConferenceUIViews
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    
    if (self.mainVideoUIView == nil)
    {
        self.mainVideoUIView = [[UIView alloc] initWithFrame: CGRectMake(0,0,screenWidth,screenheight)];
        [self.mainVideoUIView setBackgroundColor:[UIColor blackColor]];
        [self.viewController.view addSubview: self.mainVideoUIView];
        [self.mainVideoUIView setHidden:YES];
        [ShowKit setState:self.mainVideoUIView forKey:SHKMainDisplayViewKey];
    }
    
    if (self.prevVideoUIView == nil)
    {
        self.prevVideoUIView = [[UIView alloc] initWithFrame: CGRectMake(220,20,0.25*screenWidth,0.2*screenheight)];
        [self.viewController.view addSubview: self.prevVideoUIView];
        [self.prevVideoUIView setHidden:YES];
        [ShowKit setState:self.prevVideoUIView forKey:SHKPreviewDisplayViewKey];
    }
    
    if (self.menuUIView == nil)
    {
        self.menuUIView = [[UIView alloc] initWithFrame: CGRectMake(0,screenheight - 66,screenWidth,44)];
        [self.viewController.view addSubview: self.menuUIView];
        
        self.hangupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.hangupButton setTitle:@"End" forState:UIControlStateNormal];
        [self.hangupButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.hangupButton];
        
        CGRect bounds = [[self.hangupButton superview] bounds];
        [self.hangupButton setCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))];
        
        self.toggleMuteAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.toggleMuteAudioButton setTitle:@"Audio On" forState:UIControlStateNormal];
        [self.toggleMuteAudioButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.toggleMuteAudioButton];
        
        self.toggleCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, 0, 100, 44)];
        [self.toggleCameraButton setTitle:@"FCamera" forState:UIControlStateNormal];
        [self.toggleCameraButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.toggleCameraButton];
        
        
        [self.hangupButton addTarget:self action:@selector(hangupCall:) forControlEvents:UIControlEventTouchUpInside];
        [self.toggleCameraButton addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self.toggleMuteAudioButton addTarget:self action:@selector(toggleMuteAudio:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.menuUIView setHidden:YES];
    }
    
    [ShowKit setState:SHKVideoLocalPreviewEnabled forKey:SHKVideoLocalPreviewModeKey];
}

- (void) hideMainVideoUIView:(CDVInvokedUrlCommand*)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *hide = (NSNumber *)[command.arguments objectAtIndex:0];
        [self.mainVideoUIView setHidden:[hide boolValue]];
    });
}

- (void) hidePrevVideoUIView:(CDVInvokedUrlCommand*)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *hide = (NSNumber *)[command.arguments objectAtIndex:0];
        [self.prevVideoUIView setHidden:[hide boolValue]];
    });
}

- (void) hideMenuUIView:(CDVInvokedUrlCommand *)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *hide = (NSNumber *)[command.arguments objectAtIndex:0];
        [self.menuUIView setHidden:[hide boolValue]];
    });
}


#pragma mark login methods

- (void)login:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    NSString *password = (NSString *)[command.arguments objectAtIndex:1];
    
    if (username != nil && password != nil && username != [NSNull null] && password != [NSNull null] && [username length] > 0 && [password length] > 0) {
        [ShowKit login:username password:password withCompletionBlock:^(NSString* const connectionStatus) {
            if ([connectionStatus isEqualToString:SHKConnectionStatusLoggedIn]) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SHKConnectionStatusLoggedIn"];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"SHKConnectionStatusLoginFailed"];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid username or password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}



#pragma mark register methods

- (void)registerUser:(CDVInvokedUrlCommand*)command
{
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    NSString *password = (NSString *)[command.arguments objectAtIndex:1];
    
    if([username length] > 0 && [password length] > 0)
    {
        __block CDVPluginResult* pluginResult = nil;
        
        [ShowKit registerUser:username
                     password:password
                       apiKey:API_KEY
          withCompletionBlock:^(NSString *username, NSError *error) {
              NSArray *result;
              if(error == nil)
              {
                  result = [NSArray arrayWithObjects:username,[NSNull null],nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
              }else{
                  result = [NSArray arrayWithObjects:[NSNull null],error.localizedDescription,nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:result];
              }
              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username and password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)registerSubscriber:(CDVInvokedUrlCommand*)command
{
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    NSString *password = (NSString *)[command.arguments objectAtIndex:1];
    
    if([username length] > 0 && [password length] > 0)
    {
        __block CDVPluginResult* pluginResult = nil;
        
        [ShowKit registerSubscriber:username
                     password:password
                       apiKey:API_KEY
          withCompletionBlock:^(NSString *username, NSError *error) {
              NSArray *result;
              if(error == nil)
              {
                  result = [NSArray arrayWithObjects:username,[NSNull null],nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
              }else{
                  result = [NSArray arrayWithObjects:[NSNull null],error.localizedDescription,nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:result];
              }
              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username and password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


#pragma conference calling methods

- (void)initiateCallWithUser:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    if (username != nil) {
        [ShowKit setState:self.prevVideoUIView forKey:SHKPreviewDisplayViewKey];
        [self.mainVideoUIView setHidden:NO];
        [self.prevVideoUIView setHidden:NO];
        [self.menuUIView setHidden:NO];
        [ShowKit initiateCallWithUser:username];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hihihi"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)initiateCallWithSubscriber:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    if (username != nil) {
        [ShowKit setState:self.prevVideoUIView forKey:SHKPreviewDisplayViewKey];
        [self.mainVideoUIView setHidden:NO];
        [self.prevVideoUIView setHidden:NO];
        [self.menuUIView setHidden:NO];
        [ShowKit initiateCallWithSubscriber:username];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hihihi"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)acceptCall:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    [ShowKit acceptCall];
    [self.mainVideoUIView setHidden:NO];
    [self.prevVideoUIView setHidden:NO];
    [self.menuUIView setHidden:NO];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)rejectCall:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    [ShowKit rejectCall];
    [self.mainVideoUIView setHidden:YES];
    [self.prevVideoUIView setHidden:YES];
    [self.menuUIView setHidden:YES];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hangupCall:(CDVInvokedUrlCommand*)command
{
    [ShowKit hangupCall];
    [self.mainVideoUIView setHidden:YES];
    [self.prevVideoUIView setHidden:YES];
    [self.menuUIView setHidden:YES];
}

- (void)logout:(CDVInvokedUrlCommand*)command
{
    [ShowKit logout];
}



#pragma mark audio state changed methods

- (void)toggleMuteAudio:(CDVInvokedUrlCommand*)command
{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.curiousminds.showkit_phonegapplugin", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* audio_state = (NSString*)[ShowKit getStateForKey: SHKAudioInputModeKey];
            if([audio_state isEqualToString: SHKAudioInputModeRecording])
            {
                [self.toggleMuteAudioButton setTitle:@"Muted" forState:UIControlStateNormal];
                [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
            } else {
                [self.toggleMuteAudioButton setTitle:@"Audio On" forState:UIControlStateNormal];
                [ShowKit setState: SHKAudioInputModeRecording forKey: SHKAudioInputModeKey];
            }
        });
    });
}



#pragma mark camera state changed methods

- (void)toggleCamera:(CDVInvokedUrlCommand*)command
{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.curiousminds.showkit_phonegapplugin", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            id sourceInput = [ShowKit getStateForKey:SHKVideoInputDeviceKey];
            if (sourceInput == SHKVideoInputDeviceBackCamera)
            {
                [self.toggleCameraButton setTitle:@"FCamera" forState:UIControlStateNormal];
                [ShowKit setState: SHKVideoInputDeviceFrontCamera forKey: SHKVideoInputDeviceKey];
            }else{
                [self.toggleCameraButton setTitle:@"BCamera" forState:UIControlStateNormal];
                [ShowKit setState: SHKVideoInputDeviceBackCamera forKey: SHKVideoInputDeviceKey];
            }
        });
    });
}


#pragma mark device torch changed methods

- (void)setDeviceTorch:(CDVInvokedUrlCommand*)command
{
    NSString* torchMode = (NSString *)[command.arguments objectAtIndex:0];
    
    if (torchMode != nil)
    {
        if ([torchMode isEqualToString:@"SHKTorchModeOff"]) {
            [ShowKit setState: SHKTorchModeOff forKey: SHKTorchModeKey];
        }else if([torchMode isEqualToString:@"SHKTorchModeOn"]){
            [ShowKit setState: SHKTorchModeOn forKey: SHKTorchModeKey];
        }else if([torchMode isEqualToString:@"SHKTorchModeAuto"]){
            [ShowKit setState: SHKTorchModeAuto forKey: SHKTorchModeKey];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device does not support torch mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            //            [alert release];
        }
    }
}



#pragma mark notification state changed methods

- (void) connectionStateChanged: (NSNotification*) notification
{
    SHKNotification *showNotice = (SHKNotification*) [notification object];
    NSString *value = (NSString*)showNotice.Value;
    NSError *error = (NSError *)[showNotice UserObject];
    NSString *callee = (NSString *)[showNotice UserObject];
    
    if ([value isEqualToString:SHKConnectionStatusCallTerminated]){
        [self.mainVideoUIView setHidden:YES];
        [self.prevVideoUIView setHidden:YES];
        [self.menuUIView setHidden:YES];
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if([value isEqualToString:SHKConnectionStatusCallTerminating])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if ([value isEqualToString:SHKConnectionStatusInCall])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if ([value isEqualToString:SHKConnectionStatusLoggedIn])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if ([value isEqualToString:SHKConnectionStatusNotConnected])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value,  NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if ([value isEqualToString:SHKConnectionStatusLoginFailed])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%d','%@']))", value,  NULL, error.code, error.localizedDescription] waitUntilDone:NO];
        
    } else if ([value isEqualToString:SHKConnectionStatusCallIncoming])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, callee, NULL, NULL] waitUntilDone:NO];
        
    } else if([value isEqualToString:SHKConnectionStatusCallOutgoing])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL] waitUntilDone:NO];
        
    } else if([value isEqualToString:SHKConnectionStatusCallFailed])
    {
        
        [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%d','%@']))", value,  NULL, error.code, error.localizedDescription] waitUntilDone:NO];
        
    }
}

- (void) executeJavascriptOnMainThread:(NSString *) javascript
{
    [self writeJavascript:javascript];
}

- (void) userMessageReceived: (NSNotification*) n
{
    SHKNotification* s ;
    NSData*          v ;
    NSDictionary*        msg;
    
    s = (SHKNotification*) [n object];
    v = (NSData*)s.Value;
    msg = [self NSDataToNSDictionary:v];
    __block NSString  * message = [msg objectForKey:@"msg"];
    
    [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"userMessageReceived('%@')", message] waitUntilDone:NO];
}

- (void) remoteClientStatusChanged: (NSNotification*) n
{
    SHKNotification* s;
    NSString*        status;
    
    s = (SHKNotification*) [n object];
    status = (NSString*)s.Value;
    
    [self performSelectorOnMainThread:@selector(executeJavascriptOnMainThread:) withObject:[NSString stringWithFormat:@"remoteClientStatusChanged('%@')", status] waitUntilDone:NO];
}



#pragma mark showkit notification methods

- (void)enableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChanged:) name:SHKConnectionStatusChangedNotification object:nil];
}

- (void)disableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
}

- (void)enableUserMessageReceivedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKUserMessageReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMessageReceived:) name:SHKUserMessageReceivedNotification object:nil];
}

- (void)disableUserMessageReceivedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKUserMessageReceivedNotification object:nil];
}

- (void)enableRemoteClientStateChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKRemoteClientStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteClientStatusChanged:) name:SHKRemoteClientStateChangedNotification object:nil];
}

- (void)disableRemoteClientStateChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKRemoteClientStateChangedNotification object:nil];
}

- (void) localNotification:(CDVInvokedUrlCommand*)command
{
    NSString *message = (NSString *)[command.arguments objectAtIndex:0];
    NSString *soundName = (NSString *)[command.arguments objectAtIndex:1];
    
    if([UIApplication sharedApplication].applicationState  == UIApplicationStateBackground)
    {
        UILocalNotification* ln = [[UILocalNotification alloc] init];
        ln.fireDate = [NSDate date];
        ln.alertBody = message;
        ln.soundName = soundName;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] scheduleLocalNotification:ln];
    }
}



#pragma mark showkit set states methods

- (void) setState:(CDVInvokedUrlCommand*)command
{
    NSString *key = (NSString *)[command.arguments objectAtIndex:0];
    NSString *value = (NSString *)[command.arguments objectAtIndex:1];
    [ShowKit setState: value forKey: key];
}

- (void) getState:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *key = (NSString *)[command.arguments objectAtIndex:0];
    NSString *status = [ShowKit getStateForKey:key];
    if(status != NULL)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:status];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



#pragma mark sendSHKmessage methods

- (void) sendMessage:(CDVInvokedUrlCommand*)command
{
    NSString *msg = (NSString *)[command.arguments objectAtIndex:0];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
    NSData *data = [self NSDictionaryToNSData:message];
    [ShowKit sendMessage:data];
}

- (NSDictionary *)NSDataToNSDictionary:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dictionary = [unarchiver decodeObjectForKey: @"skmessage"];
    [unarchiver finishDecoding];
    return dictionary;
}

- (NSData *)NSDictionaryToNSData:(NSDictionary *)dictionary
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:@"skmessage"];
    [archiver finishEncoding];
    return data;
}


@end
