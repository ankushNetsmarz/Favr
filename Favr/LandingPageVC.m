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
@property(nonatomic,strong)NSMutableDictionary* dictFilteredContacts;
@property(nonatomic,strong)NSArray* arrHeaders;
@property(nonatomic,strong)NSArray* allKeys;
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
    
    self.dictFilteredContacts =[[NSMutableDictionary alloc]init];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favrNavIcon"]];
    [self.navigationController.navigationBar.topItem setTitleView:titleView];
    self.arrHeaders = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    for(NSString* str in self.arrHeaders){
        NSString* strPred = [NSString stringWithFormat:@"firstNames BEGINSWITH '%@'",str];
     //   NSLog(@"Pred Str = %@",strPred);
        NSPredicate *namesBeginning = [NSPredicate predicateWithFormat:strPred];
        NSArray* tempArr =[self.arrContacts filteredArrayUsingPredicate:namesBeginning];
     //   NSLog(@"Count  = %d", tempArr.count);
        if(tempArr.count>0)
            [self.dictFilteredContacts setObject:tempArr forKey:str];
    }
    NSLog(@"Dict = %@",self.dictFilteredContacts);
    NSArray* tempAllKeys = [self.dictFilteredContacts allKeys];
    self.allKeys = [tempAllKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    /* Create custom view to display section header... */
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 35, 35)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 25, 25)];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor whiteColor]];
    NSString *string =[self.allKeys objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [circleView addSubview:label];
    circleView.layer.cornerRadius = 17.0f;
    circleView.layer.masksToBounds=YES;
    [view setBackgroundColor:[UIColor clearColor]];
    [circleView setBackgroundColor: [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0]];
    [view addSubview:circleView];
    return view;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.allKeys count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* currentKey = [self.allKeys objectAtIndex:section];
    NSArray* tempArr = [self.dictFilteredContacts objectForKey:currentKey];

    return tempArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdent = [NSString stringWithFormat:@"CellIdent"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    NSString* currentKey = [self.allKeys objectAtIndex:indexPath.section];
    NSArray* tempContactArr = [self.dictFilteredContacts objectForKey:currentKey];
    
    NSString* fname =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).firstNames;
    NSString* lName =((ContactsData*)[tempContactArr objectAtIndex:indexPath.row]).lastNames;

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",fname,lName];
    cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:165.0f/255.0f blue:181.0f/255.0f alpha:1.0];
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50.0f;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

-(IBAction)reloadContactsTableView:(id)sender{
    [self.tableView reloadData];
}

@end
