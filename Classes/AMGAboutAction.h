//
//  AMGAboutAction.h
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

@import Foundation;

@class AMGAboutViewController;

NS_ASSUME_NONNULL_BEGIN

@interface AMGSettingsDataRow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *imageName;
@property (nonatomic, copy) void (^action)(id);

- (instancetype)initWithTitle:(NSString *)title imageName:(nullable NSString *)imageName action:(void(^)(id))action;

@end


@interface AMGSettingsAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) void (^action)(AMGAboutViewController *);

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(AMGAboutViewController *))action;

@end


NS_ASSUME_NONNULL_END
