#import "AR_CALView.h"
#import "Texture.h"
#import <QCAR/QCAR.h>

#import <QCAR/TrackableResult.h>
#import <QCAR/Marker.h>
#import <QCAR/MarkerResult.h>

#import <QCAR/Renderer.h>
#import <QCAR/Image.h>
#import "QCARutils.h"

#ifndef USE_OPENGL1
#import "ShaderUtils.h"
#define MAKESTRING(x) #x
#endif

#import "DNTransform3D.h"

#import "PARARTarget.h"
#import "Flurry.h"

#import "UIFont+Custom.h"

@implementation ARTarget

+ (id)targetWithTarget:(PARARTarget*)target
{
    return [[ARTarget alloc] initFromTarget:target];
}

- (id)initFromTarget:(PARARTarget*)target
{
    self = [super init];
    if (self)
    {
        [self setTarget:target];
    }
    
    return self;
}

- (id)setTarget:(PARARTarget*)target
{
    name    = target.name;
    video   = target.video;
    
    arNdx   = target.arNdx;
    
    return self;
}

@end

@interface AR_CALView ()
{
    dispatch_queue_t    renderQueue;
    
    int cameraImageCount;
    int renderFrameCount;
}

@end

@implementation AR_CALView

@synthesize textureList;
@synthesize cameraImage;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (UIActivityIndicatorView*)aiv:(NSInteger)ndx
{
    if ((ndx < 0) || (ndx >= [aivs count]))
    {
        return nil;
    }
    
    UIActivityIndicatorView*    retval = [aivs objectAtIndex:ndx];
    return retval;
}

- (UIView*)tv:(NSInteger)ndx
{
    if ((ndx < 0) || (ndx >= [tvs count]))
    {
        return nil;
    }
    
    UIView* retval = [tvs objectAtIndex:ndx];
    return retval;
}

- (UILabel*)tvlbl:(NSInteger)ndx
{
    if ((ndx < 0) || (ndx >= [tvlbls count]))
    {
        return nil;
    }
    
    UILabel* retval = [tvlbls objectAtIndex:ndx];
    return retval;
}

- (AVPlayer*)targetPlayer:(NSInteger)ndx
{
    if ((ndx < 0) || (ndx >= [players count]))
    {
        return nil;
    }
    
    AVPlayer*   retval = [players objectAtIndex:ndx];
    return retval;
}

- (AVPlayerLayer*)targetPlayerLayer:(NSInteger)ndx
{
    if ((ndx < 0) || (ndx >= [playerLayers count]))
    {
        return nil;
    }
    
    AVPlayerLayer*  retval = [playerLayers objectAtIndex:ndx];
    return retval;
}

- (void)setTargetTransform:(NSInteger)ndx value:(CATransform3D)value
{
    [transforms setObject:[DNTransform3D transform3DWithTransform3D:value] atIndexedSubscript:ndx];
}

- (CATransform3D)targetTransform:(NSInteger)ndx
{
    if ((ndx < 0) && (ndx <= [transforms count]))
    {
        return CATransform3DIdentity;
    }
    
    CATransform3D   retval = [[transforms objectAtIndex:ndx] transform3D];
    return retval;
}

- (CATransform3D) GLtoCATransform3D:(QCAR::Matrix44F)m
{
    CATransform3D t = CATransform3DIdentity;
    t.m11 = m.data[0];
    t.m12 = m.data[1];
    t.m13 = m.data[2];
    t.m14 = m.data[3];
    t.m21 = m.data[4];
    t.m22 = m.data[5];
    t.m23 = m.data[6];
    t.m24 = m.data[7];
    t.m31 = m.data[8];
    t.m32 = m.data[9];
    t.m33 = m.data[10];
    t.m34 = m.data[11];
    t.m41 = m.data[12];
    t.m42 = m.data[13];
    t.m43 = m.data[14];
    t.m44 = m.data[15];
    
    return t;
}

void freeData(void *info, const void *data, size_t size)
{
    //free((void *)data);
}

