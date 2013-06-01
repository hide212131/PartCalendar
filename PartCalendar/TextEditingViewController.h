//
//  TextEditingViewController.h
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import <UIKit/UIKit.h>
#import "EditingViewController.h"

@interface TextEditingViewController : UIViewController {
    SEL OnClick;
	NSObject* target;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) NSString *text;

- (IBAction)okButtonPushed:(id)sender;

- (void)setHandler:(SEL) method: (NSObject*) eventDest;

@end
