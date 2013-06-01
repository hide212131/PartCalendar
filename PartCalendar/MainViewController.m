//
//  MainViewController.m
//  PartCalendar
//
//  Created by hide212131 on 2012/07/29.
//
//

#import "MainViewController.h"
#import "GDataCalendar.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize eventTitleLabel;
@synthesize paymentLabel;

@synthesize monthView;

@synthesize googleCalendarService;

@synthesize feed;

@synthesize dataDictionary;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder{
    if( self=[super initWithCoder:aCoder] ){
        googleCalendarService = [[GDataServiceGoogleCalendar alloc] init];
        [googleCalendarService setUserAgent:@"PartCalendar-hide212131"];
        // We'll follow the links ourselves, so that we can show progress to our users between each batch.
        [googleCalendarService setServiceShouldFollowNextLinks:NO];
        data = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark Google Data APIs

- (void)refresh{
    // Note: The next call returns a ticket, that could be used to cancel the current request if the user chose to abort early.
    // However since I didn't expose such a capability to the user, I don't even assign it to a variable.
    [data removeAllObjects];
    
}				


- (void) calendarMonthView:(MyTKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated {
    self.eventTitleLabel.text = @"";
    self.paymentLabel.text = @"0円";
}

- (void) calendarMonthView:(MyTKCalendarMonthView*)monthView didToggledDate:(NSDate*)date {
    [self refleshPaymentLabel:monthView];
}


- (void)calendarMonthView:(MyTKCalendarMonthView*)monthView didSelectDate:(NSDate *)date {
    
    //NSLog(@"calendarMonthView didSelectDate");
    NSLog(@"%@", date);
    
	if (date) {
        [self refleshPaymentLabel:monthView];
        self.eventTitleLabel.text = @"";
        NSMutableArray *array = [dataDictionary objectForKey:date];
        for (EKEvent *e in array) {
            self.eventTitleLabel.text = [[self.eventTitleLabel.text stringByAppendingString:e.title] stringByAppendingString:@"/"];
        }
    }
    
	// カレンダーとテーブルをリロード
	//[self.monthView reload];
}

- (void) refleshPaymentLabel:(MyTKCalendarMonthView*)monthView {
        
        int payment = [[AppDelegate appDelegate] payment];
        int since = (int)
              ([[[AppDelegate appDelegate] eventEndTime] timeIntervalSinceDate:[[AppDelegate appDelegate] eventStartTime]]
               /(60*60));
        int count = [[monthView multipulDatesSelected] allKeys].count;
    
        paymentLabel.text = [[NSString alloc] initWithFormat:@"時給%d円 × %d時間 × %d日 = 合計 %d円",
                             payment, since, count,
                             payment*since*count];
}


// 選択した期間内でのドットマークの有無を返す
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{

    [self generateDataForStartDate:startDate endDate:lastDate];
//    [self generateSelectedDays:[monthView monthDate]];
    [self refleshPaymentLabel:monthView];
    return [self getMarks:startDate toDate:lastDate];

}
 
- (void) generateSelectedDays:(NSDate*) monthDate {
 	
	NSDate *d = monthDate;
    NSCalendar* cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit
                             inUnit:NSMonthCalendarUnit
                            forDate:monthDate];    
    for (int day = 1; day <= days.length; day++) {
        [monthView toggleSelectedDays:day];
    }
}

- (NSArray*) getMarks:(NSDate*)startDate toDate:(NSDate*)lastDate {
	NSMutableArray *marks = [[NSMutableArray array] init];
	
	NSDate *d = startDate;
	while (YES) {
		// 終了判定
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// データがある場合にはYESを、無い場合にはNOをセットする
		NSArray *ar = [dataDictionary objectForKey:d];
		if (ar) {
            BOOL b = NO;
            for (EKEvent *e in ar) {
                if ([e.title isEqualToString:[[AppDelegate appDelegate] eventTitle]]) {
                    b = YES;
                    break;
                }
            }
            [marks addObject:[NSNumber numberWithBool:b]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// 日付を1日すすめる
		TKDateInformation dateInfo = [d dateInformation];
		dateInfo.day++;
		d = [NSDate dateFromDateInformation:dateInfo];
	}
     
    //NSLog(@"calendarMonthView startDate=%@ endDate=%@ marks=%@ ", startDate, lastDate, marks);

    return marks;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //カレンダービュー初期化
     monthView = [[MyTKCalendarMonthView alloc] init];
     monthView.delegate = self;
     monthView.dataSource = self;

     [self.view addSubview:monthView];
     [monthView reload];

    // メモを初期化
	//memoDictionary = [[NSMutableDictionary alloc] init];

    if ([[AppDelegate appDelegate].eventTitle isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"settings" sender:self];
    }
    
    paymentLabel.text = [[NSString alloc] initWithFormat:@"%d円",
                         [[monthView multipulDatesSelected] allKeys].count * [[AppDelegate appDelegate] payment]];
    

        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) generateDataForStartDate:(NSDate*)start endDate:(NSDate*)end{

    EKEventStore *eventStore = [[AppDelegate appDelegate] eventStore];
    EKCalendar *calendar = [[AppDelegate appDelegate] calendar];
    
    NSPredicate *p = [eventStore predicateForEventsWithStartDate:start endDate:end calendars:[NSArray arrayWithObject:calendar]];
    NSArray *events = [eventStore eventsMatchingPredicate:p];
	
	self.dataDictionary = [[NSMutableDictionary dictionary] init];
	
	NSDate *d = start;
	while(YES){
		
        BOOL exist = NO;
        for (EKEvent *e in events) {
            if ([d isSameDay:e.startDate]) {
                
                NSMutableArray *array = [self.dataDictionary objectForKey:d];
                if (!array) {
                    array = [NSMutableArray array];
                }
                [self.dataDictionary setObject:array forKey:d];
                [array addObject:e];
                exist = YES;
            }
        }
        //[self.dataArray addObject:[NSNumber numberWithBool:exist]];
        
        //		int r = arc4random();
        //		if(r % 3==1){
        //			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil] forKey:d];
        //			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
        //
        //		}else if(r%4==1){
        //			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",nil] forKey:d];
        //			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
        //
        //		}else
        //			[self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		
        //NSLog(@"g=%@", d);
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
    
    //NSLog(@"dataDictionary.count=%@", dataDictionary);
	
}



- (void)viewDidUnload
{
    [self setEventTitleLabel:nil];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
*/
 
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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

- (IBAction)submitButtonPushed:(id)sender {
    
    int addCount = [self removeCalendarEvent];
    int removeCount = [self addCalendarEvent];
    
    if (addCount > 0 || removeCount > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"一括登録"
                                                    message:@"終了しました"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
        [alert show];
    }
}

- (int) removeCalendarEvent {
    
    int count = 0;
    
    // マークのついている日を求める
    NSCalendar* cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

    NSDate *monthStart = [monthView monthDate];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit
                             inUnit:NSMonthCalendarUnit
                            forDate:monthStart];
    NSDateComponents* cmp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:monthStart];
    cmp.day = days.length;
    NSDate *monthEnd = [cal dateFromComponents:cmp];
    NSArray *marks = [self getMarks:monthStart toDate:monthEnd];

    NSLog(@"From %@ To %@ marks=%@",monthStart, monthEnd, marks);
    
    NSDictionary *dateSelected = [monthView multipulDatesSelected];
    
    for (int day = 1; day <= marks.count; day++) {
        if (![(NSNumber*)[marks objectAtIndex:day-1] boolValue]) continue;
        
        cmp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:monthStart];
        cmp.day = day;
        NSDate *dt = [cal dateFromComponents:cmp];
        if ([dateSelected objectForKey:dt]) {
            continue;
        } else {
            for (NSDate* key in [dataDictionary allKeys]) {
                if ([dt isSameDay:key]) {
                    NSArray *ar = [dataDictionary objectForKey:key];
                    EKEvent *event = NULL;
                    for (EKEvent *e in ar) {
                        if ([e.title isEqualToString:[[AppDelegate appDelegate] eventTitle]]) {
                            event = e;
                            break;
                        }
                    }
                    
                    if (event) {
                        NSError *err;
                        [[AppDelegate appDelegate].eventStore removeEvent:event span:EKSpanThisEvent error:&err];
                        //スケジュールをデフォルトカレンダーに予定を登録する
                        if (err) {
                            [self handleError: err];
                        } else {
                            NSLog(@"removeEvent Success. %@", event.startDate);
                             count++;
                        }
                        
                       

                    }
                }
            }
        }
        
    }
    
    return count;
 
}




- (int) addCalendarEvent {
    
    int count = 0;

    /*
    if ([[feed entries] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"一括登録"
                                                        message:@"ログインしてください。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        return;
    }
     */
    

    // マークのついている日を求める
    NSCalendar* cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *monthStart = [monthView monthDate];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit
                             inUnit:NSMonthCalendarUnit
                            forDate:monthStart];
    NSDateComponents* cmp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:monthStart];
    cmp.day = days.length;
    NSDate *monthEnd = [cal dateFromComponents:cmp];
    NSArray *marks = [self getMarks:monthStart toDate:monthEnd];
    
    NSLog(@"From %@ To %@ marks=%@",monthStart, monthEnd, marks);
  
    //NSLog(@"marks=%d", marks.count);
    AppDelegate *appDelegate = [AppDelegate appDelegate];
   
    NSEnumerator *e = [[monthView multipulDatesSelected] keyEnumerator];
    id key;
    while (key = [e nextObject]) {

        NSDate *dt = (NSDate *)key;
        
        
        // 取得したい情報をカレンダーのフラグに指定
        NSUInteger dateFlg = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSUInteger timeFlg = NSHourCalendarUnit | NSMinuteCalendarUnit;
        
        // 日付のNSDate→NSDateComponents変換
        NSDateComponents* dateCmp = [cal components:dateFlg fromDate:dt];

        // マークがついているものは対象外
        //NSLog(@"marks=%@, dateCmp.day=%@", marks, dateCmp);

        
        NSLog(@"marks(%d)=%d", dateCmp.day-1, [[marks objectAtIndex:(dateCmp.day-1)] boolValue]);
        if ([[marks objectAtIndex:(dateCmp.day-1)] boolValue]) continue;
        NSLog(@"entory dateCmp= %d/%d", dateCmp.month, dateCmp.day);

        
        // 開始時間
        // 時間のNSDate→NSDateComponents変換
        NSDateComponents* timeCmp = [cal components:timeFlg fromDate:appDelegate.eventStartTime];
        
        // NSDateComponentsに日付を設定
        dateCmp.hour = timeCmp.hour;
        dateCmp.minute= timeCmp.minute;
        
        // NSCalendarを使ってNSDateComponentsをNSDateに変換
        NSDate *startDate = [cal dateFromComponents:dateCmp];
        
        // 終了時間
        // 時間のNSDate→NSDateComponents変換
        timeCmp = [cal components:timeFlg fromDate:appDelegate.eventEndTime];
        
        // NSDateComponentsに日付を設定
        dateCmp.hour = timeCmp.hour;
        dateCmp.minute= timeCmp.minute;
        
        // NSCalendarを使ってNSDateComponentsをNSDateに変換
        NSDate *endDate = [cal dateFromComponents:dateCmp];
        
        //イベントの作成
        EKEvent *event = [EKEvent eventWithEventStore:appDelegate.eventStore];
        event.title = appDelegate.eventTitle;
        //event.location = @"場所";
        //日付の設定。
        event.startDate = startDate;
        event.endDate   = endDate;
        //allday = YESだと終日の予定になる
        //event.allDay = YES;
        //event.notes = @"メモ内容";
        [event setCalendar: appDelegate.calendar];
        NSError *err;
        //スケジュールをデフォルトカレンダーに予定を登録する
        [appDelegate.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        if (err) {
            [self handleError: err];
        } else {
            NSLog(@"saveEvent Success. %@", event.startDate);
            count++;
        }

        
        //NSLog(@"startDate=%@, endDate=%@", gDataStartDate, gDataEndDate);
        
        //GDataDateTime *gDataStartDate = [GDataDateTime dateTimeWithDate:startDate timeZone:[NSTimeZone systemTimeZone]];
        //GDataDateTime *gDataEndDate = [GDataDateTime dateTimeWithDate:endDate timeZone:[NSTimeZone systemTimeZone]];
        //GDataWhen *when = [GDataWhen whenWithStartTime:gDataStartDate endTime:gDataEndDate];
        //GDataEntryCalendarEvent *event = [[GDataEntryCalendarEvent alloc] init];
        //[event setTitleWithString:appDelegate.eventTitle];
        //[event addTime:when];
        //GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:0];
             
        // add it to the user's calendar
        //NSURL *feedURL = [[calendar alternateLink] URL];
/*
        GDataServiceGoogleCalendar *service = self.googleCalendarService;
        [service fetchEntryByInsertingEntry:event
                                 forFeedURL:feedURL
                                   delegate:self
                          didFinishSelector:@selector(addTicket:addedEntry:error:)];
 */
    }
    
    [monthView reload];
    
    return count;
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
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)addTicket:(GDataServiceTicket *)ticket addedEntry:(GDataEntryBase *)entry error:(NSError *)error{
    
    if( !error ){
        
        NSLog(@"GDataEntryBase=%@", entry);
        
        /*
        int count = [[endty entries] count];
        for( int i=0; i<count; i++ ){
            GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
            NSLog(@"calendar.debugDescription = %@",calendar.debugDescription);
        }
        
        parent.feed = feed;
        [self.navigationController popViewControllerAnimated:YES];
        */
    } else {
        [self handleError: error];
    }
    
}





            
@end
