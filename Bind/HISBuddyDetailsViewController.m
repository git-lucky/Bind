//
//  HISDetailsVC.m
//  Bind
//
//  Created by Tim Hise on 2/3/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISBuddyDetailsViewController.h"
#import "HISEditBuddyViewController.h"
#import "M13ProgressViewPie.h"
#import "HISLocalNotificationController.h"
#import <Social/Social.h>

//*****************************************
// Icon and Animation Constants
    const int   ACTIVITIES_ICON_SIZE = 50;
    const float HYPOTENUSE = 75;
//*****************************************

@interface HISBuddyDetailsViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>{
    //Animation Vars
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UIDynamicBehavior  *_behavior;
    UISnapBehavior *_snap0o;
    UISnapBehavior *_snap45o;
    UISnapBehavior *_snap90o;
    UISnapBehavior *_snap135o;
    UISnapBehavior *_snap180o;
    BOOL _buttonsOut;
    CGPoint _pt0o_out;
    CGPoint _pt0o_in;
}
@property (strong, nonatomic) IBOutlet UIButton *btnText;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (nonatomic, readwrite) CGRect phoneButtonBounds;
@property (weak, nonatomic) IBOutlet M13ProgressViewPie *progressViewPie;
@property (weak, nonatomic) IBOutlet UIButton *composeMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *textMessageButton;
@property (strong, nonatomic) HISLocalNotificationController *localNotificationController;

// Animation View
@property (strong, nonatomic) UIView *vwMainBtn;
@property (strong, nonatomic) UIView *view0o;
@property (strong, nonatomic) UIView *view45o;
@property (strong, nonatomic) UIView *view90o;
@property (strong, nonatomic) UIView *view135o;
@property (strong, nonatomic) UIView *view180o;

@end

