//
//  ViewController.m
//  GPlusSelfTut
//
//  Created by Taranjit Singh on 07/06/14.
//  Copyright (c) 2014 Taranjit Singh. All rights reserved.
//

#import "SocialSyncVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ShareConfiguration.h"
#import "AccessContactVC.h"

@interface SocialSyncVC ()
@end

@implementation SocialSyncVC
static NSString * const kClientId = @"568503989663-c8pb9qtnd09cf8o7ohs1ugmnko16ocpt.apps.googleusercontent.com";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    [ShareConfiguration sharedInstance].useNativeSharebox=YES;
    [ShareConfiguration sharedInstance].sharePrefillText=@"Hi Bro, Just Testing.. :)";
    [ShareConfiguration sharedInstance].shareURL=@"www.WeExcel.com";
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    [self.signInButton setStyle:kGPPSignInButtonStyleIconOnly];
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
}


- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}


#pragma mark - ListPeopleViewControllerDelegate

- (void)viewController:(ListPeopleViewController *)viewController didPickPeople:(NSArray *)people {
    [ShareConfiguration sharedInstance].sharePrefillPeople = people;
    [self performSelector:@selector(shareButton:) withObject:nil afterDelay:1.0];

}

-(IBAction)inviteGooglePlusPeople:(id)sender{
    ListPeopleViewController *peoplePicker =
    [[ListPeopleViewController alloc] initWithNibName:nil bundle:nil];
    peoplePicker.allowSelection = YES;
    peoplePicker.delegate = self;
    peoplePicker.navigationItem.title = @"Pick people";
    [self presentViewController:peoplePicker animated:YES completion:nil];

    
}
- (IBAction)shareButton:(id)sender {
    id<GPPShareBuilder> shareBuilder = [self shareBuilder];
    if (![shareBuilder open]) {
        NSLog(@"Status: Error (see console).");
    }
}
- (id<GPPShareBuilder>)shareBuilder {
    // End editing to make sure all changes are saved to [ShareConfiguration sharedInstance].
    [self.view endEditing:YES];
    
    // Create the share builder instance.
    id<GPPShareBuilder> shareBuilder = [ShareConfiguration sharedInstance].useNativeSharebox ?
    [[GPPShare sharedInstance] nativeShareDialog] :
    [[GPPShare sharedInstance] shareDialog];
    
    if ([ShareConfiguration sharedInstance].urlEnabled) {
        NSString *inputURL = [ShareConfiguration sharedInstance].shareURL;
        NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
        if (urlToShare) {
            [shareBuilder setURLToShare:urlToShare];
        }
    }
    
    // Add deep link content.
    if ([ShareConfiguration sharedInstance].deepLinkEnabled) {
        [shareBuilder setContentDeepLinkID:[ShareConfiguration sharedInstance].contentDeepLinkID];
        NSString *title = [ShareConfiguration sharedInstance].contentDeepLinkTitle;
        NSString *description = [ShareConfiguration sharedInstance].contentDeepLinkDescription;
        NSString *urlString = [ShareConfiguration sharedInstance].contentDeepLinkThumbnailURL;
        NSURL *thumbnailURL = urlString.length ? [NSURL URLWithString:urlString] : nil;
        [shareBuilder setTitle:title description:description thumbnailURL:thumbnailURL];
    }
    
    NSString *inputText = [ShareConfiguration sharedInstance].sharePrefillText;
    NSString *text = [inputText length] ? inputText : nil;
    if (text) {
        [shareBuilder setPrefillText:text];
    }
    
    
    // Attach media if we are using the native sharebox and have selected a media element.,
    if ([ShareConfiguration sharedInstance].useNativeSharebox) {
        if ([ShareConfiguration sharedInstance].mediaAttachmentEnabled) {
            if ([ShareConfiguration sharedInstance].attachmentImage) {
                [(id<GPPNativeShareBuilder>)shareBuilder attachImage:[ShareConfiguration sharedInstance].attachmentImage];
            } else if ([ShareConfiguration sharedInstance].attachmentVideoURL) {
                [(id<GPPNativeShareBuilder>)shareBuilder attachVideoURL:
                 [ShareConfiguration sharedInstance].attachmentVideoURL];
            }
        }
        if ([ShareConfiguration sharedInstance].sharePrefillPeople.count) {
            [(id<GPPNativeShareBuilder>)shareBuilder
             setPreselectedPeopleIDs:[ShareConfiguration sharedInstance].sharePrefillPeople];
        }
    }
    
    return shareBuilder;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FACEBOOK API

-(IBAction)fetchFBFriends:(id)sender{
    [[AccessContactVC sharedManager] inviteNonFriends];
}
@end
