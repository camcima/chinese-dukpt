/*
 *  AudioAnalyInterface.h
 *  CardAnalyLib1
 *
 *  Created by Bruce on 11-8-1.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#include "AudioAnalyData.h"

@interface AudioAnalyInterface : NSObject {
	id delegate;
	SEL OnRecvCardData;
    SEL OnSwipeCompleted;
    SEL OnSwipeError;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnRecvCardData;
@property (nonatomic, assign) SEL OnSwipeCompleted;
@property (nonatomic, assign) SEL OnSwipeError;
@property (nonatomic, assign) SEL OnEncryptingData;
@property (nonatomic, assign) SEL OnError;
@property (nonatomic, assign) SEL OnTimeout;
@property (nonatomic, assign) SEL OnInterrupted;
@property (nonatomic, assign) SEL OnNoDevicePluggedIn;
@property (nonatomic, assign) BOOL IsDevicePluggedIn;

- (void)OnRecvCard:(const unsigned char *)str;
- (void)OnSwipe:(const unsigned char *)str;
- (void)OnSwipeEOR:(const int )str;
- (void)SendUserData:(int)iType :(unsigned char *)pData :(int)iDataLen;
- (void)StartDevice;
- (void)StopDevice;
- (void)WaitForSwipe:(uint)uiSec;
- (void)getResults;


@end