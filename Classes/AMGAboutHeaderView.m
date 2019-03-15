//
//  AMGAboutHeaderView.m
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

#import "AMGAboutHeaderView.h"

#import <NGAParallaxMotion.h>

@implementation AMGAboutHeaderView

- (instancetype)initWithIconImageNamed:(NSString *)iconImageName {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 200)];
    if (self) {
        UIImage *image = [UIImage imageNamed:iconImageName];

        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
        iconImageView.contentMode = UIViewContentModeCenter;
        iconImageView.center = self.center;
        iconImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.cornerRadius = 25;
        iconImageView.parallaxIntensity = 40;

        [self addSubview:iconImageView];
    }

    return self;
}

@end
