//
//  ZQNewsTableViewController.m
//  news
//
//  Created by 黄 嘉恒 on 11/7/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQTableViewController.h"
#import "ZQDetailViewController.h"
#import "Toast+UIView.h"
#import "MTStatusBarOverlay.h"


#define kNumberOfNewsLoadEachTime 15

@interface ZQTableViewController ()

@property (nonatomic, strong) NSArray *news;
//@property (nonatomic, strong) AFHTTPRequestOperation *newsRequestOperation;
@property (nonatomic, strong) NSURLSessionDataTask *refreshDataTask;
@end

@implementation ZQTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.category = @"最新";
    [self loadNews];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;//网络信号右侧转菊花并保持,需手动撤销
    //[self showStatusOnNavigationBar];
//    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
//    [overlay postMessage:@"123"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)loadNews
{
//    UIView *toastView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [self.view.superview insertSubview:toastView atIndex:1];
//    NSLog(@"%@",self.view.superview);
//    [toastView makeToastActivity:@"center" message:@"正在努力加载"];
    
    
    if (self.category && !self.refreshDataTask)
    {
        NSString* encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.category, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        NSString *urlString = [NSString stringWithFormat:@"http://news.ziqiang.net/api/article/?n=%i&s=%@&p=%i",kNumberOfNewsLoadEachTime, encodedString, [self.news count]/kNumberOfNewsLoadEachTime+1];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        self.refreshDataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                {
                                    if (!error) {
                                        NSArray *news = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                        self.news = [self.news arrayByAddingObjectsFromArray:news];
                                        [self.tableView reloadData];
                                        [self.view.superview hideToastActivity];
                                        [self.view hideToastActivity];

                                    } else {
                                        NSLog(@"%@",error);
                                    }
                                    [self.view hideToastActivity];
                                    self.refreshDataTask = nil;
                                }];
        [self.refreshDataTask resume];
        
        
        
        NSLog(@"%@",self.view.superview);
        //[self.navigationController.navigationBar.]
        //TODO:用NavigationBar做提示怎么样？
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.news count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"textNews";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *pieceOfNews = self.news[indexPath.row];
    cell.textLabel.text = pieceOfNews[@"title"];
    
    NSString *detailText = [NSString stringWithFormat:@" %@",pieceOfNews[@"published"]];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

#pragma mark - Table view dalegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y>=self.tableView.contentSize.height-self.tableView.bounds.size.height-self.tableView.contentInset.bottom)
    {
        [self loadNews];
        if ([self.news count] != 0)
        {
            UIView *footer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, 45)];
            footer.backgroundColor = [UIColor blackColor];
            [footer makeToastActivity:@"center" message:@"123"];
            self.tableView.tableFooterView = footer;
            
        }

        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZQDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"detailNews"];
    viewController.sourceDict = (NSDictionary *)self.news[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark NavigationBar

- (void)showStatusOnNavigationBar:(NSString *)message
{
    self.messageLabel.frame = [UIApplication sharedApplication].statusBarFrame;
    self.messageLabel.backgroundColor = [UIColor blackColor];
}

- (void)showStatusOnNavigationBar
{
    self.messageLabel.frame = [UIApplication sharedApplication].statusBarFrame;
    self.messageLabel.backgroundColor = [UIColor greenColor];
}

- (void)hideStatusOnNavigationBar
{
    
}

#pragma mark - Utilities

- (NSArray *)news
{
    if (!_news) {
        _news = @[];
    }
    return _news;
}

@end