- (CGImageRef)createCGImage:(const QCAR::Image *)qcarImage
{
    int width               = qcarImage->getWidth();
    int height              = qcarImage->getHeight();
    int bitsPerComponent    = 8;
    int bitsPerPixel        = QCAR::getBitsPerPixel(QCAR::RGB888);
    int bytesPerRow         = qcarImage->getBufferWidth() * bitsPerPixel / bitsPerComponent;
    
    CGColorSpaceRef         colorSpaceRef   = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo            bitmapInfo      = kCGBitmapByteOrderDefault | kCGImageAlphaNone;
    CGColorRenderingIntent  renderingIntent = kCGRenderingIntentDefault;
    
    CGDataProviderRef   provider    = CGDataProviderCreateWithData(NULL, qcarImage->getPixels(), QCAR::getBufferSize(width, height, QCAR::RGB888), freeData);
    CGImageRef          imageRef    = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    
    return (CGImageRef)[(id)imageRef autorelease];
}

- (void)createFrameBuffer
{
    // This is called on main thread
    
    if (context_ && !framebuffer_)
        [EAGLContext setCurrentContext:context_];
    
    glGenFramebuffers(1, &framebuffer_);
    glGenRenderbuffers(1, &renderbuffer_);
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer_);
    
    [context_ renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer_);
    
}

- (void)playVideo:(NSInteger)ndx
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self showAIV:ndx];
                       [[self targetPlayer:ndx] play];
                       
                       AVPlayer*    player = [self targetPlayer:ndx];
                       NSLog(@"player.rate=%.4f", player.rate);
                       
                       AVPlayerStatus   status  = player.status;
                       switch (status)
                       {
                           case AVPlayerStatusFailed:       {   NSLog(@"player.status=%@", @"AVPlayerStatusFailed");        break;  }
                           case AVPlayerStatusReadyToPlay:  {   NSLog(@"player.status=%@", @"AVPlayerStatusReadyToPlay");   break;  }
                           case AVPlayerStatusUnknown:      {   NSLog(@"player.status=%@", @"AVPlayerStatusUnknown");       break;  }
                               
                           default:   {   NSLog(@"player.status=Unknown [%d]", status);    break;  }
                       }
                   });
}

- (void)pauseAllVideos
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [players enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                        {
                            AVPlayer*  player  = obj;
                            [player pause];
                        }];
                   });
}

- (void)pauseVideo:(NSInteger)ndx
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [[self targetPlayer:ndx] pause];
                   });
}

