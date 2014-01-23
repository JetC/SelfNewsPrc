//
//  ZQViewController.h
//  SelfNewsPrc
//
//  Created by 孙培峰 on 1401/22/.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSMutableDictionary *states;
@property (nonatomic,retain)NSArray *dataSource;

-(void)setupArray;


@end
