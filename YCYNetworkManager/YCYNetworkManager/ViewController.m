//
//  ViewController.m
//  YCYNetworkManager
//
//  Created by terry on 16/4/27.
//  Copyright © 2016年 terry. All rights reserved.
//

#import "ViewController.h"
#import "YCYClientNetworkManager.h"

@interface ViewController ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) YCYClientNetworkManager *clientManger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:16];
    textView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:textView];
    [self getDataFromServerAndBlock:^(id data, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            [self showLog:[NSString stringWithFormat:@"%@",data]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLog:(NSString *)log
{
    NSString *currentLog = self.textView.text;
    if (currentLog.length) {
        currentLog = [currentLog stringByAppendingString:[NSString stringWithFormat:@"\n----\n%@", log]];
    } else {
        currentLog = log;
    }
    self.textView.text = currentLog;
    [self.textView sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];
}

//get请求
- (void)getDataFromServerAndBlock:(void (^)(id data, NSError *error))block
{
    self.clientManger = [[YCYClientNetworkManager alloc] init];
    
    NSDictionary *param =@{@"test":@1};
    
    [self.clientManger Get:@"http://httpbin.org/get" withParams:param withCacheDuration:10 andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
@end
