//
//  PendingFavrVC.m
//  Favr
//
//  Created by Taranjit Singh on 14/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//
@import QuartzCore;
#import "PendingFavrVC.h"
#import "FavrCell.h"

@interface PendingFavrVC ()
{
    NSString* incomming_Outgoing;
    NSMutableArray *arrData;
}
@end

static NSString const *kMsgIncomming = @"INCOMMING";
static NSString const *kMsgOutgoing = @"OUTGOING";

@implementation PendingFavrVC


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
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
    [self.navigationBar.topItem setTitleView:titleView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"FavrCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
    incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
    arrData = [[NSMutableArray alloc]initWithObjects:@"Favour 1",@"Favour 2",@"Favour 3",@"Favour 4",@"Favour 5",@"Favour 6",@"Favour 7",@"Favour 8",@"Favour 9",@"Favour 10", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString  *cellIdentifier = @"cellIdentifier";
    
    FavrCell *cell = (FavrCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if(!cell){
        cell = [[FavrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if ([incomming_Outgoing isEqualToString:(NSString*)kMsgIncomming]) {
        cell.rightUtilityButtons = [self rightButtonsForIncoming];
        cell.imgFavrPic.image = [UIImage imageNamed:@"userImg"];
        cell.lblFavrName.text = @"Jane Doe";
    }
    else{
        cell.rightUtilityButtons = [self rightButtonsForOutgoing];
        cell.imgFavrPic.image = [UIImage imageNamed:@"userImage2.jpg"];
        cell.lblFavrName.text = @"Sandy Jolie";
    }
    cell.delegate = self;
    
    cell.imgFavrPic.layer.cornerRadius = 25.0f;
    cell.imgFavrPic.layer.masksToBounds=YES;
    
    cell.lblFavrNo.text = [arrData objectAtIndex:indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (NSArray *)rightButtonsForIncoming
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cellChat"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cross"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"check"]];
 
    return rightUtilityButtons;
}

- (NSArray *)rightButtonsForOutgoing
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"cellEdit"]];
    
  
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0] icon:[UIImage imageNamed:@"trashBtn"]];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSLog(@"Right index  = %d",index);
    if([incomming_Outgoing isEqualToString:(NSString*)kMsgOutgoing]){
        if(index==1){
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [arrData removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(IBAction)listIncomingOutgoing:(UISegmentedControl*)sender{
    if(sender.selectedSegmentIndex==0){
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgIncomming];
    }
    else{
        incomming_Outgoing =[NSString stringWithFormat:@"%@",kMsgOutgoing];
    }
    [self.tableView reloadData];
}

@end
