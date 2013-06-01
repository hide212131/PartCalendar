//
//  AppDelegate.h
//  PartCalendar
//
//  Created by hide212131 on 12/07/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <eventkit/EventKit.h>

// These must match what are defined in the Settings.bundle/Root.plist dictionary.
#define PREF_USERNAME CFSTR( "name_preference" )
#define PREF_PASSWORD CFSTR( "pass_preference" )

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    EKEventStore *eventStore;
    EKCalendar *calendar;
    
    NSString* username;
    NSString* password;
    
    NSString* eventTitle;
    NSDate* eventStartTime;
    NSDate* eventEndTime;
    NSInteger payment;
}

+ (AppDelegate *)appDelegate;


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* eventTitle;
@property (nonatomic, retain) NSDate* eventStartTime;
@property (nonatomic, retain) NSDate* eventEndTime;
@property (nonatomic) NSInteger payment;

@property (nonatomic, retain) EKEventStore* eventStore;
@property (nonatomic, retain) EKCalendar* calendar;
@end