- (void)render
{
    // Render video background and retrieve tracking state
    QCAR::setFrameFormat(QCAR::RGB888, true);
    
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    //QCAR::Renderer::getInstance().drawVideoBackground();
    
    QCAR::Frame ff = state.getFrame();
    if (ff.getNumImages() <= 0)
    {
        QCAR::Renderer::getInstance().end();
        return;
    }

    for (int i = 0; i < ff.getNumImages(); i++)
    {
        const QCAR::Image *qcarImage = ff.getImage(i);
        if (qcarImage->getFormat() == QCAR::RGB888)
        {
            id  newCameraImage  = (id)[self createCGImage:qcarImage];
            
            self.cameraImage    = newCameraImage;
            break;
        }
    }
    
    int numTrackables   = state.getNumTrackableResults();
    //NSLog(@"numTrackables=%d", numTrackables);
    
    NSMutableArray* currentTrackables   = [NSMutableArray arrayWithCapacity:numTrackables];
    
    NSString*   trackablesString = @"";
    
    for (int i = 0; i < numTrackables; i++)
    {
        // Get the trackable
        const QCAR::TrackableResult*    result      = state.getTrackableResult(i);
        const QCAR::Trackable&          trackable   = result->getTrackable();
        
        NSString*   trackableName   = [NSString stringWithFormat:@"%s", trackable.getName()];
        NSLog(@"*** trackableName=%@", trackableName);
        
        [arTargets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             ARTarget*  arTarget    = obj;
             
             if ([arTarget->name isEqualToString:trackableName] == YES)
             {
                 NSLog(@"*** MATCH *** trackableName=%@", trackableName);
                 if ([currentTrackables containsObject:arTarget] == NO)
                 {
                     arTarget->arNdx = i;
                     [currentTrackables addObject:arTarget];
                     //trackablesString = [trackablesString stringByAppendingString:trackableName];
                 }
             }
         }];
    }
    
    NSMutableArray* notTrackables   = [NSMutableArray arrayWithArray:arTargets];
    [notTrackables removeObjectsInArray:currentTrackables];
    
    if ([trackablesString length] == 0)
    {
        //NSLog(@"targets NONE");
    }
    else
    {
        //NSLog(@"targets[%d:%d:%d] %@", [currentTrackables count], [notTrackables count], [arTargets count], trackablesString);
    }
    
    [arTargets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         ARTarget*  arTarget    = obj;
         
         if ([notTrackables containsObject:obj])
         {
             //NSLog(@"NOT target: %@", target.name);
             if ([self targetPlayer:idx].rate > 0)
             {
                 NSLog(@"Pausing [%d] target %@ : video=%@", idx, arTarget->name, arTarget->video);
                 [Flurry endTimedEvent:@"Stopping RealEyes Video" withParameters:nil];
                 
                 [self pauseVideo:idx];
             }
         }
         else if ([currentTrackables containsObject:obj])
         {
             //NSLog(@"YES target: %@", arTarget->name);
             if ([self targetPlayer:idx].rate == 0)
             {
                 NSDictionary*   videoParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                                arTarget->name, @"Video Target",
                                                nil];
                 
                 [Flurry logEvent:@"Starting RealEyes Video" withParameters:videoParams timed:YES];
                 
                 NSLog(@"[%d] starting video: %@", idx, arTarget->name);
                 [self playVideo:idx];
             }
             
             const QCAR::TrackableResult*    result      = state.getTrackableResult(arTarget->arNdx);
             if (!result)
             {
                 NSLog(@"Trackable Result is GONE!");
             }
             if (result)
             {
                 QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(result->getPose());
                 
                 CGFloat ScreenScale = [[UIScreen mainScreen] scale];
                 float xscl = qUtils.viewport.sizeX/ScreenScale/2;
                 float yscl = qUtils.viewport.sizeY/ScreenScale/2;
                 
                 QCAR::Matrix44F scalingMatrix = {xscl,0,0,0,
                     0,yscl,0,0,
                     0,0,1,0,
                     0,0,0,1};
                 
                 QCAR::Matrix44F flipY = { 1, 0,0,0,
                     0,-1,0,0,
                     0, 0,1,0,
                     0, 0,0,1};
                 
                 ShaderUtils::translatePoseMatrix(0.0f, 0.0f, 3, &modelViewMatrix.data[0]);
                 ShaderUtils::multiplyMatrix(&modelViewMatrix.data[0], &flipY.data[0], &modelViewMatrix.data[0]);
                 ShaderUtils::multiplyMatrix(&qUtils.projectionMatrix.data[0],&modelViewMatrix.data[0], &modelViewMatrix.data[0]);
                 ShaderUtils::multiplyMatrix(&scalingMatrix.data[0], &modelViewMatrix.data[0], &modelViewMatrix.data[0]);
                 ShaderUtils::multiplyMatrix(&flipY.data[0], &modelViewMatrix.data[0], &modelViewMatrix.data[0]);
                 
                 [self setTargetTransform:idx value:[self GLtoCATransform3D:modelViewMatrix]];
             }
         }
     }];

    QCAR::Renderer::getInstance().end();
}

- (void)itemDidFinishPlaying:(NSNotification*)notification
{
    NSLog(@"notification=%@", notification);
    NSLog(@"name=%@", [notification name]);
    
    AVPlayerItem*   item = notification.object;
    
    NSLog(@"item.tracks=%@", item.tracks);
    
    AVPlayer*   player  = [players objectAtIndex:[items indexOfObject:item]];

    [player pause];
    [player seekToTime:kCMTimeZero];
}

