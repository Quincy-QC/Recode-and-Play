//
//  RootViewController.m
//  录音和播放
//
//  Created by I三生有幸I on 15/7/8.
//  Copyright (c) 2015年 盛辰. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bonds].size.height
@interface RootViewController () <AVAudioPlayerDelegate>
{
    NSURL *recordedFile; // 录音路径
    AVAudioPlayer *player; // 播放音频
    AVAudioRecorder *recorder; // 录音
    UIButton *luyinButton;
    UIButton *bofangButton;

}
@property (nonatomic) BOOL isRecording; //判断是否正在进行录音
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"录音和播放";
    
    luyinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    luyinButton.frame = CGRectMake(100, 100, 100, 30);
    [luyinButton addTarget:self action:@selector(luyinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [luyinButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.view addSubview:luyinButton];
    
    bofangButton = [UIButton buttonWithType:UIButtonTypeSystem];
    bofangButton.frame = CGRectMake(100, 200, 100, 30);
    [bofangButton addTarget:self action:@selector(bofangButtonAction:) forControlEvents:UIControlEventTouchDown];
    [bofangButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:bofangButton];
    
    // 需要导入AVFoundation.framework框架
    self.isRecording = NO;
    recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    NSError *playerError;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
    if (player == nil)
    { // 如果之前没有录音存在，那么播放按钮不可用
        [bofangButton setEnabled:NO];
        bofangButton.titleLabel.alpha = 0.5;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance]; // 获取音频会话的实例
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError]; // 设置音频会话类别
    
    if(session == nil){
        NSLog(@"创建音频会话失败Error: %@", [sessionError description]);
    }
    else{
        [session setActive:YES error:nil];
    }

}

- (void)bofangButtonAction:(UIButton *)button
{
    if([player isPlaying])
    {
        [player pause];
        [bofangButton setTitle:@"播放" forState:UIControlStateNormal];
    }
    else
    {
        NSError *playerError;
        
        if (player == nil)
        {
            NSLog(@"创建录音Player失败: %@", [playerError description]);
        }
        player.delegate = self;
        [player play];
        [bofangButton setTitle:@"暂停" forState:UIControlStateNormal];
    }

}

- (void)luyinButtonAction:(UIButton *)button
{
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [luyinButton setTitle:@"停止" forState:UIControlStateNormal];
        [bofangButton setEnabled:NO];
        [bofangButton.titleLabel setAlpha:0.5];
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];
        player = nil;
    }
    else
    {
        self.isRecording = NO;
        [luyinButton setTitle:@"录音" forState:UIControlStateNormal];
        [bofangButton setEnabled:YES];
        [bofangButton.titleLabel setAlpha:1];
        [recorder stop];
        recorder = nil;
        
        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil)
        {
            NSLog(@"创建录音Player失败: %@", [playerError description]);
        }
        player.delegate = self;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [bofangButton setTitle:@"播放" forState:UIControlStateNormal];
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
