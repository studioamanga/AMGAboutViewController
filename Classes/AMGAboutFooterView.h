//
//  AMGAboutFooterView.h
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2020 Studio AMANgA. All rights reserved.
//

@import UIKit;

@class AMGAboutViewController;
@class AMGApp;
@class AMGSettingsAction;

NS_ASSUME_NONNULL_BEGIN

@interface AMGAboutFooterView : UIView

- (instancetype)initForViewController:(AMGAboutViewController *)viewController withApps:(NSArray <AMGApp *> *)apps actions:(NSArray <AMGSettingsAction *> *)actions;

+ (UILabel *)creditsLabelForViewController:(AMGAboutViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
