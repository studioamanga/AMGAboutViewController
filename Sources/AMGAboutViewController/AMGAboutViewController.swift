//
//  AMGAboutViewController.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

#if !os(macOS)

import UIKit
import MessageUI
import StoreKit
import AcknowList
import VTAppButton
import AMGAppButton
import TrackupVersionHistory

public class AMGAboutViewController: UITableViewController {
    
    @objc public var localizedAppName: String?
    @objc public var largeIconName: String?
    @objc public var acknowledgementsFileName: String?
    @objc public var shareAppURL: URL?

    public var appIdentifier: Int?
    @objc public func setAppIdentifier(_ appIdentifier: NSNumber?) {
        self.appIdentifier = appIdentifier?.intValue
    }

    var rows: [AMGSettingsDataRow]?
    var footerActions: [AMGSettingsAction]?
    
    struct K {
        static let cellIdentifier = "Cell"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public init() {
        super.init(style: .insetGrouped)
        commonInit()
    }
    
    func commonInit() {
        title = NSLocalizedString("About this App", comment: "")
        
        let reviewRow = AMGSettingsDataRow(title: NSLocalizedString("Review on the App Store", comment: ""), systemImageName: "star") {
            self.reviewOnAppStore($0)
        }
        
        let shareRow = AMGSettingsDataRow(title: NSLocalizedString("Share the App", comment: ""), systemImageName: "square.on.square") {
            self.shareApp($0)
        }
        
        let twitterRow = AMGSettingsDataRow(title: NSLocalizedString("Follow on Twitter", comment: ""), systemImageName: "text.bubble") {
            self.openTwitterAccount($0)
        }
        
        let versionHistoryRow = AMGSettingsDataRow(title: NSLocalizedString("Version History", comment: ""), systemImageName: "list.bullet.rectangle") {
            self.presentVersionHistory($0)
        }

        rows = [reviewRow, shareRow, twitterRow, versionHistoryRow]
        footerActions = []
    }
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        if acknowledgementsFileName != nil {
            let ackAction = AMGSettingsAction(title: AcknowLocalization.localizedTitle()) { viewController in
                viewController.presentLicensesViewController(nil)
            }

            footerActions?.insert(ackAction, at: 0)
        }

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
        tableView.tableFooterView = AMGAboutFooterView.creditsLabel(for: self)
#else
        let allApps: [AMGApp] = [.gamesKeeper, .comicBookDay, .contacts, .oneList, .wizBox, .memorii, .megaMoji, .d0tsEchoplex, .nanoNotes]
        let otherApps = allApps.filter { $0.identifier != appIdentifier }
        tableView.tableFooterView = AMGAboutFooterView(for: self, with: otherApps, actions: footerActions ?? [])
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
    
    func presentVersionHistory(_ sender: Any) {
        let viewController = VersionHistoryViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: -
    
    @objc public static func presentContactSupportViewController(from presentingViewController: UIViewController & MFMailComposeViewControllerDelegate) {
        presentContactSupportViewController(from: presentingViewController, delegate: presentingViewController)
    }
    
    @objc public static func presentContactSupportViewController(from presentingViewController: UIViewController, delegate: MFMailComposeViewControllerDelegate) {
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
        guard let sender = sender as? AMGAppButton,
              let senderAppIdentifier = sender.appIdentifier else {
            return
        }
        
        sender.isLoading = true
        
        let appIdentifier = NSNumber(integerLiteral: senderAppIdentifier)
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self
        storeProductViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appIdentifier]) { result, error in
            sender.isLoading = false

            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                self.present(storeProductViewController, animated: true)
            }
        }
    }
    
    func presentLicensesViewController(_ sender: Any?) {
        let viewController: AcknowListViewController
        if let acknowledgementsFileName = acknowledgementsFileName {
            viewController = AcknowListViewController(fileNamed: acknowledgementsFileName)
        }
        else {
            viewController = AcknowListViewController()
        }

        navigationController?.pushViewController(viewController, animated: true)
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
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let row = row(at: indexPath) {
            row.action(indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AMGAboutViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AMGAboutViewController: SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// Objective-C helpers
extension AMGAboutViewController {
    @objc public func addFooterAction(title: String, action: @escaping (AMGAboutViewController)->Void) {
        let action = AMGSettingsAction(title: title, action: action)
        footerActions?.append(action)
    }
}

#endif
