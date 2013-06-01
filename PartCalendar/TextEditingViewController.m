//
//  TextEditingViewController.m
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import "TextEditingViewController.h"

@interface TextEditingViewController ()

@end

@implementation TextEditingViewController
@synthesize textField;
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
    [textField becomeFirstResponder];
    [self configureView];
    
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setOkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.text) {
        self.textField.text = self.text;
    }
}

- (void)setHandler:(SEL) method: (NSObject*) eventDest {
	OnClick = method;
	target = eventDest;
}

- (IBAction)okButtonPushed:(id)sender {
    [target performSelector:OnClick withObject:self.textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
