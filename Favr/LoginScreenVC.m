//
//  LoginScreenVC.m
//  Favr
//
//  Created by Taranjit Singh on 27/05/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//
@import QuartzCore;
#import "LoginScreenVC.h"
#import "AccessContactVC.h"
#import "SocialSyncVC.h"

@interface LoginScreenVC ()

@end


@implementation LoginScreenVC

static int const kUserMinOrigin = 3;
static int const kUserMaxOrigin = 173;
static int const kUserLoginAcceptDrag = 153;

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
    [self setupUIForLoginVC];
  
    UIPanGestureRecognizer* panGues = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [panGues setMinimumNumberOfTouches:1];
    [panGues setMaximumNumberOfTouches:1];
    [panGues setDelegate:self];
    [self.imgUserLogin addGestureRecognizer:panGues];
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"AppRunningForFirstTime"];
    if(!firstTime)
        [self askUserForContactSharing];
    
}
-(void)askUserForContactSharing{
    UIAlertView* fetchPhoneBK = [[UIAlertView alloc] initWithTitle:@"Fetch" message:@"Do you want this app to fetch your contact" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [fetchPhoneBK show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){
           [[AccessContactVC sharedManager] fetchContacts];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppRunningForFirstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setupUIForLoginVC{
    self.slideUnlockView.layer.cornerRadius = 30.0f;
    self.imgUserLogin.layer.cornerRadius = 25.0f;
    self.imgUserLogin.layer.masksToBounds=YES;
    self.imgUserLogin.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.imgUserLogin.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    self.imgUserLogin.layer.shadowOpacity = 1.0;

    self.mySwitch.transform = CGAffineTransformMakeScale(0.80, 0.60);
    
    self.btnLogin.layer.cornerRadius = 15.0f;
    self.btnLogin.layer.masksToBounds=YES;
    
    self.btnSignUp.layer.cornerRadius = 15.0f;
    self.btnSignUp.layer.masksToBounds=YES;
    
    self.passwordView.layer.cornerRadius = 15.0f;
    self.passwordView.layer.masksToBounds=YES;
    self.userNameView.layer.cornerRadius = 15.0f;
    self.userNameView.layer.masksToBounds=YES;
    
}


-(void)moveImage:(UIPanGestureRecognizer*)panGues{
    CGPoint point = [panGues locationInView:self.slideUnlockView];//get the coordinate
   
    if(point.x >= kUserMinOrigin && point.x <=kUserMaxOrigin)
    {
        CGRect frame = self.imgUserLogin.frame;
        frame.origin.x=point.x-(self.imgUserLogin.frame.size.width/2);
        self.imgUserLogin.frame = frame;
        if(point.x > kUserLoginAcceptDrag){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self loginUser];
            });
        }
        
    }
    if(panGues.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.imgUserLogin.frame;
            frame.origin.x=kUserMinOrigin;
            self.imgUserLogin.frame=frame;
        }];
    }
}
-(void)loginUser{
    NSLog(@"Login User");
    [self performSegueWithIdentifier:@"SyncScreenSegue" sender:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGPoint point = CGPointMake(0,0);
    [self.mailViewScroll setContentOffset:point animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint point = CGPointMake(0,152);
    [self.mailViewScroll setContentOffset:point animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
