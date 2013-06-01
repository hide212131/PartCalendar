//
//  DateEditingViewController.m
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import "DateEditingViewController.h"

@interface DateEditingViewController ()

@end

@implementation DateEditingViewController
@synthesize datePicker;
@synthesize okButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [datePicker setTimeZone: [[ NSTimeZone alloc ] initWithName: @"Asia/Tokyo" ]];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setOkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setDate:(NSDate *)date {
    if (_date != date) {
        _date = date;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.date) {
        self.datePicker.date = self.date;
    }
}

- (IBAction)okButtonPushed:(id)sender {
    if ([self.type isEqualToString:@"startDateSegue"]) {
        _editingViewController.startDate = self.datePicker.date;
    } else if ([self.type isEqualToString:@"endDateSegue"]) {
        _editingViewController.endDate = self.datePicker.date;
    }
    
    NSLog(@"datePicker.timeZone=%@",self.datePicker.timeZone);
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