@implementation HISBuddyDetailsViewController

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
    
    self.navigationItem.title = self.buddy.name;
    
    [HISCollectionViewDataSource makeRoundView:self.imageView];
    
    [self setOutletsWithBuddyDetails];
    [self processAndDisplayBackgroundImage:backgroundImage];
    
    self.phoneButtonBounds = self.phoneButton.bounds;
    self.phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.phoneButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    self.localNotificationController = [[HISLocalNotificationController alloc] init];
    
    // RPL Animation
    _buttonsOut = NO;
    float vwMainBtnSide = 50;
    float vwMainBtnX = (self.view.frame.size.width/2) - (vwMainBtnSide/2);
    float vwMainBtnY = (self.view.frame.size.height - vwMainBtnSide - 5); // 10 Padding
    
    // Create "We" View
    self.vwMainBtn = [[UIView alloc]initWithFrame:CGRectMake(vwMainBtnX, vwMainBtnY, vwMainBtnSide, vwMainBtnSide)];
    self.vwMainBtn.backgroundColor = [UIColor redColor];
    self.vwMainBtn.layer.masksToBounds = YES;
    self.vwMainBtn.layer.cornerRadius = vwMainBtnSide/2;
    
    // Create "We" Button
    UIButton *btnMain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnMain setTitle:@"We" forState:UIControlStateNormal];
    [btnMain addTarget:self action:@selector(pressedMainButton:) forControlEvents:UIControlEventTouchUpInside];  // #pragma mark - selectors
    [btnMain setFrame:CGRectMake(0, 0, self.vwMainBtn.frame.size.width, self.vwMainBtn.frame.size.height)];
    [self.vwMainBtn addSubview:btnMain];
    
    // Create
    self.view0o = [[UIView alloc] initWithFrame:CGRectMake(self.vwMainBtn.frame.origin.x,
                                                           self.vwMainBtn.frame.origin.y,
                                                           ACTIVITIES_ICON_SIZE,
                                                           ACTIVITIES_ICON_SIZE)];
    _pt0o_in = CGPointMake(self.vwMainBtn.frame.origin.x, self.vwMainBtn.frame.origin.y);
    self.view0o.backgroundColor = [UIColor greenColor];
    self.view0o.layer.masksToBounds = YES;
    self.view0o.layer.cornerRadius = ACTIVITIES_ICON_SIZE/2;
    [self.view addSubview:self.view0o];
    
    UIButton *btn0o = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn0o setTitle:@"Talked" forState:UIControlStateNormal];
    [btn0o addTarget:self action:@selector(pressed0oButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn0o setFrame:CGRectMake(0, 0, self.view0o.frame.size.width, self.view0o.frame.size.height)];
    [self.view0o addSubview:btn0o];
    
    self.view45o = [[UIView alloc] initWithFrame:CGRectMake(self.vwMainBtn.frame.origin.x,
                                                            self.vwMainBtn.frame.origin.y,
                                                            ACTIVITIES_ICON_SIZE,
                                                            ACTIVITIES_ICON_SIZE)];
    self.view45o.backgroundColor = [UIColor greenColor];
    self.view45o.layer.masksToBounds = YES;
    self.view45o.layer.cornerRadius = ACTIVITIES_ICON_SIZE/2;
    [self.view addSubview:self.view45o];
    
    UIButton *btn45o = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn45o setTitle:@"Wrote" forState:UIControlStateNormal];
    [btn45o addTarget:self action:@selector(pressed45oButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn45o setFrame:CGRectMake(0, 0, self.view45o.frame.size.width, self.view45o.frame.size.height)];
    [self.view45o addSubview:btn45o];
    
    self.view90o = [[UIView alloc] initWithFrame:CGRectMake(self.vwMainBtn.frame.origin.x,
                                                            self.vwMainBtn.frame.origin.y,
                                                            ACTIVITIES_ICON_SIZE,
                                                            ACTIVITIES_ICON_SIZE)];
    self.view90o.backgroundColor = [UIColor greenColor];
    self.view90o.layer.masksToBounds = YES;
    self.view90o.layer.cornerRadius = ACTIVITIES_ICON_SIZE/2;
    [self.view addSubview:self.view90o];
    
    UIButton *btn90o = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn90o setTitle:@"Hang" forState:UIControlStateNormal];
    [btn90o addTarget:self action:@selector(pressed90oButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn90o setFrame:CGRectMake(0, 0, self.view90o.frame.size.width, self.view90o.frame.size.height)];
    [self.view90o addSubview:btn90o];
    
    self.view135o = [[UIView alloc] initWithFrame:CGRectMake(self.vwMainBtn.frame.origin.x,
                                                             self.vwMainBtn.frame.origin.y,
                                                             ACTIVITIES_ICON_SIZE,
                                                             ACTIVITIES_ICON_SIZE)];
    self.view135o.backgroundColor = [UIColor greenColor];
    self.view135o.layer.masksToBounds = YES;
    self.view135o.layer.cornerRadius = ACTIVITIES_ICON_SIZE/2;
    [self.view addSubview:self.view135o];
    
    UIButton *btn135o = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn135o setTitle:@"Gifted" forState:UIControlStateNormal];
    [btn135o addTarget:self action:@selector(pressed135oButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn135o setFrame:CGRectMake(0, 0, self.view135o.frame.size.width, self.view135o.frame.size.height)];
    [self.view135o addSubview:btn135o];
    
    self.view180o = [[UIView alloc] initWithFrame:CGRectMake(self.vwMainBtn.frame.origin.x,
                                                             self.vwMainBtn.frame.origin.y,
                                                             ACTIVITIES_ICON_SIZE,
                                                             ACTIVITIES_ICON_SIZE)];
    self.view180o.backgroundColor = [UIColor greenColor];
    self.view180o.layer.masksToBounds = YES;
    self.view180o.layer.cornerRadius = ACTIVITIES_ICON_SIZE/2;
    [self.view addSubview:self.view180o];
    
    UIButton *btn180o = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn180o setTitle:@"Social" forState:UIControlStateNormal];
    [btn180o addTarget:self action:@selector(pressed180oButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn180o setFrame:CGRectMake(0, 0, self.view180o.frame.size.width, self.view180o.frame.size.height)];
    [self.view180o addSubview:btn180o];
    
    // Add "We" View
    [self.view addSubview:self.vwMainBtn];
    
    // Dynamics
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)setOutletsWithBuddyDetails
{
    if (self.buddy.pic) {
        self.imageView.image = self.buddy.pic;
    } else if (self.buddy.imagePath) {
        self.imageView.image = [UIImage imageWithContentsOfFile:self.buddy.imagePath];
    } else {
        self.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
    
    [self.progressViewPie setProgress:self.buddy.affinity animated:NO];
    
    [self makeButtonRoundWithWhiteBorder:self.phoneButton];
    [self makeButtonRoundWithWhiteBorder:self.textMessageButton];
    [self makeButtonRoundWithWhiteBorder:self.composeMessageButton];
}

- (void)makeButtonRoundWithWhiteBorder:(UIButton *)button
{
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = button.frame.size.width / 2;
}

- (void)processAndDisplayBackgroundImage:(NSString *)imageName
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

#pragma mark - Action Buttons

- (IBAction)phoneButton:(id)sender
{
    NSString *phoneString = self.buddy.phone;
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self addAffinity:.2];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneString]]];
}

