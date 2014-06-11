//
//  signUp.m
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "signUp.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
@interface signUp ()
{
    MBProgressHUD *HUD;
}
@end

@implementation signUp

static int const KAllInputField = 5;

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
    
    for(UIView* view in self.mainScrollView.subviews){
        if (view.tag == KAllInputField) {
            view.layer.cornerRadius= 15.0f;
            view.layer.masksToBounds=YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelSignUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signUpUser:(UIButton *)sender {
    if(![self validateFields])
        return;
    
    NSLog(@"email: %@", self.txtEmail.text);
    [PFCloud callFunctionInBackground:@"singUp"
                       withParameters:@{@"emailId": self.txtEmail.text,
                                        @"pwd":self.txtPassword.text,
                                        @"fullName": self.txtFullName.text}
                                block:^(NSString *results, NSError *error) {
                                    if (!error) {
                                        NSLog(@"result: %@",results);
                                        
                                        if([results isEqualToString:@"You are already registered, Try LogIn !"])
                                        {
                                            [self showAlertWithText:@"Favr" :results];
                                        }
                                        else{
                                            
                                            [self performSegueWithIdentifier:@"socialPage"  sender:nil];
                                           // [HUD removeFromSuperview];
                                            //[self performSelector:@selector(cancelSignUp:) withObject:nil afterDelay:2.0];
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }];
}

-(BOOL)validateFields{
    if(self.txtFullName.text.length == 0 ){
        [self showAlertWithText:@"Error" :@"Please enter a valid Full name"];
        return NO;
    }
    if(self.txtEmail.text.length == 0 ){
        [self showAlertWithText:@"Error" :@"Please enter a valid Email Address"];
        return NO;
    }
    if(![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]){
        [self showAlertWithText:@"Error" :@"Password and Confirm Password does not match"];
        return NO;
    }
 
    return YES;
}

-(void)showAlertWithText:(NSString*)title :(NSString*)message{
    UIAlertView* validationAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [validationAlert show]
    ;
}
- (void)showLoadingWithLabel{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.labelText = @"Loading";

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGPoint point = CGPointMake(0,0);
    [self.mainScrollView setContentOffset:point animated:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint point = CGPointMake(0,152);
    [self.mainScrollView setContentOffset:point animated:YES];
    return YES;
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
