//
//  signUp.h
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUp : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end
