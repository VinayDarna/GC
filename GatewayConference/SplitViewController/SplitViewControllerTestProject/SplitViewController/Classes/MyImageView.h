//
//  MyImageView.h
//  steuerapp
//
//  Created by Bernhard Häussermann on 2011/04/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyImageView : UIImageView 
{
    id delegate;
    SEL selector;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL selector;

@end
