//
//  AMGAboutViewController.m
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2021 Studio AMANgA. All rights reserved.
//

#import "AMGAboutViewController.h"
#import "AMGAboutAction.h"
#import "AMGAboutHeaderView.h"
#import "AMGAboutFooterView.h"

#import <SVProgressHUD.h>
#import <AMGAppButton/AMGApp.h>
#import <AMGAppButton/AMGAppButton.h>
#import <VTAppButton.h>
#import <VTAcknowledgementsViewController.h>
#import <VTLocalization.h>


@implementation AMGAboutViewController

#pragma mark - View life cycle

- (void)commonInit {
    self.title = NSLocalizedString(@"About this App", nil);

    AMGSettingsDataRow *reviewRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Review on the App Store", nil) imageName:@"IconStar" systemImageName:@"star" action:^(id sender) {
        [self reviewOnAppStore:sender];
    }];
    AMGSettingsDataRow *shareRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Share the App", nil) imageName:@"IconChat" systemImageName:@"square.on.square" action:^(id sender) {
        [self shareApp:sender];
    }];
    AMGSettingsDataRow *twitterRow = [[AMGSettingsDataRow alloc] initWithTitle:NSLocalizedString(@"Follow on Twitter", nil) imageName:@"IconTwitter" systemImageName:@"text.bubble" action:^(id sender) {
        [self openTwitterAccount:sender];
    }];
    self.rows = @[reviewRow, shareRow, twitterRow];

    AMGSettingsAction *ackRow = [[AMGSettingsAction alloc] initWithTitle:[VTLocalization localizedTitle] action:^(AMGAboutViewController *viewController) {
        [viewController presentLicensesViewController:nil];
    }];
    self.footerActions = @[ackRow];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self commonInit];

    return self;
}

- (instancetype)init {
    if (@available(iOS 13.0, *)) {
        self = [super initWithStyle:UITableViewStyleInsetGrouped];
    }
    else {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }

    [self commonInit];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTableHeaderAndFooter];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    self.tableView.cellLayoutMarginsFollowReadableWidth = YES;

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
}

#pragma mark - Configuration

- (void)configureTableHeaderAndFooter {
    if (self.largeIconName != nil) {
        self.tableView.tableHeaderView = [[AMGAboutHeaderView alloc] initWithIconImageNamed:self.largeIconName];
    }

#if TARGET_OS_MACCATALYST
    self.tableView.tableFooterView = [AMGAboutFooterView creditsLabelForViewController:self];
#else
    NSArray <AMGApp *> *allApps = @[AMGApp.appGamesKeeper, AMGApp.appComicBookDay, AMGApp.appContacts, AMGApp.app1List, AMGApp.appWizBox, AMGApp.appMemorii, AMGApp.appMegaMoji, AMGApp.appD0TSEchoplex, AMGApp.appNanoNotes];
    NSArray <AMGApp *> *otherApps = [allApps filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K != %@", NSStringFromSelector(@selector(identifier)), self.appIdentifier]];

    self.tableView.tableFooterView = [[AMGAboutFooterView alloc] initForViewController:self withApps:otherApps actions:self.footerActions];
#endif
}

#pragma mark - Actions

- (IBAction)reviewOnAppStore:(id)sender {
    if (self.appIdentifier == nil) {
        return;
    }

#if TARGET_OS_MACCATALYST
    NSString *URLString = [NSString stringWithFormat:@"macappstore://apps.apple.com/app/id%@?action=write-review", self.appIdentifier];
#else
    NSString *URLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", self.appIdentifier];
#endif

    NSURL *URL = [NSURL URLWithString:URLString];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

- (void)shareApp:(id)sender {
    if (self.localizedAppName == nil || self.shareAppURL == nil) {
        return;
    }

    NSArray *items = @[self.localizedAppName, self.shareAppURL];
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
    [application openURL:twitterURL options:@{} completionHandler:nil];
}


+ (void)presentContactSupportViewControllerFrom:(UIViewController <MFMailComposeViewControllerDelegate> *)presentingViewController {
    [self presentContactSupportViewControllerFrom:presentingViewController delegate:presentingViewController];
}

+ (void)presentContactSupportViewControllerFrom:(UIViewController *)presentingViewController delegate:(id<MFMailComposeViewControllerDelegate>)delegate {
    if (MFMailComposeViewController.canSendMail == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot Send Email", nil) message:NSLocalizedString(@"Please configure an email account first, or contact me directly at studioamanga@gmail.com", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [presentingViewController presentViewController:alertController animated:YES completion:nil];

        return;
    }

    NSDictionary *bundleInfo = NSBundle.mainBundle.infoDictionary;
    MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
    viewController.mailComposeDelegate = delegate;
    [viewController setToRecipients:@[@"studioamanga@gmail.com"]];
    NSString *bundleDisplayName = bundleInfo[@"CFBundleDisplayName"];
    NSString *bundleShortVersion = bundleInfo[@"CFBundleShortVersionString"];
    [viewController setSubject:[NSString stringWithFormat:@"%@ (%@)", bundleDisplayName, bundleShortVersion]];

    [presentingViewController presentViewController:viewController animated:YES completion:nil];
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

- (IBAction)performFooterAction:(UIButton *)sender {
    AMGSettingsAction *action = self.footerActions[sender.tag];
    action.action(self);
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Store product view delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Mail compose view delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    AMGSettingsDataRow *row = [self rowAtIndexPath:indexPath];
    cell.textLabel.text = row.title;

    if (@available(iOS 13.0, *)) {
        if (row.systemImageName) {
            cell.imageView.image = [UIImage systemImageNamed:row.systemImageName];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:row.imageName];
        }
    }
    else {
        cell.imageView.image = [UIImage imageNamed:row.imageName];
    }

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
    return self.rows[indexPath.row];
}

@end
