//
//  ZQDetailViewController.m
//  SelfNewsPrc
//
//  Created by 孙培峰 on 1401/22/.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "ZQDetailViewController.h"
#import "AFNetworking.h"
#import "Toast+UIView.h"

@interface ZQDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic)NSDictionary *contentDict;

@end

@implementation ZQDetailViewController

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
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNews
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.ziqiang.net/api/article/?id=%@", self.sourceDict[@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.contentDict = (NSDictionary *)((NSArray *)responseObject)[0];
        [self.webView loadHTMLString:self.contentDict[@"content"] baseURL:nil];
        [self.view hideToastActivity];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.view hideToastActivity];
        [self.view makeToast:@"加载失败"];
    }];
    [requestOperation start];
    [self.view makeToastActivity];
}

- (void)setSourceDict:(NSDictionary *)sourceDict
{
    _sourceDict = sourceDict;
    [self loadNews];
    self.title = sourceDict[@"title"];
}
























@end
