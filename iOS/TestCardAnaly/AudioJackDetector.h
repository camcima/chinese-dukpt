//
//  AudioJackDetector.h
//  Passive CardReader
//
//  Created by Thomas Ploentzke on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kInfoDictKeyInputSources @"InputSources"            //NSDict
#define kInfoDictKeyOutputDestinations @"OutputDestinations"            //NSDict
#define kInfoDictKeyBlockSize @"BlockSize"                  //NSNumber
#define kInfoDictKeySampleRate @"SampleRate"                //NSNumber
#define kInfoDictKeyInChannels @"InChannels"                //NSNumber
#define kInfoDictKeyOutChannels @"OutChannels"              //NSNumber
#define kInfoDictKeyInputRoute @"AudioRouteIn"              //NSString
#define kInfoDictKeyOutputRoute @"AudioRouteOut"            //NSString
#define kInfoDictKeyLastStatus @"LastStatusMessage"         //NSString
#define kInfoDictKeyCurrentStaus @"CurrentStatusMessage"    //NSString

#define AudioJackDetectorChangeNotification @"AudioJackDetectorChangeNotification"
#define AudioJackDetectorChangeNotificationStatusKey @"deviceStatus"


@protocol AudioJackDetectorDelegate <NSObject>

- (void)deviceChangedToStatus:(BOOL)status;

@end

@interface AudioJackDetector : NSObject
{
    BOOL _notifsAreSet;
}

-(id) init;
-(id) initWithDelegate:(id)delegate;
-(void) updateDeviceInfos:(NSString*)newMessage;
-(void) startUpCheck:(NSTimer*)timer;

@property (nonatomic, assign) BOOL iOSFive;
@property (nonatomic, retain) NSMutableDictionary* infoDesc;
@property (nonatomic, assign) UInt32 inChannels;
@property (nonatomic, assign) UInt32 outChannels;
@property (nonatomic, assign) float sampleRate;
@property (nonatomic, assign) float blockSize;
@property (nonatomic, assign) BOOL deviceAvailable;
@property (nonatomic, assign) id <AudioJackDetectorDelegate> delegate;

@end


