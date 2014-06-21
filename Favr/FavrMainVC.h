//
//  FavrMainVC.h
//  Favr
//
//  Created by Taranjit Singh on 14/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface FavrMainVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property(nonatomic,weak)IBOutlet UINavigationBar* navigationBar;
@property(nonatomic,weak)IBOutlet UISegmentedControl* segmentControl;
-(IBAction)listIncomingOutgoing:(UISegmentedControl*)sender;
@end
