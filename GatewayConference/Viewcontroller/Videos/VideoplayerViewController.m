//
//  VideoplayerViewController.m
//  GatewayConference
//
//  Created by Teja Swaroop on 20/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "VideoplayerViewController.h"

@interface VideoplayerViewController ()

@end

@implementation VideoplayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.title = self.modelObj.title;
    
    [self playVideo:self.modelObj.url];
  
}

- (void)playVideo:(NSString*)videourlStr
{
    NSString *url = videourlStr;
    
    NSURL *fileURL = [NSURL URLWithString:url];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.moviePlayer.view setFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-60)];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullScreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidExitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:self.moviePlayer];
    
    
    [self.view addSubview:self.moviePlayer.view];
    
    [self.view bringSubviewToFront:self.moviePlayer.view];
    self.moviePlayer.fullscreen = YES;
    [self.moviePlayer setShouldAutoplay:YES];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer play];
}


- (void) moviePlayerWillExitFullScreen:(NSNotification*)notification
{
    NSLog(@"WILL EXIT FULLSCREEN");
    
}

- (void) moviePlayerDidExitFullScreen:(NSNotification*)notification
{
    NSLog(@"EXITED FULLSCREEN");  
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    
    NSLog(@"FINISHED PLAYIIING");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
  
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    self.moviePlayer= nil;
//    
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
