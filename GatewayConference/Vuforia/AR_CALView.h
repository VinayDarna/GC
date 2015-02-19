#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <QCAR/UIGLViewProtocol.h>

#import <GLKit/GLKit.h>

@class QCARutils;
@class PARARTarget;

@interface ARTarget : NSObject
{
@public
    NSString*   name;
    NSString*   video;
    
    NSInteger   arNdx;
}

+ (id)targetWithTarget:(PARARTarget*)target;
- (id)initFromTarget:(PARARTarget*)target;

- (id)setTarget:(PARARTarget*)target;

@end

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView
// subclass.  The view content is basically an EAGL surface you render your
// OpenGL scene into.  Note that setting the view non-opaque will only work if
// the EAGL surface has an alpha channel.
@interface AR_CALView : UIView <UIGLViewProtocol>

{
@public
    NSMutableArray *textureList; // list of textures to load
    
@protected
    EAGLContext *context_;
    GLuint framebuffer_;
    GLuint renderbuffer_;
    
    QCARutils *qUtils; // QCAR utils class
    NSMutableArray* textures;   // loaded textures
    
    CALayer *cameraLayer;
    
    NSInteger   currentTarget;
    
    NSMutableArray* arTargets;
    
    NSMutableArray* items;
    NSMutableArray* players;
    NSMutableArray* playerLayers;
    NSMutableArray* transforms;
    NSMutableArray* aivs;
    NSMutableArray* tvs;
    NSMutableArray* tvlbls;
    
    int     frameCount;
}

@property (nonatomic, retain) NSMutableArray *textureList;
@property (nonatomic, retain) id cameraImage;

//- (AVPlayer*)currentTargetPlayer;
//- (AVPlayerLayer*)currentTargetPlayerLayer;
//- (CATransform3D)currentTransform;

- (void)pauseAllVideos;

- (void) useTextures:(NSMutableArray *)theTextures;

- (void)finishOpenGLESCommands;
- (void)freeOpenGLESResources;

@end


