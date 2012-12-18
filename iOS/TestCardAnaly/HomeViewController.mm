    //
//  HomeViewController.m
//  TestCardAnaly
//
//  Created by Bruce on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "AudioAnalyData.h"
#import "DUKPT_DES.h"
#import <AudioToolbox/AudioToolbox.h>


static unsigned char  MainKey[16],NowKey[16],RealOutData[500];



@implementation HomeViewController
@synthesize mAudioLib = _mAudioLib;
@synthesize detector = _detector;

-(void) SpreatDecodeCardData:( NSString*) strin  stroutgo:(NSString **)strout 
{
    //  printf("ucCheck = %d\n",strin.length);
    
    NSString *tempString;
    unsigned int i,j=0;unsigned int cPos[20];unsigned long lCount = 0;
    
    unsigned char tempbuf[5];
   
    
    char EncryptData[500]; unsigned char EncryptDataSouce[256],ucTmpData[300];
    char First6cardNum[20];
    char Last4cardNum[10];
    char Name[60];
    char ExpireDate[10];
    char ServiceCode[5];
    
    char KSN[30]; unsigned char KSNSouce[15];
    char CheckSum[5];unsigned char CheckSumSouce, ucCheck,ucCheckLen;
    
    
    memset(cPos, 0, sizeof(cPos));
    
    memset(EncryptData,0,sizeof(EncryptData));
    memset(First6cardNum,0,sizeof(First6cardNum));
    memset(Last4cardNum,0,sizeof(Last4cardNum));
    memset(Name,0,sizeof(Name));
    memset(ExpireDate,0,sizeof(ExpireDate));
    memset(ServiceCode,0,sizeof(ServiceCode));
    memset(KSN,0,sizeof(KSN));
    memset(CheckSum,0,sizeof(CheckSum));
    
  
    //const char *szTmp="00000000000";
    
    if (strin&&strin.length>10) {
        
    
    
    const char *szTmp = [strin UTF8String] ;
   
    for( i=0;i< strin.length;i++){
        if(szTmp[i] =='^'){
            cPos[j++] = i;
         
        }
    }

    memcpy(EncryptData, szTmp+1, cPos[0]-1);
    memcpy(First6cardNum, szTmp+cPos[0]+1, 6);
    memcpy(Last4cardNum, szTmp+cPos[1]+1 , 4);
    memcpy(Name, szTmp +cPos[2]+1, 26);
    memcpy(ExpireDate, szTmp + cPos[3]+1, 4);
    memcpy(ServiceCode, szTmp + cPos[4]+1, 3);
    memcpy(KSN, szTmp + cPos[5]+1 , 20);
    memcpy(CheckSum, szTmp + cPos[6]+1 , 2);
    
  
    
    vTwoOne((unsigned char *)EncryptData, cPos[0]-1,(unsigned char *)EncryptDataSouce);
    vTwoOne((unsigned char *)KSN,20,(unsigned char *)KSNSouce);
    vTwoOne((unsigned char *)CheckSum,2,&CheckSumSouce);
        
    memcpy(ucTmpData,EncryptDataSouce,(cPos[0]-1)/2);  
    memcpy(ucTmpData+(cPos[0]-1)/2,First6cardNum,6);
    memcpy(ucTmpData+(cPos[0]-1)/2+6,Last4cardNum,4);
    memcpy(ucTmpData+(cPos[0]-1)/2+6+4,Name,26);
    memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26,ExpireDate,4);
    memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26+4,ServiceCode,3);
    memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26+4+3,KSNSouce,10);  
        
     
        ucCheckLen = (cPos[0]-1)/2  + 6 + 4 + 26 + 4 + 3 + 10  ;
        
        ucCheck = 0xff;  
        
        for (i=0; i<(ucCheckLen); i++) {
            ucCheck ^= ucTmpData[i];
        }    
        
     //printf("ucCheck = [%02X],[%2X] ,%d\n",ucCheck,CheckSumSouce,ucCheckLen);
   
    if(ucCheck == CheckSumSouce){    
        
    memcpy(MainKey,"\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff",16);
    
    memcpy(tempbuf,KSNSouce+7,3);
    tempbuf[0] = tempbuf[0]& 0x1F;
    lCount = tempbuf[0]* 0x10000+tempbuf[1]* 0x100+tempbuf[2];
    
    
    pan_count(&lCount);        //transaction count 
    
    get_now_key(NowKey, MainKey, &lCount, KSNSouce);//   every swipe , NowKey is different.
    
    memset(RealOutData, 0, sizeof(RealOutData));
    Des_string((unsigned char *)EncryptDataSouce , (cPos[0]-1)/2 , NowKey, 16,RealOutData , TDES_DECRYPT);//decode  EncryptDataSouce to RealOutData
    
    tempString = [NSString stringWithCString:(const char *)RealOutData encoding:NSUTF8StringEncoding];// decoded card data  
    
    *strout = [*strout stringByAppendingFormat:@"[Encrypt Data:] %s\n[Card Data:]\n %@ \n[First6cardNum:]  %s  [Last4cardNum:]  %s\n[Name:]  %s \n[ExpireDate:]  %s     [ServiceCode:]  %s \n [KSN:]  %s [CheckSum:]  %s\n ",EncryptData,tempString,First6cardNum,Last4cardNum,Name,ExpireDate,ServiceCode,KSN,CheckSum];
    
    }
    else{
        printf("CheckSum ERROR");
        
         // to do what you want to do here
        return;
    }
        
    }else
        return;
    
   
}



