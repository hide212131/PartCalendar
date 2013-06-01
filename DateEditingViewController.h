//
//  DateEditingViewController.h
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import <UIKit/UIKit.h>
#import "EditingViewController.h"

@interface DateEditingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) EditingViewController *editingViewController;

- (IBAction)okButtonPushed:(id)sender;

@end
