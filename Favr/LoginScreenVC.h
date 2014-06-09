//
//  LoginScreenVC.h
//  Favr
//
//  Created by Taranjit Singh on 27/05/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreenVC : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic, weak)IBOutlet UIView* slideUnlockView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrowInUnlockView;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIScrollView *mailViewScroll;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@end