- (void)itemNewAccessLogEntry:(NSNotification*)notification
{
    NSLog(@"ACCESSLOG: notification=%@", notification);
    NSLog(@"ACCESSLOG: name=%@", [notification name]);
    
    //AVPlayerItemAccessLog*  accessLog   = notification.object;
    //NSLog(@"accessLog=%@", accessLog);

    AVPlayerItem*   currentPlayerItem   = notification.object;
    NSLog(@"ACCESSLOG: currentPlayerItem=%@", currentPlayerItem);
    NSLog(@"ACCESSLOG: tracks=%@", currentPlayerItem.tracks);

    return;
}

- (void)itemNewErrorLogEntry:(NSNotification*)notification
{
    NSLog(@"ERRORLOG: notification=%@", notification);
    NSLog(@"ERRORLOG: name=%@", [notification name]);
    
    AVPlayerItemErrorLog*  errorLog   = notification.object;
    NSLog(@"ERRORLOG: errorLog=%@", errorLog);
    
    return;
}

- (void)initVideoTarget:(PARARTarget*)target
                withNdx:(NSUInteger)idx
{
    NSLog(@"initVideoTarget - 1");
    
    CGSize  size        = self.bounds.size;
    
    ARTarget*      arTarget    = [ARTarget targetWithTarget:target];
    
    [arTargets addObject:arTarget];
    
    NSLog(@"initVideoTarget - 2");

    CGFloat scaling    = [target.video_scale doubleValue];
    CGSize  videoSize  = CGSizeMake(([target.video_width doubleValue] * scaling), ([target.video_height doubleValue] * scaling));
    
    // Centers Video Player
    float   x           = (size.width / 2.0) - (videoSize.width / 2.0);
    float   y           = (size.height / 2.0) - (videoSize.height / 2.0);
    
    /*
    UILabel*   tvlbl   = [[UILabel alloc] init];
    tvlbl.frame            = CGRectMake(x + 50, y + 50, videoSize.width - 100, videoSize.height - 100);
    tvlbl.numberOfLines    = 0;
    tvlbl.backgroundColor  = [UIColor clearColor];
    tvlbl.textColor        = [UIColor whiteColor];
    tvlbl.font             = [UIFont boldSystemFontOfSize:60.0f];
    tvlbl.textAlignment    = NSTextAlignmentCenter;
    tvlbl.text             = @"The audio-only stream is currently playing, due to limited available bandwidth...";
    tvlbl.alpha            = 0.0f;
    [cameraLayer addSublayer:tvlbl.layer];
     */
    
    NSLog(@"initVideoTarget - 3");

    NSURL* url = [NSURL URLWithString:target.video];
    
    NSLog(@"initializing video player=[%d] %@ (%.2f, %.2f, %.2f) : %@", idx, arTarget->name, [target.video_width doubleValue], [target.video_height doubleValue], [target.video_scale doubleValue], arTarget->video);
    AVURLAsset*    avasset     = [[[AVURLAsset alloc] initWithURL:url options:nil] retain];
    AVPlayerItem*  playerItem  = [[[AVPlayerItem alloc] initWithAsset:avasset] retain];
    
    AVPlayer*      player      = [[AVPlayer playerWithPlayerItem:playerItem] retain];
    AVPlayerLayer* playerLayer = [[AVPlayerLayer playerLayerWithPlayer:player] retain];
    DNTransform3D* transform   = [DNTransform3D transform3DWithTransform3D:CATransform3DIdentity];
    
    playerLayer.frame              = CGRectMake(x, y, videoSize.width, videoSize.height);
    playerLayer.backgroundColor    = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f].CGColor;
    playerLayer.zPosition          = 1;
    playerLayer.hidden             = YES;
    [cameraLayer addSublayer:playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)   name:AVPlayerItemDidPlayToEndTimeNotification     object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemNewAccessLogEntry:)  name:AVPlayerItemNewAccessLogEntryNotification    object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemNewErrorLogEntry:)   name:AVPlayerItemNewErrorLogEntryNotification     object:playerItem];
    
    UIView*    tv      = [[UIView alloc] init];
    tv.backgroundColor = [UIColor blackColor];
    tv.frame           = CGRectMake(0, 0, videoSize.width, videoSize.height);
    tv.alpha           = 0.8f;
    NSLog(@"tv.frame=(%.2f, %.2f)-(%.2f, %.2f)", tv.frame.origin.x, tv.frame.origin.y, tv.frame.size.width, tv.frame.size.height);
    [self addSubview:tv];
    [playerLayer addSublayer:tv.layer];
    //tv.layer.transform = CATransform3DMakeScale(15, 15, 1);
    
    UIActivityIndicatorView*   aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [aiv startAnimating];
    aiv.frame  = CGRectMake(0, 0, videoSize.width, videoSize.height);
    NSLog(@"aiv.frame=(%.2f, %.2f)-(%.2f, %.2f)", aiv.frame.origin.x, aiv.frame.origin.y, aiv.frame.size.width, aiv.frame.size.height);
    [self addSubview:aiv];
    [playerLayer addSublayer:aiv.layer];
    aiv.layer.transform = CATransform3DMakeScale(12, 12, 1);
    
    NSLog(@"initVideoTarget - 4");

    [DNUtilities runAfterDelay:0.3f
                         block:^
     {
         NSLog(@"initVideoTarget - 4a");
         
         CMTime     oneSecond       = CMTimeMakeWithSeconds(1, 1);
         
         __block NSInteger  lastTime    = 0;
         
         id playerObserver = [player addPeriodicTimeObserverForInterval:oneSecond queue:NULL usingBlock:^(CMTime time)
                              {
                                  AVPlayerItem* currentPlayerItem   = [items objectAtIndex:idx];
                                  
                                  // Passing NULL for the queue specifies the main queue.
                                  NSString*     timeDescription = (NSString*)CMTimeCopyDescription(NULL, time);
                                  NSInteger     diff            = time.value - lastTime;
                                  NSLog(@"PERIODIC: time at %@ (%d) diff=%d", timeDescription, lastTime, diff);
                                  NSLog(@"PERIODIC: tracks=%@", currentPlayerItem.tracks);
                                  if ([currentPlayerItem.tracks count] == 1)
                                  {
                                      [self showAudioOnly:idx];
                                      
                                      AVAssetTrack* track = currentPlayerItem.tracks[0];
                                      if (track.trackID == 8)
                                      {
                                          NSLog(@"*** AUDIO ONLY *** [ID:8]");
                                          //[self showAudioOnly:idx];
                                      }
                                      else
                                      {
                                          NSLog(@"*** AUDIO ONLY *** trackID = %d", track.trackID);
                                          //[self hideAudioOnly:idx];
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"*** AUDIO + VIDEO *** %d tracks", [currentPlayerItem.tracks count]);
                                      [self hideAudioOnly:idx];
                                  }
                                  [timeDescription release];
                                  
                                  for (AVPlayerItemAccessLogEvent *event  in [[currentPlayerItem accessLog] events])
                                  {
                                      NSLog(@"PERIODIC: item indicated bitrate is %f", [event indicatedBitrate]);
                                      NSLog(@"PERIODIC: item observerd bitrate is %f", [event observedBitrate]);
                                  }
                                  
                                  if ((diff > 1200000000) || (diff == 0))
                                  {
                                      [self showAIV:idx];
                                  }
                                  else
                                  {
                                      [self hideAIV:idx];
                                  }
                                  
                                  lastTime  = time.value;
                              }];
         
         NSLog(@"initVideoTarget - 4b");
         
         Float64    durationSeconds = CMTimeGetSeconds([avasset duration]);
         CMTime     starting        = CMTimeMakeWithSeconds(1, 1000000000);
         //CMTime     firstThird      = CMTimeMakeWithSeconds(durationSeconds / 3.0, 1);
         //CMTime     secondThird     = CMTimeMakeWithSeconds(durationSeconds * 2.0 / 3.0, 1);
         NSArray*   times           = [NSArray arrayWithObjects:[NSValue valueWithCMTime:starting], nil];
         
         id playerObserver2 = [player addBoundaryTimeObserverForTimes:times queue:NULL usingBlock:^
                               {
                                   AVPlayerItem* currentPlayerItem   = [items objectAtIndex:idx];
                                   
                                   // Passing NULL for the queue specifies the main queue.
                                   NSString*  timeDescription = (NSString*)CMTimeCopyDescription(NULL, [player currentTime]);
                                   NSLog(@"BOUNDARY: Passed a boundary at %@", timeDescription);
                                   NSLog(@"BOUNDARY: tracks=%@", currentPlayerItem.tracks);
                                   [timeDescription release];
                                   
                                   [self hideAIV:idx];
                               }];
         
         NSLog(@"initVideoTarget - 4c");
     }];
    
    
    NSLog(@"initVideoTarget - 5");
    
    NSString*  tracksKey = @"tracks";
    
    [avasset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:tracksKey]
                           completionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            NSError* error = nil;
                            
                            AVKeyValueStatus status = [avasset statusOfValueForKey:tracksKey
                                                                             error:&error];
                            if (status == AVKeyValueStatusLoaded)
                            {
                            }
                            else
                            {
                                // You should deal with the error appropriately.
                                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                            }
                        });
     }];
    
    NSLog(@"initVideoTarget - 6");
    
    [items addObject:playerItem];
    [players addObject:player];
    [playerLayers addObject:playerLayer];
    [transforms addObject:transform];
    [aivs addObject:aiv];
    [tvs addObject:tv];
    //[tvlbls addObject:tvlbl];
    
    NSLog(@"initVideoTarget - 7");
}

