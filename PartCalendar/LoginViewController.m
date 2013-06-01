//
//  ViewController.m
//  PartCalendar
//
//  Created by hide212131 on 12/07/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "GDataCalendar.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController



- (IBAction)btn_login_down:(id)sender {
    
    NSLog(@"parentViewController.debugDescription = %@",self.parentViewController.debugDescription);
    
    
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.username = userText.text;
    appDelegate.password = passText.text;
        
    [parent.googleCalendarService setUserCredentialsWithUsername:appDelegate.username
                                                        password:appDelegate.password];
 
    [parent.googleCalendarService fetchCalendarFeedForUsername:appDelegate.username
                                      delegate:self
                                      didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error: )];
    
    
    
    //[self refresh];   // Start the fetch process.
}


- (void)handleError:(NSError *)error{
    NSString *title, *msg;
    if( [error code]==kGDataBadAuthentication ){
        title = @"Authentication Failed";
        msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
    }else{
        // some other error authenticating or retrieving the GData object or a 304 status
        // indicating the data has not been modified since it was previously fetched
        title = @"Unknown Error";
        msg = [error localizedDescription];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{

    if( !error ){
        int count = [[feed entries] count];
        for( int i=0; i<count; i++ ){
            GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
            //NSLog(@"calendar.debugDescription = %@",calendar.debugDescription);
        }

        parent.feed = feed;
        
        NSLog(@"feed=%@", parent.feed);
        NSLog(@"parent=%@", parent);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self handleError: error];
    }

}




- (void)loadView {	
    [super loadView];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // At this point, the application delegate will have loaded the app's preferences, so set the service's credentials.
    NSArray *array = self.navigationController.viewControllers;
    int arrayCount = [array count];
    parent = [array objectAtIndex:arrayCount - 2];
    NSLog(@"MainViewController.debugDescription = %@",parent);
    
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    userText.text = appDelegate.username;
    passText.text = appDelegate.password;

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
