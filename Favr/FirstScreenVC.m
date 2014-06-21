//
//  FirstScreenVC.m
//  Favr
//
//  Created by Taranjit Singh on 19/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "FirstScreenVC.h"
#import "AccessContactVC.h"
#import "MBProgressHUD.h"

@interface FirstScreenVC ()
{
    MBProgressHUD *hud;
    BOOL defaultAccountFound;
}
@end

@implementation FirstScreenVC

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
    UIPanGestureRecognizer* panGues = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [panGues setMinimumNumberOfTouches:1];
    [panGues setMaximumNumberOfTouches:1];
    [panGues setDelegate:self];
    [self.imgUserLogin addGestureRecognizer:panGues];
    
    [[AccessContactVC sharedManager]setDelegate:self];
    [self setupUIForLoginVC];
    
    BOOL initiatedBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"AppHasInitiatedBefore"];

    defaultAccountFound=YES;
    
    if(!initiatedBefore){
        [self askUserForContactSharing];
    }
    else{
      //[self performSelectorInBackground:@selector(askPermissionToFetchContacts) withObject:nil];
        NSString* usrProfImagePath = @"~/Documents/userFBImage.png";
        UIImage* tempImage = [UIImage imageWithContentsOfFile:[usrProfImagePath stringByExpandingTildeInPath]];
        self.imgUserLogin.image = tempImage;
        self.verfiedUserView.hidden=NO;
        if([[AccessContactVC sharedManager] userContacts].count ==0){
            [self performSelectorInBackground:@selector(fetchContactOnBackground) withObject:nil];
        }
    }
}

-(void)askUserForContactSharing{
    UIAlertView* fetchPhoneBK = [[UIAlertView alloc] initWithTitle:@"Fetch" message:@"Do you want this app to fetch your contact" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [fetchPhoneBK show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self performSelector:@selector(signUpUser) withObject:nil afterDelay:0.5];
    }
    
    if(buttonIndex ==1){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppHasInitiatedBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(askPermissionToFetchContacts) withObject:nil afterDelay:1.0];
        
    }
}
-(void)fetchContactOnBackground{
    [[AccessContactVC sharedManager] fetchContacts];
}
-(void)askPermissionToFetchContacts{
    [[AccessContactVC sharedManager] fetchContacts];
    [[AccessContactVC sharedManager] requestFacebookAccessFirstTime];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";

}

-(void)setupUIForLoginVC{
    self.slideUnlockView.layer.cornerRadius = 30.0f;
    self.imgUserLogin.layer.cornerRadius = 25.0f;
    self.imgUserLogin.layer.masksToBounds=YES;
    self.imgUserLogin.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.imgUserLogin.layer.shadowOffset = CGSizeMake(1.0, 2.0);
   self.imgUserLogin.layer.shadowOpacity = 1.0;

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
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    if(!defaultAccountFound){
        [self performSegueWithIdentifier:@"gotoLoginView" sender:nil];
        return;
    }
    
    NSString* loggedInUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserEmail"];
    NSString* loggedInUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserPassword"];
    if(!loggedInUserEmail){
        [[AccessContactVC sharedManager] requestFacebookAccessFirstTime];
    }
    else if(loggedInUserEmail && !loggedInUserPassword){
        [[AccessContactVC sharedManager] setUserFBEmail:loggedInUserEmail];
        [self performSegueWithIdentifier:@"gotoLoginView" sender:nil];
    }
    else
        [self performSegueWithIdentifier:@"gotoTabBarController" sender:nil];
}

-(void)accessedUserFBAccountSuccessfully:(BOOL)success{
    if(success){
        self.verfiedUserView.hidden=NO;
        [hud hide:YES];
        
        NSString* usrProfImagePath = @"~/Documents/userFBImage.png";
        UIImage* tempImage = [UIImage imageWithContentsOfFile:[usrProfImagePath stringByExpandingTildeInPath]];
        self.imgUserLogin.image = tempImage;
        defaultAccountFound= YES;
    }
    else{
        [hud hide:YES];
         self.verfiedUserView.hidden=NO;
        defaultAccountFound= NO;
        UIAlertView* fetchPhoneBK = [[UIAlertView alloc] initWithTitle:@"Account" message:@"No Default Account was found on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fetchPhoneBK show];
    }
}

-(void)signUpUser{
    NSLog(@"Sign Up User");
    [self performSegueWithIdentifier:@"gotoLoginView" sender:nil];
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