- (void)initVideo
{
    arTargets       = [[NSMutableArray arrayWithCapacity:10] retain];

    items           = [[NSMutableArray arrayWithCapacity:10] retain];
    players         = [[NSMutableArray arrayWithCapacity:10] retain];
    playerLayers    = [[NSMutableArray arrayWithCapacity:10] retain];
    transforms      = [[NSMutableArray arrayWithCapacity:10] retain];
    aivs            = [[NSMutableArray arrayWithCapacity:10] retain];
    tvs             = [[NSMutableArray arrayWithCapacity:10] retain];
    tvlbls          = [[NSMutableArray arrayWithCapacity:10] retain];
    
    [[PARARTarget getAll] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         PARARTarget*   target      = obj;
         
         [self initVideoTarget:target withNdx:idx];
     }];
}

- (void)showAudioOnly:(NSInteger)ndx
{
    [self tvlbl:ndx].hidden  = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         //[self tvlbl:ndx].alpha = 1.0f;
         [self tv:ndx].alpha    = 0.5f;
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void)hideAudioOnly:(NSInteger)ndx
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         //[self tvlbl:ndx].alpha = 0.0f;
         [self tv:ndx].alpha    = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         //[self tvlbl:ndx].hidden    = YES;
         [self tv:ndx].hidden       = YES;
     }];
}

