//
//  AccessContactVC.h
//  Favr
//
//  Created by Taranjit Singh on 03/06/14.
//  Copyright (c) 2014 Netsmartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessContactVC : NSObject
@property(nonatomic,strong)NSArray* userContacts;

+(id)sharedManager;

-(void)fetchContacts;
@end
