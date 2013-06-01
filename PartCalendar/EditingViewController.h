//
//  EditingViewController.h
//  PartCalendar
//
//  Created by hide212131 on 2012/08/10.
//
//

#import <UIKit/UIKit.h>
#import "GDataCalendar.h"

@interface EditingViewController : UITableViewController {

//    GDataEntryCalendarEvent *editingEvent;
    
}

//@property (strong, nonatomic) GDataEntryCalendarEvent *editingEvent;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;



@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end