- (void)showAIV:(NSInteger)ndx
{
    [self aiv:ndx].hidden = NO;
    [self tv:ndx].hidden  = NO;

    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         [self aiv:ndx].alpha   = 1.0f;
         [self tv:ndx].alpha    = 0.5f;
         
         //[self tvlbl:ndx].alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         [self tvlbl:ndx].hidden  = YES;
     }];
}

- (void)hideAIV:(NSInteger)ndx
{
    [self tvlbl:ndx].hidden  = NO;

    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         [self aiv:ndx].alpha   = 0.0f;
         [self tv:ndx].alpha    = 0.0f;
         
         //[self tvlbl:ndx].alpha = 1.0f;
     }
                     completion:^(BOOL finished)
     {
         [self aiv:ndx].hidden = YES;
         [self tv:ndx].hidden  = YES;
     }];
}

// test to see if the screen has hi-res mode
- (BOOL) isRetinaEnabled
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
            &&
            ([UIScreen mainScreen].scale == 2.0));
}

// use to allow this view to access loaded textures
- (void) useTextures:(NSMutableArray *)theTextures
{
    textures = theTextures;
}

#pragma mark ---- view lifecycle ---
/////////////////////////////////////////////////////////////////
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self)
    {
        renderQueue = dispatch_queue_create("parleyRealEyesRenderQueue", NULL);
        
        qUtils      = [QCARutils getInstance];
        textureList = [[NSMutableArray alloc] initWithCapacity:2];
        
        // switch on hi-res mode if available
        if ([self isRetinaEnabled])
        {
            self.contentScaleFactor     = 2.0f;
            qUtils.contentScalingFactor = self.contentScaleFactor;
        }
        
        qUtils.QCARFlags = QCAR::GL_20;
        
        CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
        layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                    nil];
        
        context_    = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        frameCount = 0;
        
        cameraLayer = [[CALayer layer] retain];
        cameraLayer.contentsGravity = kCAGravityResizeAspectFill;
        cameraLayer.frame           = self.layer.bounds;
        [self.layer addSublayer:cameraLayer];
        
        [self initVideo];
        NSLog(@"QCAR OpenGL flag: %d", qUtils.QCARFlags);
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [items release];        items           = nil;
    [players release];      players         = nil;
    [playerLayers release]; playerLayers    = nil;
    [transforms release];   transforms      = nil;
    
    if (framebuffer_)
    {
        glDeleteFramebuffers(1, &framebuffer_);
        glDeleteFramebuffers(1, &renderbuffer_);
    }
    
    if ([EAGLContext currentContext] == context_)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context_ release];     context_    = nil;
    [textureList release];  textureList = nil;
    [cameraImage release];  cameraImage = nil;

    [aivs release];     aivs    = nil;
    [tvs release];      tvs     = nil;
    [tvlbls release];   tvlbls  = nil;
    
    [super dealloc];
}

