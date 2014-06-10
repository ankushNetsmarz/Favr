//
//  LandingPageVC.m
//  Favr
//
//  Created by Ankush on 10/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import "LandingPageVC.h"
#import "AccessContactVC.h"
#import "ContactsData.h"

@interface LandingPageVC ()
@property(nonatomic,strong)NSArray* arrContacts;
@end

@implementation LandingPageVC

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
    self.arrContacts = [[AccessContactVC sharedManager] userContacts];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrContacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdent = [NSString stringWithFormat:@"CellIdent"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdent];
    }

    NSString* fname =((ContactsData*)[self.arrContacts objectAtIndex:indexPath.row]).firstNames;
    NSLog(@"Name %@",fname);
    cell.textLabel.text = fname;

    NSString* phoneNo =((ContactsData*)[self.arrContacts objectAtIndex:indexPath.row]).lastNames;
     NSLog(@"Ph No %@",phoneNo);
    cell.detailTextLabel.text = phoneNo;
    return cell;
}

@end
