//
//  AMGAboutViewController.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import AcknowList
import VTAppButton
import SVProgressHUD

class AMGAboutViewController: UITableViewController {

    var appIdentifier: Int?
    var localizedAppName: String?
    var largeIconName: String?
    var acknowledgementsFileName: String?
    var shareAppURL: URL?

    var rows: [AMGSettingsDataRow]?
    var footerActions: [AMGSettingsAction]?
    
    struct K {
        static let cellIdentifier = "Cell"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init() {
        super.init(style: .insetGrouped)
        commonInit()
    }
    
    func commonInit() {
        title = NSLocalizedString("About this App", comment: "")
        
        let reviewRow = AMGSettingsDataRow(title: NSLocalizedString("Review on the App Store", comment: ""), imageName: "IconStar", systemImageName: "star") {
            self.reviewOnAppStore($0)
        }
        
        let shareRow = AMGSettingsDataRow(title: NSLocalizedString("Share the App", comment: ""), imageName: "IconChat", systemImageName: "square.on.square") {
            self.shareApp($0)
        }
        
        let twitterRow = AMGSettingsDataRow(title: NSLocalizedString("Follow on Twitter", comment: ""), imageName: "IconTwitter", systemImageName: "text.bubble") {
            self.openTwitterAccount($0)
        }
        
        rows = [reviewRow, shareRow, twitterRow]

        let ackRow = AMGSettingsAction(title: AcknowLocalization.localizedTitle()) { _ in
            // [viewController presentLicensesViewController:nil];
        }
        
        footerActions = [ackRow]
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableHeaderAndFooter()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        tableView.cellLayoutMarginsFollowReadableWidth = true

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Configuration
    
    func configureTableHeaderAndFooter() {
        if let largeIconName = largeIconName {
            tableView.tableHeaderView = AMGAboutHeaderView(iconImageNamed: largeIconName)
        }
        
#if targetEnvironment(macCatalyst)
        // tableView.tableFooterView = AMGAboutFooterView creditsLabelForViewController:self];
#else
        /*
         NSArray <AMGApp *> *allApps = @[AMGApp.appGamesKeeper, AMGApp.appComicBookDay, AMGApp.appContacts, AMGApp.app1List, AMGApp.appWizBox, AMGApp.appMemorii, AMGApp.appMegaMoji, AMGApp.appD0TSEchoplex, AMGApp.appNanoNotes];
         NSArray <AMGApp *> *otherApps = [allApps filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K != %@", NSStringFromSelector(@selector(identifier)), self.appIdentifier]];

         self.tableView.tableFooterView = [[AMGAboutFooterView alloc] initForViewController:self withApps:otherApps actions:self.footerActions];
         */
#endif
    }
    
    // MARK: - Actions
    
    func reviewOnAppStore(_ sender: Any) {
        guard let appIdentifier = appIdentifier else {
            return
        }
        
#if targetEnvironment(macCatalyst)
        let URLString = "macappstore://apps.apple.com/app/id\(appIdentifier)?action=write-review"
#else
        let URLString = "itms-apps://itunes.apple.com/app/id\(appIdentifier)?action=write-review"
#endif
        
        let url = URL(string: URLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func shareApp(_ sender: Any) {
        guard let localizedAppName = localizedAppName,
              let shareAppURL = shareAppURL else {
            return
        }
        
        let items = [localizedAppName, shareAppURL] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = tableView
        
        if let sender = sender as? IndexPath {
            activityViewController.popoverPresentationController?.sourceRect = tableView.rectForRow(at: sender)
        }

        present(activityViewController, animated: true)
    }
    
    func openTwitterAccount(_ sender: Any) {
        let twitterURL = URL(string: "https://www.twitter.com/StudioAMANgA")!
        UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
    }
    
    // MARK: -
    
    static func presentContactSupportViewController(from presentingViewController: UIViewController & MFMailComposeViewControllerDelegate) {
        presentContactSupportViewController(from: presentingViewController, delegate: presentingViewController)
    }
    
    static func presentContactSupportViewController(from presentingViewController: UIViewController, delegate: MFMailComposeViewControllerDelegate) {
        guard MFMailComposeViewController.canSendMail() else {
            let alertController = UIAlertController(title: NSLocalizedString("Cannot Send Email", comment: ""), message: NSLocalizedString("Please configure an email account first, or contact me directly at studioamanga@gmail.com", comment: ""), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel))
            presentingViewController.present(alertController, animated: true)

            return
        }
        
        guard let bundleInfo = Bundle.main.infoDictionary,
              let bundleDisplayName = bundleInfo["CFBundleDisplayName"],
              let bundleShortVersion = bundleInfo["CFBundleShortVersionString"] else {
            return
        }
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = delegate
        viewController.setToRecipients(["studioamanga@gmail.com"])
        viewController.setSubject("\(bundleDisplayName) (\(bundleShortVersion))")
        presentingViewController.present(viewController, animated: true)
    }
    
    @objc func showApplication(_ sender: Any) {
        guard let sender = sender as? VTAppButton else {
            return
        }
        
        SVProgressHUD.show()
        
        let appIdentifier = NSNumber(integerLiteral: sender.appIdentifier)
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self
        storeProductViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appIdentifier]) { result, error in
            SVProgressHUD.dismiss()
            
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                self.present(storeProductViewController, animated: true)
            }
        }
    }
    
    func presentLicensesViewController(_ sender: Any) {
        let viewController: UIViewController
        if let acknowledgementsFileName = acknowledgementsFileName {
            viewController = AcknowListViewController(fileNamed: acknowledgementsFileName)
        }
        else {
            viewController = AcknowListViewController()
        }
        
        navigationController?.present(viewController, animated: true)
    }
    
    @objc func performFooterAction(_ sender: UIButton) {
        if let action = footerActions?[sender.tag] {
            action.action(self)
        }
    }
    
    func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rows?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        if let row = row(at: indexPath) {
            cell.textLabel?.text = row.title
            cell.imageView?.image = UIImage(systemName: row.systemImageName)
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func row(at indexPath: IndexPath) -> AMGSettingsDataRow? {
        return rows?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = row(at: indexPath) {
            row.action(indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AMGAboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AMGAboutViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
