//
//  ZQDetailNewsViewController.m
//  news
//
//  Created by 黄 嘉恒 on 11/7/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "ZQDetailViewController.h"
#import "AFNetworking.h"
#import "Toast+UIView.h"
#import "ZQTableViewController.h"
#import "MTStatusBarOverlay.h"

@interface ZQDetailViewController ()

@property (nonatomic, weak)IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSDictionary *contentDict;

@end

@implementation ZQDetailViewController

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

#pragma mark - Networking

- (void)loadNews
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.ziqiang.net/api/article/?id=%@", self.sourceDict[@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.contentDict = (NSDictionary *)((NSArray *)responseObject)[0];
        [self.webView loadHTMLString:self.contentDict[@"content"] baseURL:nil];
//        [self.view hideToastActivity];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
//        [self.view hideToastActivity];
//        [self.view makeToast:@"加载失败"];
    }];
    [requestOperation start];
//    [self.view makeToastActivity];
}

- (void)setSourceDict:(NSDictionary *)sourceDict
{
    _sourceDict = sourceDict;
    [self loadNews];
    self.title = sourceDict[@"title"];
}

@end



















