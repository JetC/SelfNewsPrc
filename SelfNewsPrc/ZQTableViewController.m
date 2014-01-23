//
//  ZQTableViewController.m
//  SelfNewsPrc
//
//  Created by 孙培峰 on 1401/22/.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "ZQTableViewController.h"
#import "ZQDetailViewController.h"
#import "Toast+UIView.h"

#define kNumberOfNewsLoadEachTime 15

@interface ZQTableViewController ()

@property (nonatomic, strong) NSArray *news;
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

- (void)loadNews
{
    if (self.category && !self.refreshDataTask)
    {
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.category, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        NSString *urlString = [NSString stringWithFormat:@"http://news.ziqiang.net/api/article/?n=%i&s=%@&p=%i",kNumberOfNewsLoadEachTime,encodedString,[self.news count]/kNumberOfNewsLoadEachTime+1];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        self.refreshDataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                if (!error)
                {
                    NSArray *news = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    self.news = [self.news arrayByAddingObjectsFromArray:news];
                    [self.tableView reloadData];
                }
                else
                {
                    NSLog(@"%@",error);
                }
                self.refreshDataTask = nil;
            }];
        [self.refreshDataTask resume];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.category = @"最新";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y>=self.tableView.contentSize.height-self.tableView.bounds.size.height-self.tableView.contentInset.bottom) {
        [self loadNews];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZQDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ZQDetailViewController"];
    viewController.sourceDict = (NSDictionary *)self.news[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Utilities

- (NSArray *)news
{
    if (!_news) {
        _news = @[];
    }
    return _news;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
