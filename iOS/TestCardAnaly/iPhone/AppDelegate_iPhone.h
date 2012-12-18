//
//  AppDelegate_iPhone.h
//  TestCardAnaly
//
//  Created by Bruce on 11-8-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	HomeViewController *mHomeCtrl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

