//
//  AMGAboutFooterView.m
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

#import "AMGAboutFooterView.h"
#import "AMGAboutAction.h"
#import "AMGAboutViewController.h"

#import <AMGAppButton/AMGApp.h>
#import <AMGAppButton/AMGAppButton.h>
#import <VTAppButton.h>
#import <VTAcknowledgementsViewController.h>

const CGFloat AppsHeaderHeight = 170;
const CGFloat IconWidth = 70;
const CGFloat ActionHeight = 20;
const CGFloat ActionMargin = 10;

@interface AMGAboutFooterView ()

@property (nonatomic, strong, nullable) UIScrollView *appsScrollView;
@property (nonatomic, strong, nullable) UIView *appsView;

@end


@implementation AMGAboutFooterView

- (instancetype)initForViewController:(AMGAboutViewController *)viewController withApps:(NSArray <AMGApp *> *)apps actions:(NSArray <AMGSettingsAction *> *)actions {
    self = [super initWithFrame:CGRectMake(0, 0, 320, AppsHeaderHeight + 120 + (ActionHeight + ActionMargin) * actions.count)];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        UILabel *footerLabel = [self discoverAllMyAppsLabel];
        [self addSubview:footerLabel];

        const CGFloat AppsSideMargin = 12;
        const CGFloat AppsMargin = 8;
        UIScrollView *appsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.frame), IconWidth)];
        appsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        appsScrollView.clipsToBounds = NO;
        appsScrollView.showsHorizontalScrollIndicator = NO;
        appsScrollView.alwaysBounceHorizontal = NO;

        UIView *appsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (apps.count * (IconWidth + AppsMargin)) - AppsMargin + (AppsSideMargin * 2), IconWidth)];
        appsView.backgroundColor = [UIColor clearColor];
        appsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        [apps enumerateObjectsUsingBlock:^(AMGApp * _Nonnull app, NSUInteger index, BOOL * _Nonnull stop) {
            AMGAppButton *button = [AMGAppButton buttonWithApp:app];
            [button addTarget:viewController action:@selector(showApplication:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(AppsSideMargin + index * (IconWidth + AppsMargin), 0, IconWidth, IconWidth);
            [appsView addSubview:button];
        }];

        appsView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, IconWidth / 2);
        [appsScrollView addSubview:appsView];
        appsScrollView.contentSize = appsView.frame.size;

        [self addSubview:appsScrollView];
        self.appsScrollView = appsScrollView;
        self.appsView = appsView;

        UILabel *creditsLabel = [self creditsLabelForViewController:viewController];
        [self addSubview:creditsLabel];

        [actions enumerateObjectsUsingBlock:^(AMGSettingsAction * _Nonnull action, NSUInteger index, BOOL * _Nonnull stop) {
            UIButton *button = [self buttonForAction:action index:index target:viewController];
            [self addSubview:button];
        }];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectGetWidth(self.appsScrollView.frame) > CGRectGetWidth(self.appsView.frame)) {
        self.appsView.center = CGPointMake(CGRectGetWidth(self.appsScrollView.frame) / 2, CGRectGetHeight(self.appsScrollView.frame) / 2);
    }
    else {
        self.appsView.frame = CGRectMake(0, 0, CGRectGetWidth(self.appsView.frame), CGRectGetHeight(self.appsView.frame));
    }
}

- (UILabel *)discoverAllMyAppsLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), 20)];
    label.text = NSLocalizedString(@"Discover All My Apps", nil).uppercaseString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self primaryTextColor];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    // Need Auto Layout
    // label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return label;
}

- (UILabel *)creditsLabelForViewController:(AMGAboutViewController *)viewController {
    NSDictionary *bundleInfo = NSBundle.mainBundle.infoDictionary;
    NSString *bundleDisplayName = bundleInfo[@"CFBundleDisplayName"];
    NSString *bundleShortVersion = bundleInfo[@"CFBundleShortVersionString"];

    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AppsHeaderHeight + 20, 320, 40)];
    creditsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    creditsLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    // Need Auto Layout
    // creditsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    creditsLabel.textColor = [self primaryTextColor];
    creditsLabel.numberOfLines = 2;
    creditsLabel.text = [NSString stringWithFormat:@"%@ v%@\n%@", viewController.localizedAppName ?: bundleDisplayName, bundleShortVersion, NSLocalizedString(@"Made by Studio AMANgA", nil)];
    return creditsLabel;
}

- (UIButton *)buttonForAction:(AMGSettingsAction *)action index:(NSUInteger)index target:(id)target {
    NSDictionary *normalAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [self primaryTextColor]};
    NSDictionary *highlightedAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [self secondaryTextColor]};

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    // Need Auto Layout
    // button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:normalAttributes] forState:UIControlStateNormal];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:highlightedAttributes] forState:UIControlStateHighlighted];
    button.tag = index;
    [button addTarget:target action:@selector(performFooterAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, AppsHeaderHeight + 70 + index * (ActionHeight + ActionMargin), 320, ActionHeight);
    return button;
}

#pragma mark - Colors

- (UIColor *)primaryTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor secondaryLabelColor];
    }
    else {
        return [UIColor colorWithWhite:0.7 alpha:1];
    }
}

- (UIColor *)secondaryTextColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor tertiaryLabelColor];
    }
    else {
        return [UIColor colorWithWhite:0.4 alpha:1];
    }
}

@end
