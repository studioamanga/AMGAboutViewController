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

@implementation AMGAboutFooterView

- (instancetype)initForViewController:(AMGAboutViewController *)viewController withApps:(NSArray <AMGApp *> *)apps actions:(NSArray <AMGSettingsAction *> *)actions {
    self = [super initWithFrame:CGRectMake(0, 0, 320, AppsHeaderHeight + 120 + (ActionHeight + ActionMargin) * actions.count)];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.frame), 20)];
        footerLabel.text = NSLocalizedString(@"Discover All My Apps", nil).uppercaseString;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.textColor = [UIColor darkGrayColor];
        footerLabel.font = [UIFont systemFontOfSize:13];
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:footerLabel];

        CGFloat leftMargin = 10;
        UIView *appsView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.frame), IconWidth)];
        appsView.backgroundColor = [UIColor clearColor];
        appsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        [apps enumerateObjectsUsingBlock:^(AMGApp * _Nonnull app, NSUInteger index, BOOL * _Nonnull stop) {
            AMGAppButton *button = [AMGAppButton buttonWithApp:app];
            [button addTarget:viewController action:@selector(showApplication:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(leftMargin + index * (IconWidth + 6), 0, IconWidth, IconWidth);
            [appsView addSubview:button];
        }];

        [self addSubview:appsView];

        NSDictionary *bundleInfo = NSBundle.mainBundle.infoDictionary;
        NSString *bundleDisplayName = bundleInfo[@"CFBundleDisplayName"];
        NSString *bundleShortVersion = bundleInfo[@"CFBundleShortVersionString"];

        UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AppsHeaderHeight + 20, 320, 40)];
        creditsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        creditsLabel.textAlignment = NSTextAlignmentCenter;
        creditsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        creditsLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        creditsLabel.numberOfLines = 2;
        creditsLabel.text = [NSString stringWithFormat:@"%@ v%@\n%@", viewController.localizedAppName ?: bundleDisplayName, bundleShortVersion, NSLocalizedString(@"Made by Studio AMANgA", nil)];
        [self addSubview:creditsLabel];

        NSDictionary *normalAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [UIColor colorWithWhite:0.7 alpha:1]};
        NSDictionary *highlightedAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [UIColor colorWithWhite:0.4 alpha:1]};

        [actions enumerateObjectsUsingBlock:^(AMGSettingsAction * _Nonnull action, NSUInteger index, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

            [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:normalAttributes] forState:UIControlStateNormal];
            [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:highlightedAttributes] forState:UIControlStateHighlighted];
            button.tag = index;
            [button addTarget:viewController action:@selector(performFooterAction:) forControlEvents:UIControlEventTouchUpInside];

            button.frame = CGRectMake(0, AppsHeaderHeight + 70 + index * (ActionHeight + ActionMargin), 320, ActionHeight);
            [self addSubview:button];
        }];
    }

    return self;
}

@end
