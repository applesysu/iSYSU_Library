//
//  LIBSearchViewController.h
//  iSYSU_Library
//
//  Created by 04 developer on 12-11-8.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIBDataManager.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "LIBMyinfoViewController.h"

#define kDateFilename @"noti_date.plist"
#define KUserInfoFilename @"date.plist"
@interface LIBSearchViewController : UIViewController
{
    @private
        bool update;
}
@property (weak,nonatomic) NSArray* searchResult;
@property (strong, nonatomic) IBOutlet UITextField *BookName;
- (IBAction)stb:(id)sender;
- (IBAction)tapBackground:(id)sender;

-(void)didUpdate;
-(void)didnotUpdate;
-(BOOL)getUpdate;
//-(void)searchWithBookName:(NSString *)name;
//-(void)showSearchResult:(NSArray *)searchResult;
@property (weak, nonatomic) IBOutlet UIButton *Change_Switch_Button;
@end
