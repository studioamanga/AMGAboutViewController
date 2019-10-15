//
//  AMGAboutAction.m
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

#import "AMGAboutAction.h"

@implementation AMGSettingsDataRow

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName systemImageName:(nullable NSString *)systemImageName action:(void(^)(id))action {
    self = [super init];
    self.title = title;
    self.imageName = imageName;
    self.systemImageName = systemImageName;
    self.action = action;
    return self;
}

@end


@implementation AMGSettingsAction

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(AMGAboutViewController *))action {
    self = [super init];
    self.title = title;
    self.action = action;
    return self;
}

@end
