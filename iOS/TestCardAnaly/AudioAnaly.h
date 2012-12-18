#ifndef _AUDIOANALY_H_
#define _AUDIOANALY_H_

#import <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>
#include <CoreFoundation/CFURL.h>
#import "AudioUnit/AudioUnit.h"

#include "aurio_helper.h"
#include "CAStreamBasicDescription.h"
#include "SendRecvThread.h"

class AudioAnaly
{
public:
	AudioAnaly(void);
	~AudioAnaly(void);
    void initialize();
	void RecvCardData(unsigned char ch);
	void SendUserData(const unsigned char *pBuf, int iLen);
	void SetRecvCallBack(id target, SEL OnRecvCall, SEL OnSwipeCall, SEL OnSwipeEORCall);
    void StartDevice(void);
    void StopDevice(void);
    //SEL PowerOn;
    void WaitForSwipe(uint uiSec);
    void getResults(void);
    void PowerOn(void);
	id delegate;
    id delegate2;
	//SEL OnRecvData;
public:
	AudioUnit					rioUnit;
	int							unitIsRunning;
	BOOL                        gisPlugIn;
    BOOL                        isStarted;
	DCRejectionFilter*			dcFilter;
	CAStreamBasicDescription	thruFormat;
	Float64						hwSampleRate;
	
	AURenderCallbackStruct		inputProc;

	
	int32_t*					l_fftData;
	unsigned char mszRecvData[500];
	int miRecvSize;
	unsigned char miCmdLen;
	SendRecvThread mRecvThread;
   // SEL OnSwipeCompleted;
   // SEL OnSwipeError;
    SEL OnEncryptingData;
    SEL OnError;
    SEL OnTimeout;
    SEL OnInterrupted;
    SEL OnNoDevicePluggedIn;
};

#endif