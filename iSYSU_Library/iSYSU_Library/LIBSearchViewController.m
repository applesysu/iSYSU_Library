//
//  LIBSearchViewController.m
//  iSYSU_Library
//
//  Created by 04 developer on 12-11-8.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//
//lulu

#import "LIBSearchViewController.h"
#import "LIBSearchResultViewController.h"

@implementation LIBSearchViewController
@synthesize BookName;
@synthesize searchResult;
@synthesize Change_Switch_Button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mrak - noti
- (NSString *)filePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)New_noti:(NSInteger)book_count times:(NSUInteger)times{
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init] ;
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:times];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        //notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = [NSString stringWithFormat: @"你有%d本书即将到期，请注意归还时间",book_count];
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication       
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification]; 
        
    }
}

- (void)Create_noti{
    NSArray *user_array = [[NSArray alloc]initWithContentsOfFile:[self filePath:KUserInfoFilename]]; //用户的提醒设置信息
    bool need_alert = [[user_array objectAtIndex:0] boolValue];
    if( need_alert == false ) return; //用户不需要提醒
    
    int Delate_day = 1000;
    int tot_number = 0;
    NSArray *boo_array = [[NSArray alloc] initWithContentsOfFile:[self filePath:kDateFilename]];  //用户的书籍的信息
    for (NSUInteger i = 0; i < boo_array.count; i++) {
        NSArray *temp = [boo_array objectAtIndex:i];
        NSString *temp_time = [temp objectAtIndex:1];
        int temp_delate_time = [[[[LIBMyinfoViewController alloc] init] DaysCalculator:temp_time] intValue];
        if( Delate_day > temp_delate_time ){
            Delate_day = temp_delate_time;
            tot_number = 1;
        }
        else if( Delate_day == temp_delate_time )
            tot_number ++;
        NSLog(@"%d",temp_delate_time);
    }
    if ( tot_number > 0 ){
        int days[3] = {5,3,1};
        int frequency[] = {2,1};
        int start = days[[[user_array objectAtIndex:1] intValue]];
        int step = frequency[[[user_array objectAtIndex:2] intValue]];
        for (; start > 0; start -= step) {
            NSInteger new_delate_time = Delate_day - start;
            NSInteger hour = [[user_array objectAtIndex:4] intValue];
            NSInteger minute = [[user_array objectAtIndex:5] intValue];
            
            //NSLog(@"noti %d %d",hour,minute);
            
            [self New_noti:tot_number times:(new_delate_time * 24 * 60 * 60 + hour * 60 * 60 + minute * 60) ];
            //            NSLog(@"tottime %d",(new_delate_time ));
        }
        
        [self New_noti:tot_number times:10];
        NSLog(@"new noti %d",tot_number);
        NSLog(@"%d",Delate_day);
    }else{
        NSLog(@"No noti");
    }
    
}

#pragma mark - View lifecycle

- (void) Disble_button{
    self.Change_Switch_Button.enabled = NO;
    self.Change_Switch_Button.alpha = 0.5;
}

- (void) Enable_button{
    self.Change_Switch_Button.enabled = YES;
    self.Change_Switch_Button.alpha = 1;
    //添加observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdate) name:@"DidUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didnotUpdate) name:@"DidNotUpdate" object:nil];
    [[LIBDataManager shareManager] requestUpdate];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setTintColor:)])
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar.png"];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIDevice currentDevice] systemVersion];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        
        //iOS 5
        UIImage *toolBarIMG = [UIImage imageNamed: @"nav.png"];  
        
        if ([self.navigationController.toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) { 
            [self.navigationController.toolbar  setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0]; 
        }
        
    } 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Disble_button) name:@"No_Connect" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Enable_button) name:@"Connect" object:nil];
    [self Create_noti];
    
    //[[self.navigationController.navigationBar] setBackgroundImage:[UIImage imageNamed:@"navbar.png"]];
//    [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"searchBtn_On"]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    LIBSearchResultViewController *resultViewController = [[LIBSearchResultViewController alloc] init];
//    resultViewController.keyword = [self.BookName text];
    id segue2 = segue.destinationViewController;
    [segue2 setValue:[self.BookName text] forKey:@"keyword"];
}

- (IBAction)stb:(id)sender {
//    [self searchWithBookName:[self.BookName text]];
//    NSLog(@"%@", searchResult);
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (IBAction)tapBackground:(id)sender {
    
    [self.BookName resignFirstResponder];
}

-(void)didUpdate
{
    [LIBDataManager shareManager]->isupdate = YES;
}
-(void)didnotUpdate
{
   [LIBDataManager shareManager]->isupdate = NO;
}
-(BOOL)getUpdate
{
    return self->update;
}

////搜索
//-(void)searchWithBookName:(NSString *)name
//{
//    //添加observer
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchResult:) name:@"finishSearch" object:nil];
//    [[LIBDataManager shareManager] requestSearchWithParrtern:name];
//}
//-(void)showSearchResult:(NSArray *)searchResult
//{
//    NSLog(@"search result");
//    self.searchResult = [[LIBDataManager shareManager] searchResult];
//    NSLog(@"%@",self.searchResult);
//}

- (void)viewDidUnload
{
    [self setBookName:nil];
    //[self setsearchResult:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