- (void) postInitQCAR
{
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    // *** DEPRECATED QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    // *** DEPRECATED QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 40);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets
    BOOL    result = QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 1);
    NSLog(@"setHint() = %@", (result ? @"YES" : @"NO"));
}

////////////////////////////////////////////////////////////////////////////////
// Draw the current frame using OpenGL
//
// This code is a TEMPLATE for the subclassing EAGLView to complete
//
// The subclass override of this method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call the subclassed method on a single background thread ***
- (void)renderFrameQCAR
{
    if (!framebuffer_)
    {
        [self performSelectorOnMainThread:@selector(createFrameBuffer) withObject:nil waitUntilDone:YES];
    }
    
    [EAGLContext setCurrentContext:context_];
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer_);
    
    if (frameCount < 20)
    {
        frameCount++;
        return;
    }

    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self render];
                       
                       [CATransaction begin];
                       [CATransaction setValue:(id)kCFBooleanTrue
                                        forKey:kCATransactionDisableActions];
                       
                       cameraLayer.contents   = self.cameraImage;
                       
                       [playerLayers enumerateObjectsUsingBlock:^(AVPlayerLayer* layer, NSUInteger idx, BOOL *stop)
                        {
                            if ([self targetPlayer:idx].rate == 0)
                            {
                                layer.hidden        = YES;
                            }
                            else
                            {
                                layer.transform     = [self targetTransform:idx];
                                layer.hidden        = NO;
                            }
                        }];

                       /*
                       [tvlbls enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop)
                        {
                            if ([self targetPlayer:idx].rate == 0)
                            {
                                label.hidden        = YES;
                            }
                            else
                            {
                                label.layer.transform   = [self targetTransform:idx];
                                label.hidden            = NO;
                            }
                        }];
                       */
                       
                       [CATransaction commit];
                   });
}

- (void)finishOpenGLESCommands
{
}

- (void)freeOpenGLESResources
{
    //[arView freeOpenGLESResources];
}

@end
