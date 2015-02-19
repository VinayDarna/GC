//
//  DNTransform3D.h
//  Parley
//
//  Created by Darren Ehlers on 6/12/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNTransform3D : NSObject
{
@public
    CGFloat m11, m12, m13, m14;
    CGFloat m21, m22, m23, m24;
    CGFloat m31, m32, m33, m34;
    CGFloat m41, m42, m43, m44;
}

+ (id)transform3DWithTransform3D:(CATransform3D)transform3D;
- (id)initFromTransform3D:(CATransform3D)transform3D;

- (id)setTransform3D:(CATransform3D)transform3D;
- (CATransform3D)transform3D;

@end