- (IBAction)tweetButton:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *address = [NSString stringWithFormat:@"%@ ",self.buddy.twitter];
        [tweetSheet setInitialText:address];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)facebookButton:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Hello"];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)textButton:(id)sender
{
//    [[UINavigationBar appearance] setTranslucent:NO];
    [self showSMS:nil];
}

#pragma mark - Selector - Activity Buttons

-(void)pressedMainButton:(UIButton *)sender
{
    if(!_buttonsOut) {
        [_animator removeAllBehaviors];
        
        float adjacentLength = HYPOTENUSE*0.78539816339; // constant for (45degrees*PI/180)
        float oppositeLength = HYPOTENUSE*0.78539816339;
        
        _pt0o_out = CGPointMake(self.vwMainBtn.frame.origin.x+HYPOTENUSE+ACTIVITIES_ICON_SIZE/4+ACTIVITIES_ICON_SIZE/2,
                                   self.vwMainBtn.frame.origin.y);
        _snap0o = [[UISnapBehavior alloc] initWithItem:self.view0o snapToPoint:_pt0o_out];

        CGPoint pt45o = CGPointMake(self.vwMainBtn.frame.origin.x+adjacentLength+ACTIVITIES_ICON_SIZE/2,
                                    self.vwMainBtn.frame.origin.y-oppositeLength);
        _snap45o = [[UISnapBehavior alloc] initWithItem:self.view45o snapToPoint:pt45o];

        CGPoint pt90o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                    self.vwMainBtn.frame.origin.y-HYPOTENUSE);
        _snap90o = [[UISnapBehavior alloc] initWithItem:self.view90o snapToPoint:pt90o];
        
        CGPoint pt135o = CGPointMake(self.vwMainBtn.frame.origin.x-adjacentLength+ACTIVITIES_ICON_SIZE/2,
                                    self.vwMainBtn.frame.origin.y-oppositeLength);
        _snap135o = [[UISnapBehavior alloc] initWithItem:self.view135o snapToPoint:pt135o];
        
        CGPoint pt180o = CGPointMake(self.vwMainBtn.frame.origin.x-adjacentLength-ACTIVITIES_ICON_SIZE/2+ACTIVITIES_ICON_SIZE/2,
                                     self.vwMainBtn.frame.origin.y);
        _snap180o = [[UISnapBehavior alloc] initWithItem:self.view180o snapToPoint:pt180o];
        
        [_snap0o setDamping:0.2];
        [_snap45o setDamping:0.2];
        [_snap90o setDamping:0.2];
        [_snap135o setDamping:0.2];
        [_snap180o setDamping:0.2];
        
        [_animator addBehavior:_snap0o];
        [_animator addBehavior:_snap45o];
        [_animator addBehavior:_snap90o];
        [_animator addBehavior:_snap135o];
        [_animator addBehavior:_snap180o];
        _buttonsOut = YES;
        
    } else {
        [_animator removeAllBehaviors];
        
        CGPoint pt0o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                   self.vwMainBtn.frame.origin.y+ACTIVITIES_ICON_SIZE/2);
        UISnapBehavior *snap0oBack = [[UISnapBehavior alloc] initWithItem:self.view0o snapToPoint:pt0o];
        
        UISnapBehavior *snap45o;
        CGPoint pt45o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                    self.vwMainBtn.frame.origin.y+ACTIVITIES_ICON_SIZE/2);
        snap45o = [[UISnapBehavior alloc] initWithItem:self.view45o snapToPoint:pt45o];
        
        UISnapBehavior *snap90o;
        CGPoint pt90o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                    self.vwMainBtn.frame.origin.y+ACTIVITIES_ICON_SIZE/2);
        snap90o = [[UISnapBehavior alloc] initWithItem:self.view90o snapToPoint:pt90o];
        
        UISnapBehavior *snap135o;
        CGPoint pt135o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                     self.vwMainBtn.frame.origin.y+ACTIVITIES_ICON_SIZE/2);
        snap135o = [[UISnapBehavior alloc] initWithItem:self.view135o snapToPoint:pt135o];
        
        UISnapBehavior *snap180o;
        CGPoint pt180o = CGPointMake(self.vwMainBtn.frame.origin.x+ACTIVITIES_ICON_SIZE/2,
                                     self.vwMainBtn.frame.origin.y+ACTIVITIES_ICON_SIZE/2);
        snap180o = [[UISnapBehavior alloc] initWithItem:self.view180o snapToPoint:pt180o];
    
        [snap0oBack setDamping:0.2];
        [snap45o setDamping:0.2];
        [snap90o setDamping:0.2];
        [snap135o setDamping:0.2];
        [snap180o setDamping:0.2];
        
        [_animator addBehavior:snap0oBack];
        [_animator addBehavior:snap45o];
        [_animator addBehavior:snap90o];
        [_animator addBehavior:snap135o];
        [_animator addBehavior:snap180o];
        
        _buttonsOut = NO;
    }
}

