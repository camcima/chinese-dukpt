//
//  AudioAnalyLib.h
//  CardAnalyLib1
//
//  Created by Bruce on 11-8-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioAnalyData.h"

@interface AudioAnalyLib : NSObject {
	id delegate;
	SEL OnRecvCardData;
    SEL OnSwipeCompleted;
    SEL OnSwipeError;
    SEL OnEncryptingData;
    SEL OnError;
    SEL OnTimeout;
    SEL OnInterrupted;
    SEL OnNoDevicePluggedIn;
}

@property (nonatomic, assign) 	id delegate;
@property (nonatomic, assign) 	SEL OnRecvCardData;
@property (nonatomic, assign)   SEL OnSwipeCompleted;
@property (nonatomic, assign)   SEL OnSwipeError;
@property (nonatomic, assign)   SEL OnEncryptingData;
@property (nonatomic, assign)   SEL OnError;
@property (nonatomic, assign)   SEL OnTimeout;
@property (nonatomic, assign)   SEL OnInterrupted;
@property (nonatomic, assign)   SEL OnNoDevicePluggedIn;
@property (nonatomic, assign) 	BOOL IsDevicePluggedIn;

- (void)GetVersion;
- (void)GetKSN;
- (void)SetCDKey:(unsigned char *)pKey;
- (void)SetKSN:(unsigned char *)pKsn;
- (void)SetSecret:(BOOL)bSecret;
- (void)StartDevice;
- (void)StopDevice;
- (void)WaitForSwipe:(uint)uiSec;
- (void)getResults;



@end
