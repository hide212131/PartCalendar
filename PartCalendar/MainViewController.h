//
//  MainViewController.h
//  PartCalendar
//
//  Created by hide212131 on 2012/07/29.
//
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "GDataCalendar.h"
#import "MyTKCalendarMonthView.h"

@interface MainViewController : UITableViewController {

    GDataServiceGoogleCalendar *googleCalendarService;
    GDataFeedCalendar *feed;
    
    NSMutableArray *data;
    
    //NSMutableDictionary *memoDictionary;
    MyTKCalendarMonthView *monthView;
 
    NSMutableDictionary *dataDictionary;
    
    
}

@property (retain,nonatomic) MyTKCalendarMonthView *monthView;
@property (nonatomic, retain) GDataServiceGoogleCalendar *googleCalendarService;
@property (nonatomic, retain) GDataFeedCalendar *feed;

@property (retain, nonatomic) NSMutableDictionary *dataDictionary;

- (IBAction)submitButtonPushed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@end
