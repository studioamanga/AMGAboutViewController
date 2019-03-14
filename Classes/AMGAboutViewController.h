//
//  AMGAboutViewController.h
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

@import UIKit;
@import MessageUI;
@import StoreKit;

@class AMGApp;
@class AMGSettingsDataSection;
@class AMGSettingsAction;

NS_ASSUME_NONNULL_BEGIN

@interface AMGAboutViewController : UITableViewController <MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, copy, nullable) NSNumber *appIdentifier;
@property (nonatomic, copy, nullable) NSString *localizedAppName;
@property (nonatomic, copy, nullable) NSString *largeIconName;
@property (nonatomic, copy, nullable) NSString *acknowledgementsFileName;
@property (nonatomic, copy, nullable) NSURL *shareAppURL;
@property (nonatomic, strong, nullable) NSArray <AMGApp *> *otherApps;

@property (nonatomic, strong, nullable) AMGSettingsDataSection *aboutSection;
@property (nonatomic, strong, nullable) NSArray <AMGSettingsAction *> *footerActions;

/// Configuration

- (void)configureHeader;
- (void)configureFooter;

/// Actions

- (IBAction)reviewOnAppStore:(nullable id)sender;
- (IBAction)shareApp:(nullable id)sender;
- (IBAction)openTwitterAccount:(nullable id)sender;
- (IBAction)showApplication:(nullable id)sender;
- (IBAction)presentLicensesViewController:(nullable id)sender;
- (IBAction)dismissViewController:(nullable id)sender;

+ (void)presentContactSupportViewControllerFrom:(UIViewController <MFMailComposeViewControllerDelegate> *)presentingViewController;

@end


@interface AMGSettingsDataRow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *imageName;
@property (nonatomic, copy) void (^action)(id);

- (instancetype)initWithTitle:(NSString *)title imageName:(nullable NSString *)imageName action:(void(^)(id))action;

@end


@interface AMGSettingsDataSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray <AMGSettingsDataRow *> *rows;

@end

@interface AMGSettingsAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) void (^action)(AMGAboutViewController *);

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(AMGAboutViewController *))action;

@end


NS_ASSUME_NONNULL_END
