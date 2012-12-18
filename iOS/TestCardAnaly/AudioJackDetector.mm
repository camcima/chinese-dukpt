//
//  AudioJackDetector.m
//  Passive CardReader
//
//  Created by Thomas Ploentzke on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioJackDetector.h"
#import "CAXException.h"

@implementation AudioJackDetector

@synthesize sampleRate = _sampleRate;
@synthesize infoDesc = _infoDesc;
@synthesize inChannels = _inChannels;
@synthesize outChannels = _outChannels;
@synthesize blockSize = _blockSize;
@synthesize iOSFive = _iOSFive;
@synthesize delegate = _delegate;
@synthesize deviceAvailable = _deviceAvailable;

void audioJackDetectorPropListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inPropertyValueSize,
                  const void *            inPropertyValue);

void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState);


-(id) initWithDelegate:(id)delegate
{
    _delegate = delegate;
    
    return [self init];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.infoDesc = [NSMutableDictionary dictionaryWithCapacity:6];
        
        NSMutableArray* inputS = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray* outputD = [NSMutableArray arrayWithCapacity:3];
        
        [_infoDesc setObject:inputS forKey:kInfoDictKeyInputSources];
        [_infoDesc setObject:outputD forKey:kInfoDictKeyOutputDestinations];
        
        [_infoDesc setObject:@"" forKey:kInfoDictKeyCurrentStaus];
        
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        
        //    NSLog(@"---------------------------------------------");
        //    NSLog(@"Runing System : %@",currSysVer);
        //    NSLog(@"---------------------------------------------");
        
        _iOSFive = FALSE;
    /*
        if (([[currSysVer substringWithRange:NSMakeRange(0,2)] compare:@"4."] == NSOrderedSame))//||([[currSysVer substringWithRange:NSMakeRange(0,2)] compare:@"6."] == NSOrderedSame)
        {
            _iOSFive = FALSE;
        }
       */
        self.deviceAvailable = FALSE;
        
        // try to set Session deactive 
        // just to check if there a allready a initialized audio session
        
        
        
        OSStatus error = AudioSessionSetActive(false);
        
        if (error == 0x21696e69)
        {
            // Need to initialize session
            
            error = AudioSessionInitialize(NULL, NULL, interruptionListener, (__bridge void*) self);
            if (error) printf("ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
        }
        
//        NSError	*err = nil;
        
        UInt32 audioCat = kAudioSessionCategory_PlayAndRecord;
        UInt32 size = sizeof(audioCat);
        
        error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, size, &audioCat);
        if (error) printf("ERROR SET AUDIO SESSION CATEGORY! %ld\n", error);

        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, audioJackDetectorPropListener, (__bridge void *)self);
        if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
        
        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioJackDetectorPropListener, (__bridge void *)self);
        if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER AudioRouteChange! %ld\n", error);
        
        if (_iOSFive)
        {
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_InputSources, audioJackDetectorPropListener, (__bridge void *)self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER InputSources! %ld\n", error);
            
            
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_OutputDestinations, audioJackDetectorPropListener, (__bridge void *)self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER OutputDestinations! %ld\n", error);
            
            
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_InputGainAvailable, audioJackDetectorPropListener, (__bridge void *)self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER InputGainAvailable! %ld\n", error);
            
            
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_InputGainScalar, audioJackDetectorPropListener, (__bridge void *)self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER InputGainScalar! %ld\n", error);
        }
        
        _notifsAreSet = TRUE;
        
    }
    
    
    // after init 
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startUpCheck:) userInfo:nil repeats:NO];
    
    return self;
}

- (void)dealloc
{
    
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioInputAvailable, audioJackDetectorPropListener, (__bridge void *)self);
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioJackDetectorPropListener, (__bridge void *)self);
    
    if (_iOSFive)
    {
        AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_InputSources, audioJackDetectorPropListener, (__bridge void *)self);
        AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_OutputDestinations, audioJackDetectorPropListener, (__bridge void *)self);
        AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_InputGainAvailable, audioJackDetectorPropListener, (__bridge void *)self);
        AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_InputGainScalar, audioJackDetectorPropListener, (__bridge void *)self);
    }
    [super dealloc];
}

void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{

	}
	else if (inInterruptionState == kAudioSessionEndInterruption)
	{

	}
}

void audioJackDetectorPropListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inPropertyValueSize,
                  const void *            inPropertyValue)
{
    printf("Session Property Listener!\n");
    NSString* newMess = [NSString stringWithFormat:@"PropertyListener :\n"];
    
	AudioJackDetector *thisAudioEngine = (__bridge AudioJackDetector*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		try {
            
            // Determines the reason for the route change, to ensure that it is not
            //		because of a category change.
            CFDictionaryRef	routeChangeDictionary = (CFDictionaryRef) inPropertyValue;
            
            CFNumberRef routeChangeReasonRef = (CFNumberRef) CFDictionaryGetValue (routeChangeDictionary,CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
            
            SInt32 routeChangeReason;
            
            CFNumberGetValue (routeChangeReasonRef,kCFNumberSInt32Type,&routeChangeReason);
            
            // "Old device unavailable" indicates that a headset was unplugged, or that the
            //	device was removed from a dock connector that supports audio output. This is
            //	the recommended test for when to pause audio.
            
            switch (routeChangeReason) {
                default: kAudioSessionRouteChangeReason_Unknown:

                    NSLog (@"kAudioSessionRouteChangeReason_Unknown");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange Reason_Unknown"];
                    break;
                case kAudioSessionRouteChangeReason_NewDeviceAvailable:
                    NSLog (@"kAudioSessionRouteChangeReason_NewDeviceAvailable");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange NewDeviceAvailable"];
                    break;
                case kAudioSessionRouteChangeReason_OldDeviceUnavailable:
                    NSLog (@"kAudioSessionRouteChangeReason_OldDeviceUnavailable");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange OldDeviceUnavailable"];
                    break;
                case kAudioSessionRouteChangeReason_CategoryChange:
                    NSLog (@"kAudioSessionRouteChangeReason_CategoryChange");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange CategoryChange"];
                    break;
                case kAudioSessionRouteChangeReason_Override:
                    NSLog (@"kAudioSessionRouteChangeReason_Override");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange Override"];
                    break;
                case kAudioSessionRouteChangeReason_WakeFromSleep:
                    NSLog (@"kAudioSessionRouteChangeReason_WakeFromSleep");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange WakeFromSleep"];
                    break;
                case kAudioSessionRouteChangeReason_NoSuitableRouteForCategory:
                    NSLog (@"kAudioSessionRouteChangeReason_NoSuitableRouteForCategory");
                    newMess = [newMess stringByAppendingString:@"AudioRouteChange NoSuitableRouteForCategory"];
                    break;
            }
            
            
		} catch (CAXException e) {
			char buf[256];
			fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
		}
		
	}
    else if (inID == kAudioSessionProperty_AudioInputAvailable)
    {
        NSLog(@"AudioInputAvailable Change");

        newMess = [newMess stringByAppendingString:@"AudioRouteChange AudioInputAvailable Change"];
    }
    else if (inID == kAudioSessionProperty_InputSources)
    {

        NSLog(@"InputSources Change");

        newMess = [newMess stringByAppendingString:@"AudioRouteChange InputSources"];
    }
    else if (inID == kAudioSessionProperty_OutputDestinations)
    {

        NSLog(@"OutputDestinations Change");

        newMess = [newMess stringByAppendingString:@"AudioRouteChange OutputDestinations"];
    }
    else if (inID == kAudioSessionProperty_InputGainAvailable)
    {

        NSLog(@"InputGainAvailable Change");

        newMess = [newMess stringByAppendingString:@"AudioRouteChange InputGainAvailable"];
    }
    else if (inID == kAudioSessionProperty_InputGainScalar)
    {

        NSLog(@"InputGainScalar Change");

        newMess = [newMess stringByAppendingString:@"AudioRouteChange InputGainScalar"];
    }
    
    [thisAudioEngine updateDeviceInfos:newMess];
    
}

-(void) updateDeviceInfos:(NSString*)newMessage
{
    id statusObj = [self.infoDesc objectForKey:kInfoDictKeyCurrentStaus];
    [self.infoDesc setObject:statusObj forKey:kInfoDictKeyLastStatus];
    [self.infoDesc setObject:newMessage forKey:kInfoDictKeyCurrentStaus];
    
    // CHANNELS
    
    UInt32 size = sizeof(_inChannels);
    OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &_inChannels);
    
    if (error == noErr) {

        NSLog(@"InChannels: %lu\n",self.inChannels);

        [self.infoDesc setObject:[NSNumber numberWithInt:_inChannels] forKey:kInfoDictKeyInChannels];
    }
    else
    {

        NSLog(@"couldn't get hw channel");

    }
    
    size = sizeof(self.outChannels);
    
    error = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareOutputNumberChannels, &size, &_outChannels);
    
    if (error == noErr) {

        NSLog(@"OutChannels: %lu\n",self.outChannels);

        [self.infoDesc setObject:[NSNumber numberWithInt:self.outChannels] forKey:kInfoDictKeyOutChannels];
    }
    else
    {

        NSLog(@"couldn't get hw channel");

    }
    
    if(self.iOSFive)//
    {
        // AUDIOROUTE DESCRIPTION
        
        CFDictionaryRef inputDictRef;
        size = sizeof(inputDictRef);
        OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &size, &inputDictRef);
        
        NSString* inputPortName;
        NSString* outputPortName; 
        
        if (error == noErr)
        {
            NSDictionary* desc = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)inputDictRef];
            
            NSArray* input = [desc objectForKey:@"RouteDetailedDescription_Inputs"];
            
            if (input) {
                
                if (input.count > 0 )
                {
                    NSDictionary* inRoute = [input objectAtIndex:0];
                    
                    inputPortName = (NSString*) [inRoute objectForKey:@"RouteDetailedDescription_PortType"];
                }
                else
                {
                    inputPortName = [NSString stringWithFormat:@"NoInputs"];
                }

                NSLog(@"AudioRoute In : %@",inputPortName);

                [self.infoDesc setObject:inputPortName forKey:kInfoDictKeyInputRoute];
            }
            
            NSArray* output = [desc objectForKey:@"RouteDetailedDescription_Outputs"];
            
            if (output) {
                
                if (input.count > 0 )
                {
                    NSDictionary* outRoute = [output objectAtIndex:0];
                    
                    outputPortName = (NSString*) [outRoute objectForKey:@"RouteDetailedDescription_PortType"];
                }
                else {
                    outputPortName = [NSString stringWithFormat:@"NoOutputs"];
                }
                
                [self.infoDesc setObject:outputPortName forKey:kInfoDictKeyOutputRoute];

                NSLog(@"AudioRoute Out : %@",outputPortName);
            }
        }
        
        if ([inputPortName compare:@"MicrophoneWired"] == NSOrderedSame && [outputPortName compare:@"Headphones"] == NSOrderedSame)
        {
            if (!self.deviceAvailable)
            {
                self.deviceAvailable = TRUE;
            }
        }else
        {
            if (self.deviceAvailable)
            {
                self.deviceAvailable = FALSE;
            }
        }

    }
    else
    {
        //         iOS4 kompatible Abfragen
        
        // AUDIOROUTE DESCRIPTION
        
        CFStringRef audioRouteStrRef;
        size = sizeof(audioRouteStrRef);
        OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &audioRouteStrRef);
        BOOL checkDeviceStatus = false;
        if (error == noErr)
        {
            NSString* routeInfo = (__bridge NSString*)audioRouteStrRef;

            NSLog(@"Audioroute iOS 4: %@",routeInfo);
            // aufsplitten in Ein&Ausgänge
            
            
            if (([routeInfo compare:@"SpeakerAndMicrophone"] == NSOrderedSame)||[routeInfo compare:@"ReceiverAndMicrophone"] == NSOrderedSame) {
                //checkDeviceStatus = TRUE;
                 self.deviceAvailable = FALSE;
                [self.infoDesc setObject:@"BuildIn Microphone" forKey:kInfoDictKeyInputRoute];
                [self.infoDesc setObject:@"BuildIn Speaker" forKey:kInfoDictKeyOutputRoute];
            }
            else if ([routeInfo compare:@"HeadsetInOut"] == NSOrderedSame){
                checkDeviceStatus = TRUE;
                self.deviceAvailable = TRUE;
                [self.infoDesc setObject:@"Headset Microphone" forKey:kInfoDictKeyInputRoute];
                [self.infoDesc setObject:@"Headphones" forKey:kInfoDictKeyOutputRoute];
            }
            else if ([routeInfo compare:@"HeadphonesAndMicrophone"] == NSOrderedSame){
                [self.infoDesc setObject:@"BuildIn Microphone" forKey:kInfoDictKeyInputRoute];
                [self.infoDesc setObject:@"Headphones" forKey:kInfoDictKeyOutputRoute];
            }
            
        }
        else
        {
            [self.infoDesc setObject:@"Error Read Audio In Route" forKey:kInfoDictKeyInputRoute];
            [self.infoDesc setObject:@"Error Read Audio Out Route" forKey:kInfoDictKeyOutputRoute];
        }
        
        /*
        NSLog(@"Audioroute avaible: %d",self.deviceAvailable);
        if (checkDeviceStatus)
        {
            if (!self.deviceAvailable)
            {
                self.deviceAvailable = TRUE;
            }else
            {
                self.deviceAvailable = FALSE;
            }

        }
         */
        
    }
    
    Float64 sRate;
    
    size = sizeof(sRate);
    error = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &sRate);
    
    if (error == noErr)
    {
        if (self.sampleRate != sRate) {
            self.sampleRate = sRate;
            
            [self.infoDesc setObject:[NSNumber numberWithFloat:(float)sRate] forKey:kInfoDictKeySampleRate];
        }
    }
    
    float blSize;
    
    size = sizeof(blSize);
    error = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareIOBufferDuration, &size, &blSize);
    
    if (error == noErr)
    {        
        if (self.blockSize != blSize) {
            self.blockSize = blSize;
            
            [self.infoDesc setObject:[NSNumber numberWithFloat:(float)blSize] forKey:kInfoDictKeyBlockSize];
        }
    }
    
}


-(void) startUpCheck:(NSTimer*)timer
{ 
    NSLog(@"startUpCheck");
    [self updateDeviceInfos:[NSString stringWithFormat:@"StartUp"]];
    
    [timer invalidate];
}

-(void) setDeviceAvailable:(BOOL)devAvailable
{
    if (_deviceAvailable != devAvailable)
    {
        _deviceAvailable = devAvailable;
        
        // ChangeInStatus
        
        if (_delegate)
        {
            if([self.delegate respondsToSelector:@selector(deviceChangedToStatus:)])
                [self.delegate deviceChangedToStatus:self.deviceAvailable];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AudioJackDetectorChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.deviceAvailable] forKey:AudioJackDetectorChangeNotificationStatusKey]];
            
        }

    }
}

-(BOOL) deviceAvailable
{
    return _deviceAvailable;
}

@end
