//
//  TJReportViewController.m
//  Tuijian
//
//  Created by zhang kai on 5/17/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJReportViewController.h"

@interface TJReportViewController ()<UITextViewDelegate>
{
    UITextView *reportTextView;
    UILabel *placeHolderLabel;
    UIImageView *reportImageView;
    
    MBProgressHUD *hud;
}
@end

@implementation TJReportViewController
@synthesize reportedUserId;

-(id)init
{
    if (self = [super init]) {
        
        self.title = @"举报";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelReport)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(postReport)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)cancelReport
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)postReport
{
    [self showProcessHUD];
    [[TJDataController sharedDataController]reportUser:self.reportedUserId reportedPhoto:reportImageView.image reportText:reportTextView.text success:^(BOOL succeed){
        hud.hidden = YES;
        if (succeed) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }failure:^(NSError *error){
        hud.hidden = YES;
    }];
}
- (void)showProcessHUD {
	
	hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.margin = 10.f;
	hud.removeFromSuperViewOnHide = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    reportTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [reportTextView setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    reportTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    reportTextView.keyboardType = UIKeyboardTypeDefault;
    reportTextView.returnKeyType = UIReturnKeyDefault;
    reportTextView.textAlignment = NSTextAlignmentLeft;
    reportTextView.scrollEnabled = YES;
    reportTextView.delegate = self;
    reportTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:reportTextView];
    [reportTextView becomeFirstResponder];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 0.0,100.0, 34.0)];
    [placeHolderLabel setText:@"举报理由"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    [placeHolderLabel setAlpha:0.6];
    [reportTextView addSubview:placeHolderLabel];
    
    UIButton *picButton = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 210, 120, 30)];
    [picButton addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
    [picButton setTitle:@"请上传一张截图" forState:UIControlStateNormal];
    [picButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    picButton.layer.cornerRadius = 5;
    picButton.layer.masksToBounds = YES;
    picButton.backgroundColor = UIColorFromRGB(0x3399CC);
    [self.view addSubview:picButton];

    reportImageView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 210, 80, 80)];
    [self.view addSubview:reportImageView];
}
-(void)selectPic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    reportImageView.image = chosenImage;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
#pragma text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
    }else{
        placeHolderLabel.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
    }
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
