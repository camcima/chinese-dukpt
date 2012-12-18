//
//  HomeViewController.h
//  TestCardAnaly
//
//  Created by Bruce on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioAnalyLib.h"
#import "AudioJackDetector.h"

@interface HomeViewController : UIViewController <AudioJackDetectorDelegate> {
	UITextView *mTextView;
	char szRecvBuf[1200];
}

@property (nonatomic, retain) 	AudioAnalyLib *mAudioLib;
@property (nonatomic, retain) AudioJackDetector *detector;
@end
