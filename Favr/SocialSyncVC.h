//
//  ViewController.h
//  GPlusSelfTut
//
//  Created by Taranjit Singh on 07/06/14.
//  Copyright (c) 2014 Taranjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListPeopleViewController.h"
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;
@interface SocialSyncVC : UIViewController <GPPSignInDelegate,ListPeopleViewControllerDelegate,UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end
