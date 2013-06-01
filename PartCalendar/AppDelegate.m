//
//  AppDelegate.m
//  PartCalendar
//
//  Created by hide212131 on 12/07/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize username, password, eventTitle, eventStartTime, eventEndTime, payment, eventStore, calendar;

+ (AppDelegate *)appDelegate{		// Static accessor
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self loadSettings];
    eventStore = [[EKEventStore alloc] init];
    calendar = [eventStore defaultCalendarForNewEvents];
    

    NSLog(@"eventStore=%@", eventStore);
    NSLog(@"calendar=%@", calendar);
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self storeSettings];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self storeSettings];
}


#pragma mark -
#pragma mark Settings accessors

- (void)loadSettings{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    username = [ud stringForKey:@"username"];
    password = [ud stringForKey:@"password"];
    eventTitle = [ud stringForKey:@"eventTitle"];
    eventStartTime = [ud objectForKey:@"eventStartTime"];
    eventEndTime = [ud objectForKey:@"eventEndTime"];
    payment = [ud integerForKey:@"payment"];
    
    /*
    NSLog(@"loadSettings");
    
    ( kCFPreferencesCurrentApplication );
    
    username = (__bridge NSString*)CFPreferencesCopyAppValue( PREF_USERNAME, kCFPreferencesCurrentApplication );
    if( !username )
        username = @"username@gmail.com";
    if( ![username rangeOfString:@"@"].length )		// If the domain isn't specified, then default to gmail.com.  It may be a different domain, however.
        username = [username stringByAppendingString:@"@gmail.com"];
    
    password = (__bridge NSString*)CFPreferencesCopyAppValue( PREF_PASSWORD, kCFPreferencesCurrentApplication );
    if( !password )
        password = @"password";
    
    */
    
}

- (void)storeSettings{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:@"username"];
    [ud setObject:password forKey:@"password"];
    [ud setObject:eventTitle forKey:@"eventTitle"];
    [ud setObject:eventStartTime forKey:@"eventStartTime"];
    [ud setObject:eventEndTime forKey:@"eventEndTime"];
    [ud setInteger:payment forKey:@"payment"];
    
    /*
    NSLog(@"loadSettings");

    CFPreferencesSetAppValue( PREF_USERNAME, (__bridge CFPropertyListRef) username, kCFPreferencesCurrentApplication );
    CFPreferencesSetAppValue( PREF_PASSWORD, (__bridge CFPropertyListRef) password, kCFPreferencesCurrentApplication );
    CFPreferencesAppSynchronize( kCFPreferencesCurrentApplication );
     */
}

@end
