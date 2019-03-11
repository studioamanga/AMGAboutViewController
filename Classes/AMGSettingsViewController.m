//
//  AMGSettingsViewController.m
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019 Studio AMANgA. All rights reserved.
//

#import "AMGSettingsViewController.h"

#import <SVProgressHUD.h>
#import <AMGAppButton/AMGApp.h>
#import <AMGAppButton/AMGAppButton.h>
#import <VTAppButton.h>
#import <NGAParallaxMotion.h>
#import <VTAcknowledgementsViewController.h>


NS_ENUM(NSUInteger, AMGAboutRow) {
    AMGAboutRowReviewApp = 0,
    AMGAboutRowShareApp,
    AMGAboutRowEmail,
    AMGAboutRowTwitter
};

@implementation AMGSettingsDataSection
@end


@implementation AMGSettingsDataRow

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName action:(void(^)(id))action {
    self = [super init];
    self.title = title;
    self.imageName = imageName;
    self.action = action;
    return self;
}

@end


@implementation AMGSettingsAction

- (instancetype)initWithTitle:(NSString *)title action:(nonnull SEL)action {
    self = [super init];
    self.title = title;
    self.action = action;
    return self;
}

@end


@interface AMGSettingsViewController ()

@end

@implementation AMGSettingsViewController

#pragma mark - View life cycle

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];

    AMGSettingsDataSection *aboutSection = [[AMGSettingsDataSection alloc] init];
    aboutSection.title = NSLocalizedString(@"About", nil);
    AMGSettingsDataRow *reviewRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Review on the App Store", nil) imageName:@"IconStar" action:^(id sender) {
        [self reviewOnAppStore:sender];
    }];
    AMGSettingsDataRow *shareRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Share the App", nil) imageName:@"IconChat" action:^(id sender) {
        [self shareApp:sender];
    }];
    AMGSettingsDataRow *emailRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Contact Support", nil) imageName:@"IconEnvelope" action:^(id sender) {
        [self emailSupport:sender];
    }];
    AMGSettingsDataRow *twitterRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Follow on Twitter", nil) imageName:@"IconTwitter" action:^(id sender) {
        [self openTwitterAccount:sender];
    }];
    aboutSection.rows = @[reviewRow, shareRow, emailRow, twitterRow];
    self.aboutSection = aboutSection;

    AMGSettingsAction *ackRow = [[AMGSettingsAction alloc] initWithTitle:[VTAcknowledgementsViewController localizedTitle] action:@selector(presentLicensesViewController:)];
    self.footerActions = @[ackRow];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureHeader];
    [self configureFooter];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
}

#pragma mark - Configuration

- (void)configureHeader {
    if (self.largeIconName == nil) {
        return;
    }

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];

    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.largeIconName]];
    iconImageView.contentMode = UIViewContentModeCenter;
    iconImageView.center = CGPointMake(headerView.center.x, headerView.center.y + 10);
    iconImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 25;
    iconImageView.parallaxIntensity = 40;

    [headerView addSubview:iconImageView];
    self.tableView.tableHeaderView = headerView;
}

- (void)configureFooter {
    if (self.otherApps == nil) {
        return;
    }

    const CGFloat appsHeaderHeight = 170;
    const CGFloat ActionHeight = 20;
    const CGFloat ActionMargin = 10;

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, appsHeaderHeight + 120 + (ActionHeight + ActionMargin) * self.footerActions.count)];

    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGFloat iconWidth = 70;

    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(footerView.frame), 20)];
    footerLabel.text = NSLocalizedString(@"Discover All My Apps", nil).uppercaseString;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor darkGrayColor];
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [footerView addSubview:footerLabel];

    CGFloat leftMargin = 10;
    UIView *appsView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(footerView.frame), iconWidth)];
    appsView.backgroundColor = [UIColor clearColor];
    appsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    for (AMGApp *app in self.otherApps) {
        AMGAppButton *button = [AMGAppButton buttonWithApp:app];
        [button addTarget:self action:@selector(showApplication:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(leftMargin + [self.otherApps indexOfObject:app]*(iconWidth + 6), 0, iconWidth, iconWidth);
        [appsView addSubview:button];
    }

    [footerView addSubview:appsView];

    NSDictionary *bundleInfo = NSBundle.mainBundle.infoDictionary;
    NSString *bundleDisplayName = bundleInfo[@"CFBundleDisplayName"];
    NSString *bundleShortVersion = bundleInfo[@"CFBundleShortVersionString"];

    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, appsHeaderHeight + 20, 320, 40)];
    creditsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    creditsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    creditsLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    creditsLabel.numberOfLines = 2;
    creditsLabel.text = [NSString stringWithFormat:@"%@ v%@\n%@", bundleDisplayName, bundleShortVersion, NSLocalizedString(@"Made by Studio AMANgA", nil)];
    [footerView addSubview:creditsLabel];

    NSDictionary *normalAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [UIColor colorWithWhite:0.7 alpha:1]};
    NSDictionary *highlightedAttributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: [UIColor colorWithWhite:0.4 alpha:1]};

    [self.footerActions enumerateObjectsUsingBlock:^(AMGSettingsAction * _Nonnull action, NSUInteger index, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:normalAttributes] forState:UIControlStateNormal];
        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:action.title attributes:highlightedAttributes] forState:UIControlStateHighlighted];

        [button addTarget:self action:action.action forControlEvents:UIControlEventTouchUpInside];

        button.frame = CGRectMake(0, appsHeaderHeight + 70 + index * (ActionHeight + ActionMargin), 320, ActionHeight);
        [footerView addSubview:button];
    }];

    self.tableView.tableFooterView = footerView;
}

