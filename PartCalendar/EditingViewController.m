//
//  EditingViewController.m
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import "EditingViewController.h"
#import "TextEditingViewController.h"
#import "DateEditingViewController.h"
#import "GDataDateTime.h"
#import "AppDelegate.h"

@interface EditingViewController ()

@end

@implementation EditingViewController
@synthesize titleLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize paymentLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //editingEvent = [[GDataEntryCalendarEvent alloc] init];
    //[editingEvent addTime:[[GDataWhen alloc] init]];
  
    //editingEvent = [[AppDelegate appDelegate] calendarEvent];
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    [self setEventTitle:appDelegate.eventTitle];
    [self setStartDate:appDelegate.eventStartTime];
    [self setEndDate:appDelegate.eventEndTime];
    [self setPaymentText:[[NSString alloc] initWithFormat:@"%d",appDelegate.payment]];
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setStartDateLabel:nil];
    [self setEndDateLabel:nil];
    [self setPaymentLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    
    if ([[segue identifier] isEqualToString:@"titleSegue"]) {
        ((TextEditingViewController *)[segue destinationViewController]).text = appDelegate.eventTitle;
        [((TextEditingViewController *)[segue destinationViewController]) setHandler:@selector(setEventTitle:) :self];
    } else if ([[segue identifier] isEqualToString:@"paymentSegue"]) {
        ((TextEditingViewController *)[segue destinationViewController]).text
            = [[NSString alloc] initWithFormat:@"%d",appDelegate.payment];
        [((TextEditingViewController *)[segue destinationViewController]) setHandler:@selector(setPaymentText:) :self];
    } else {
        
    //    calendarEvent = [[GDataEntryCalendarEvent alloc] init];
    //[calendarEvent addTime:[[GDataWhen alloc] init]];
        
        //NSArray *eventTimes = [editingEvent times];
        //GDataWhen *when = [eventTimes objectAtIndex:0];
        //calendarEvent = [[GDataEntryCalendarEvent alloc] init];
        //[calendarEvent addTime:[[GDataWhen alloc] init]];
    
        ((DateEditingViewController *)[segue destinationViewController]).type = [segue identifier];
        
        if([[segue identifier] isEqualToString:@"startDateSegue"]) {
            ((DateEditingViewController *)[segue destinationViewController]).date = appDelegate.eventStartTime;
            ((DateEditingViewController *)[segue destinationViewController]).editingViewController = self;
        } else if([[segue identifier] isEqualToString:@"endDateSegue"]) {
            ((DateEditingViewController *)[segue destinationViewController]).date = appDelegate.eventEndTime;
            ((DateEditingViewController *)[segue destinationViewController]).editingViewController = self;
        }
    }
}


- (void)setEventTitle:(NSString *)title
{
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.eventTitle = title;
    titleLabel.text = title;
    //NSLog(@"editingEvent=%@", editingEvent.description);
    
}

- (void)setStartDate:(NSDate *)startDate
{
    //NSArray *eventTimes = [editingEvent times];
    //GDataWhen *when = [eventTimes objectAtIndex:0];
    //[when setStartTime : [[GDataDateTime alloc] initWithDate:startDate timeZone:[[ NSTimeZone alloc ] initWithName: @"Asia/Tokyo" ]]];
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.eventStartTime = startDate;
    startDateLabel.text = [self formatTime:startDate];
}

- (void)setEndDate:(NSDate *)endDate
{
    //NSArray *eventTimes = [editingEvent times];
    //GDataWhen *when = [eventTimes objectAtIndex:0];
    //[when setEndTime : [[GDataDateTime alloc] initWithDate:endDate timeZone:[[ NSTimeZone alloc ] initWithName: @"Asia/Tokyo" ]]];
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.eventEndTime = endDate;
    endDateLabel.text = [self formatTime:endDate];
}

- (NSString *)formatTime:(NSDate *)date
{
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
	NSString *outputDateFormatterStr = @"HH:mm";
	[outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"Asia/Tokyo"]];
	[outputDateFormatter setDateFormat:outputDateFormatterStr];
	return [outputDateFormatter stringFromDate:date];
}

- (void)setPaymentText:(NSString *)paymentText
{
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.payment = [paymentText integerValue];
    paymentLabel.text = paymentText;
    //NSLog(@"editingEvent=%@", editingEvent.description);
}

@end
