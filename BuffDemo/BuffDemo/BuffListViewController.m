//
//  BuffListViewController.m
//  BuffDemo
//
//  Created by BoWang on 16/5/5.
//  Copyright © 2016年 BoWang. All rights reserved.
//

#import "BuffListViewController.h"
#import "BuffKit.h"
@interface BuffListViewController ()

@end

@implementation BuffListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSString *sourceStr=@"12345678901234561";
    NSData *source=[sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [source bfCryptoBlowFishEncodeWithMode:BuffCryptoModeCFB padding:YES iv:@"1234567890" key:@"1234567890" completion:^(NSData *cryptoData) {
        [cryptoData bfCryptoBlowFishDecodeWithMode:BuffCryptoModeCFB padding:NO iv:@"1234567890" key:@"1234567890" completion:^(NSData *cryptoData2) {
            NSString *result = [[NSString alloc] initWithData: cryptoData2 encoding: NSUTF8StringEncoding];
            NSLog(@"%@",result);
        }];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
