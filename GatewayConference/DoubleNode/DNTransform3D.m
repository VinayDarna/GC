//
//  DNTransform3D.m
//  Parley
//
//  Created by Darren Ehlers on 6/12/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "DNTransform3D.h"

@implementation DNTransform3D

+ (id)transform3DWithTransform3D:(CATransform3D)transform3D
{
    return [[DNTransform3D alloc] initFromTransform3D:transform3D];
}

- (id)initFromTransform3D:(CATransform3D)transform3D
{
    self = [super init];
    if (self)
    {
        [self setTransform3D:transform3D];
    }
    
    return self;
}

- (id)setTransform3D:(CATransform3D)transform3D
{
    m11 = transform3D.m11;  m12 = transform3D.m12;  m13 = transform3D.m13;  m14 = transform3D.m14;
    m21 = transform3D.m21;  m22 = transform3D.m22;  m23 = transform3D.m23;  m24 = transform3D.m24;
    m31 = transform3D.m31;  m32 = transform3D.m32;  m33 = transform3D.m33;  m34 = transform3D.m34;
    m41 = transform3D.m41;  m42 = transform3D.m42;  m43 = transform3D.m43;  m44 = transform3D.m44;
    
    return self;
}

- (CATransform3D)transform3D
{
    CATransform3D   retval;
    
    retval.m11  = m11;  retval.m12  = m12;  retval.m13  = m13;  retval.m14  = m14;
    retval.m21  = m21;  retval.m22  = m22;  retval.m23  = m23;  retval.m24  = m24;
    retval.m31  = m31;  retval.m32  = m32;  retval.m33  = m33;  retval.m34  = m34;
    retval.m41  = m41;  retval.m42  = m42;  retval.m43  = m43;  retval.m44  = m44;
    
    return retval;
}

@end