-(void)pressed0oButton:(UIButton *)sender //Talked
{
    
}

-(void)pressed45oButton:(UIButton *)sender //Wrote
{
    
}

-(void)pressed90oButton:(UIButton *)sender // Hang
{
    
}

-(void)pressed135oButton:(UIButton *)sender // Gifted
{
    
}

-(void)pressed180oButton:(UIButton *)sender // Social
{
    
}

#pragma mark - Controller

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            //TODO: add timestamp and don't continue adding points for message after the first one for a day
            [self addAffinity:.12];
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS:(NSString*)file {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    NSArray *recipents = @[self.buddy.phone];
    NSString *message = @"I really miss you buddy";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];

}

- (IBAction)emailNow:(id)sender {
        // Email Subject
//        NSString *emailTitle = @"BooYah";
        // Email Content
//        NSString *messageBody = @"iOS programming is so fun!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:self.buddy.email];
        
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
//        [mailComposeViewController setSubject:emailTitle];
//        [mailComposeViewController setMessageBody:messageBody isHTML:NO];
        [mailComposeViewController setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mailComposeViewController animated:YES completion:NULL];
}
    
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [self addAffinity:.08];
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)weHungOutButton:(id)sender {
    [self addAffinity:.25];
}

- (IBAction)theyCalledMeButton:(id)sender {
    [self addAffinity:.12];
}

- (IBAction)drainAffinity:(id)sender {
    self.buddy.affinity = self.buddy.affinity - .25;
    [self.progressViewPie setProgress:self.buddy.affinity animated:YES];
    self.buddy.hasChanged = YES;
    [[HISCollectionViewDataSource sharedDataSource] saveRootObject];
}

- (void)addAffinity:(double)number
{
    if (self.buddy.affinity < 1) {
        self.buddy.affinity = self.buddy.affinity + number;
        [self.progressViewPie setProgress:self.buddy.affinity animated:YES];
        self.buddy.hasChanged = YES;
        
        [self.localNotificationController cancelNotificationsForBuddy:self.buddy];
        
        self.buddy.dateOfLastInteraction = [NSDate date];
        
        [self.localNotificationController scheduleNotificationsForBuddy:self.buddy];
        
        [[HISCollectionViewDataSource sharedDataSource] saveRootObject];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toEdit"]) {
        HISEditBuddyViewController *destVC = segue.destinationViewController;
        destVC.buddy = self.buddy;
    }
}

- (IBAction)editedFriend:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[HISEditBuddyViewController class]]) {
        HISEditBuddyViewController *editBuddyViewController = (HISEditBuddyViewController *)segue.sourceViewController;
        self.buddy = editBuddyViewController.buddy;
        HISBuddy *editedBuddy = editBuddyViewController.editedBuddy;
        
        if (editedBuddy) {
//            [self.dataSource.buddies removeObject:self.buddy];
//            [self.dataSource.buddies insertObject:editedBuddy atIndex:self.indexPath.row];
            [[HISCollectionViewDataSource sharedDataSource].buddies removeObject:self.buddy];
            [[HISCollectionViewDataSource sharedDataSource].buddies insertObject:editedBuddy atIndex:self.indexPath.row];
            [[HISCollectionViewDataSource sharedDataSource] saveRootObject];
            self.buddy = editedBuddy;
            [self setOutletsWithBuddyDetails];
        }
    }
}


#pragma mark - Commented Out

//- (IBAction)phoneButton:(id)sender {
//
//    if([MFMessageComposeViewController canSendText]) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
//        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.buddy.phone]]];
//    }
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Call"]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.buddy.phone]]];
//        [self addAffinity:.2];
//    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Text"]) {
//        [self showSMS:nil];
//    } else {
//        return;
//    }
//}

@end