- (void)ShowTextView:(NSString *)text {
	//NSString *tmp = [NSString stringWithFormat:@"%s", szRecvBuf];
	//if (!mTextView.text) {
		mTextView.text = @"";
        //sleep(1);
	//}
    
    if (text) {
        mTextView.text = [NSString stringWithFormat:@"\r\n%@", text];//stringByAppendingFormat
    }else
	    mTextView.text = [NSString stringWithFormat:@"\r\n%s", szRecvBuf];
    

}

- (void)OnRecvAudioCardData:(TCardCmdRespond *)respond {
    unsigned char CheckSumSouce, ucCheck,ucCheckLen;
    int i; 
	//NSLog(@"OnRecvAudioCardData:%d", respond->iLen);
    memset(szRecvBuf, 0, sizeof(szRecvBuf));

    if(respond->state !=0xaa){
        [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Run Command Error!\r\n" waitUntilDone:YES];
    }else{
        
        
        ucCheckLen = respond->iLen -3;
        ucCheck = respond->data[0];
        for (i=0; i<ucCheckLen-1; i++) {
            ucCheck ^= respond->data[i+1];
            //printf("Data= %02X\n",respond->data[i]);
        }      
        CheckSumSouce = respond->data[ucCheckLen];
      
        if (ucCheck == CheckSumSouce) {
            
                //to do what you want here
            

            
        
        
             //printf("ucCheck = [%02X],[%02X] ,%d\n",ucCheck,CheckSumSouce,ucCheckLen);
            
            switch (respond->iType) {
                case CardCmdType_VER:
                    //NSLog(@"GetVersion:%s %d", respond->data,respond->iLen);
                    
                    memcpy(szRecvBuf, respond->data, respond->iLen-3);

                    break;
                case CardCmdType_GETKSN:
                    //NSLog(@"GetKSN:%s", respond->data);
                    
                    vOneTwo0(respond->data, respond->iLen-3,(unsigned char*) szRecvBuf);
                    break;
                case CardCmdType_GETSNR:
                    //NSLog(@"GetKSN:%s", respond->data);
                    
                    vOneTwo0(respond->data, respond->iLen-3,(unsigned char*) szRecvBuf);
                    break;                    
                case CardCmdType_SETCDKEY:
                    //NSLog(@"SetCDKEY:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                case CardCmdType_SETKSN:
                    //NSLog(@"SetKSN:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                case CardCmdType_SETMODE:
                    //NSLog(@"SetMode:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                default:
                    break;
            }
            if (respond->iLen == 3)    //if iLen ==3 ,means no data response, just Len, cmd, status
                strcpy(szRecvBuf, "Cmd Success AA\r\n" );
            [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:nil waitUntilDone:YES];
            
        }else{  //if ucCheck != CheckSumSouce
            
            //to do what you want here
            
        }           
            
            
        
    }
        
        

}


- (void)OnSwipeCompleted:(NSString *)respond {
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Aotorelease pool   
    NSString *OutData = @"";
    NSLog(@"OnSwipeCompleted");
    memset(szRecvBuf, 0, sizeof(szRecvBuf));


        
    
    [self SpreatDecodeCardData:respond stroutgo:&OutData];//   Decode encrypted card data
  
    [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:(id)OutData waitUntilDone:YES];
    
    //[pool release];// Aotorelease pool   
}


- (void)OnSwipeError:(SwipeErrorState)respond {
    //NSLog(@"OnSwipeError");
    switch (respond) {
		case SwipeErrorStateTrackIncorrectLength:

           
             NSLog(@"SwipeErrorStateTrackIncorrectLength");
			break;
        case SwipeErrorStateCRCFail:
            NSLog(@"SwipeErrorStateCRCFail");
			break;
        case SwipeErrorStateSwipeFail:
            strcpy(szRecvBuf, "SwipeErrorStateSwipeFail");
            [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:nil waitUntilDone:YES];
            NSLog(@"SwipeErrorStateSwipeFail");
			break;
        case SwipeErrorStateUnknownError:
            NSLog(@"SwipeErrorStateUnknownError");
			break;    
        default:
            break;
    }
}

- (void)SendUserData:(UIButton *)sender {
	unsigned char szBuf[50];//send data
    static unsigned long TestL = 1 ;
	switch (sender.tag) {
		case 101:
			//NSLog(@"GetVersion");
			[self.mAudioLib GetVersion];
			break;
		case 102:
			//NSLog(@"GetSNR");
			[self.mAudioLib GetSNR];
			break;
		case 103:
			//NSLog(@"SetCDKey");
           // memcpy(szBuf,&TestL,4);
            szBuf[0] = TestL/0x1000000;
            szBuf[1] = TestL/0x10000;
            szBuf[2] = TestL/0x100;
            szBuf[3] = TestL;
           // TestL++;
			[self.mAudioLib SetCDKey:szBuf];
			break;
		case 104:                 
			//NSLog(@"SetKSN");
            memcpy(szBuf,"\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff",44);
			[self.mAudioLib SetKSN:szBuf];
			break;
		case 105:
			//NSLog(@"SetSecret");
         
			 [self.mAudioLib SetSecret:NO];

			break;
		default:
			break;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor grayColor];
	mTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
	mTextView.editable = NO;
	[self.view addSubview:mTextView];
	[mTextView release];
	
	UIButton *Btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn1.frame = CGRectMake(20, self.view.frame.size.height/2+10, 130, 40);
	[Btn1 setTitle:@"Read Ver" forState:UIControlStateNormal];
	Btn1.tag = 101;
	[Btn1 addTarget:self action:@selector(SendUserData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn1];
	
	UIButton *Btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn2.frame = CGRectMake(170, self.view.frame.size.height/2+10, 130, 40);
	[Btn2 setTitle:@"Read SNR" forState:UIControlStateNormal];
	Btn2.tag = 102;
	[Btn2 addTarget:self action:@selector(SendUserData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn2];
	
	UIButton *Btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn3.frame = CGRectMake(20, self.view.frame.size.height/2+50, 130, 40);
	[Btn3 setTitle:@"Set CNT" forState:UIControlStateNormal];
	Btn3.tag = 103;
	[Btn3 addTarget:self action:@selector(SendUserData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn3];
	
	UIButton *Btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn4.frame = CGRectMake(170, self.view.frame.size.height/2+50, 130, 40);
	[Btn4 setTitle:@"Set Mainkey" forState:UIControlStateNormal];
	Btn4.tag = 104;
	[Btn4 addTarget:self action:@selector(SendUserData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn4];
	
	UIButton *Btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn5.frame = CGRectMake(20, self.view.frame.size.height/2+90, 130, 40);
	[Btn5 setTitle:@"Set Encrypt" forState:UIControlStateNormal];
	Btn5.tag = 105;
	[Btn5 addTarget:self action:@selector(SendUserData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn5];
    
	UIButton *Btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn6.frame = CGRectMake(170, self.view.frame.size.height/2+90, 130, 40);
	[Btn6 setTitle:@"StartDevice" forState:UIControlStateNormal];
	Btn6.tag = 106;
	[Btn6 addTarget:self action:@selector(StartDevice) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn6];

	UIButton *Btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn7.frame = CGRectMake(170, self.view.frame.size.height/2+130, 130, 40);
	[Btn7 setTitle:@"StopDevice" forState:UIControlStateNormal];
	Btn7.tag = 107;
	[Btn7 addTarget:self action:@selector(StopDevice) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn7];
    
	UIButton *Btn8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	Btn8.frame = CGRectMake(20, self.view.frame.size.height/2+130, 130, 40);
	[Btn8 setTitle:@"WaitForSwipe" forState:UIControlStateNormal];
	Btn8.tag = 108;
	[Btn8 addTarget:self action:@selector(WaitForSwipe) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:Btn8];
    
    _detector = [[AudioJackDetector alloc] init];
    self.detector.delegate = self;
   // NSLog(@"IsDevicePluggedIn:%d, %d, %d, %d", self, mAudioLib.delegate, mAudioLib.IsDevicePluggedIn, mAudioLib.OnNoDevicePluggedIn);
}

- (void)StartDevice {
    if (self.detector.deviceAvailable == NO){
        
        NSLog(@"nono");
        return;
        
    }else {
        NSLog(@"Yes");
    }
        
    
    if (self.mAudioLib == nil)
    {
        self.mAudioLib = [[AudioAnalyLib alloc] init];
        self.mAudioLib.delegate = self;
        self.mAudioLib.IsDevicePluggedIn = YES;
        self.mAudioLib.OnRecvCardData = @selector(OnRecvAudioCardData:);
        self.mAudioLib.OnNoDevicePluggedIn = @selector(OnNoDevicePluggedIn);
        self.mAudioLib.OnSwipeCompleted = @selector(OnSwipeCompleted:);
        self.mAudioLib.OnSwipeError = @selector(OnSwipeError:);
        self.mAudioLib.OnEncryptingData = @selector(OnEncryptingData);
        self.mAudioLib.OnError = @selector(OnError);
        self.mAudioLib.OnTimeout = @selector(OnTimeout);
        self.mAudioLib.OnInterrupted = @selector(OnInterrupted);

    }
    [self.mAudioLib StartDevice];
}

- (void)StopDevice {
    [self.mAudioLib StopDevice];
    self.mAudioLib = nil;
}

- (void)WaitForSwipe {
    
    [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Please Swipe Card......." waitUntilDone:YES];
    [self.mAudioLib WaitForSwipe:20];// wait 20 sec
}

- (void)OnNoDevicePluggedIn {
    NSLog(@"OnNoDevicePluggedIn");
}



- (void)OnEncryptingData {
    NSLog(@"OnEncryptingData");
}

- (void)OnError {
    NSLog(@"OnError");
}

- (void)OnTimeout {
    NSLog(@"OnTimeout");
    [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Swipe Card  TimeOut!\nPlease Click WaitForSwipe......." waitUntilDone:YES];
}

- (void)OnInterrupted {
    NSLog(@"OnInterrupted");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark - AudioJackDetectorDelegate

- (void)deviceChangedToStatus:(BOOL)status
{
    if (status)
    {
        
    }
    else 
    {
        [self.mAudioLib StopDevice];
        self.mAudioLib = nil;
    }
}

@end
