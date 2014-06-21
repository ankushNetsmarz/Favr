//
//  LandingPageVC.h
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingPageVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property(nonatomic,weak)IBOutlet UINavigationBar* navigationBar;
-(IBAction)reloadContactsTableView:(id)sender;
@end
