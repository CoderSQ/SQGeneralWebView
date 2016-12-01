//
//  TestViewController.m
//  SQGeneralWebView
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
#import "ViewController1.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
- (IBAction)lehuClick:(id)sender {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pictureClick:(id)sender {
    ViewController1 *vc = [[ViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
