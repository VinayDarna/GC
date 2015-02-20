//
//  VideoplayerViewController.h
//  GatewayConference
//
//  Created by Teja Swaroop on 20/02/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface VideoplayerViewController : UIViewController

@property(nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong)GCModel *modelObj;

@end
