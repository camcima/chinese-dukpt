/*
 *  AudioAnalyData.h
 *  CardAnalyLib1
 *
 *  Created by Bruce on 11-8-4.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef _AUDIOANALYDATA_H_
#define _AUDIOANALYDATA_H_

typedef enum {
	CardCmdType_VER,
	CardCmdType_GETKSN,
    CardCmdType_GETSNR,
	CardCmdType_SETCDKEY,
	CardCmdType_SETKSN,
	CardCmdType_SETMODE,
	CardCmdType_CARDDATA
} CardCmdType;

typedef enum {
    SwipeErrorStateTrackIncorrectLength,
    SwipeErrorStateCRCFail,
    SwipeErrorStateSwipeFail,
    SwipeErrorStateUnknownError
} SwipeErrorState;


typedef struct {
	int iLen;
	int iType;
    int state;
    unsigned char data[1000];//256
	
} TCardCmdRespond;

#endif