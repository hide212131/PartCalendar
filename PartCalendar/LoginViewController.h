//
//  ViewController.h
//  PartCalendar
//
//  Created by hide212131 on 12/07/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "GDataCalendar.h"
#import "MainViewController.h"

@interface LoginViewController : UIViewController {

    IBOutlet UITextField *userText;
    IBOutlet UITextField *passText;
    IBOutlet UIButton *login;
    
    MainViewController *parent;
}


- (IBAction)btn_login_down:(id)sender;
- (void)handleError:(NSError *)error;

@end