- (nonnull NSAttributedString *)acknowledgementsTitleWithColor:(nonnull UIColor *)color {
    NSDictionary *attributes = @{NSUnderlineStyleAttributeName: @1, NSForegroundColorAttributeName: color};
    NSString *title = [VTAcknowledgementsViewController localizedTitle];
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - Actions

- (IBAction)reviewOnAppStore:(id)sender {
    if (self.appIdentifier == nil) {
        return;
    }

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self.appIdentifier]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)shareApp:(id)sender {
    if (self.shareAppText == nil || self.shareAppURL == nil) {
        return;
    }

    NSArray *items = @[self.shareAppText, self.shareAppURL];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];

    activityViewController.popoverPresentationController.sourceView = self.tableView;
    if ([sender isKindOfClass:NSIndexPath.class]) {
        activityViewController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:sender];
    }

    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)openTwitterAccount:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *twitterURL = [NSURL URLWithString:@"https://www.twitter.com/StudioAMANgA"];
    [application openURL:twitterURL];
}

- (IBAction)emailSupport:(id)sender {
    if (MFMailComposeViewController.canSendMail == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot Send Email", nil) message:NSLocalizedString(@"Please configure an email account first, or contact me directly at studioamanga@gmail.com", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }

    NSDictionary *bundleInfo = NSBundle.mainBundle.infoDictionary;
    MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
    viewController.mailComposeDelegate = self;
    [viewController setToRecipients:@[@"studioamanga@gmail.com"]];
    NSString *bundleDisplayName = bundleInfo[@"CFBundleDisplayName"];
    NSString *bundleShortVersion = bundleInfo[@"CFBundleShortVersionString"];
    [viewController setSubject:[NSString stringWithFormat:@"%@ (%@)", bundleDisplayName, bundleShortVersion]];

    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)showApplication:(id)sender {
    if ([sender isKindOfClass:VTAppButton.class] == NO) {
        return;
    }

    [SVProgressHUD show];

    NSString *appIdentifier = ((VTAppButton *)sender).appIdentifier;
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    storeProductViewController.delegate = self;
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: appIdentifier} completionBlock:^(BOOL result, NSError *error) {
        [SVProgressHUD dismiss];

        if (error) {
            NSLog(@"%@", error);
        } else {
            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (IBAction)presentLicensesViewController:(id)sender {
    UIViewController *viewController = nil;
    if (self.acknowledgementsFileName != nil ) {
        viewController = [[VTAcknowledgementsViewController alloc] initWithFileNamed:self.acknowledgementsFileName];
    }
    else {
        viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Mail compose view delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Store product view delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((NSUInteger)section >= self.sections.count) {
        if (self.sections.count == 0) {
            return nil;
        }

        return self.aboutSection.title;
    }

    return self.sections[section].title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((NSUInteger)section >= self.sections.count) {
        return self.aboutSection.rows.count;
    }

    return self.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    AMGSettingsDataRow *row = [self rowAtIndexPath:indexPath];
    cell.textLabel.text = row.title;
    cell.imageView.image = [UIImage imageNamed:row.imageName];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMGSettingsDataRow *row = [self rowAtIndexPath:indexPath];
    row.action(indexPath);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (nullable AMGSettingsDataRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    return self.aboutSection.rows[indexPath.row];
}

@end
