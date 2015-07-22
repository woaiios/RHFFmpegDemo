//
//  ViewController.m
//  RhFFmpeg-Object-C_Demo
//
//  Created by sun on 15/7/22.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "ViewController.h"
#import "avformat.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    av_register_all();
   unsigned int v = avformat_version();
    NSLog(@"%d",v);//3679332
    av_register_all();
    
    AVFormatContext *ctx = NULL;
    const char *filePath = [[[NSBundle mainBundle] pathForResource:@"videoplayback_4" ofType:@"mp4"] cStringUsingEncoding:NSUTF8StringEncoding];
    int stau = avformat_open_input(&ctx, filePath, NULL, NULL);
    if (stau == 0) {
        av_dump_format(ctx, 0, filePath, 0);
        avformat_close_input(&ctx);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
