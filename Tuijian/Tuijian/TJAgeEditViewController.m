//
//  TJAgeEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJAgeEditViewController.h"

@interface TJAgeEditViewController ()
{
    UILabel *datelabel;
    UIDatePicker *datePicker;
}
@end

@implementation TJAgeEditViewController

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
    self.title = @"生日";
    self.view.backgroundColor = [UIColor whiteColor];
    
    datelabel = [[UILabel alloc] init];
    datelabel.frame = CGRectMake(10, 100, 300, 40);
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.textColor = [UIColor blackColor];
    datelabel.font = [UIFont boldSystemFontOfSize:22];
    datelabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd"];;
//    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    NSDate *anyDate = [dateFormat dateFromString:@"1990-01-01"];
    
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [dateFormat stringFromDate:anyDate]];
    [self.view addSubview:datelabel];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 325, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker setDate:anyDate];
    
    [datePicker addTarget:self
                   action:@selector(selectBirthday)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
}
-(void)selectBirthday
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
