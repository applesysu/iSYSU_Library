//
//  LIBAppDelegate.h
//  iSYSU_Library
//
//  Created by 04 developer on 12-11-8.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface LIBAppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *hostRech;
}

@property (strong, nonatomic) UIWindow *window;

@end
