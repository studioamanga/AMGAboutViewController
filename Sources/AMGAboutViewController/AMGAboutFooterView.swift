//
//  AMGAboutFooterView.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

#if !os(macOS)

import UIKit
import AMGAppButton

class AMGAboutFooterView: UIView {

    var appsScrollView: UIScrollView?
    var appsView: UIView?
    
    struct K {
        static let AppsHeaderHeight: CGFloat = 170
        static let IconWidth: CGFloat = 70
        static let ActionHeight: CGFloat = 20
        static let ActionMargin: CGFloat = 10
        static let PrimaryTextColor: UIColor = .secondaryLabel
        static let SecondaryTextColor: UIColor = .tertiaryLabel
    }
    
    init(for viewController: AMGAboutViewController, with apps: [AMGApp], actions: [AMGSettingsAction]) {
        let frame = CGRect(x: 0, y: 0, width: 320, height: K.AppsHeaderHeight + 120 + (K.ActionHeight + K.ActionMargin) * CGFloat(actions.count))
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth]

        let footerLabel = discoverAllMyAppsLabel()
        addSubview(footerLabel)

        let AppsSideMargin: CGFloat = 12
        let AppsMargin: CGFloat = 8
        let appsScrollView = UIScrollView(frame: CGRect(x: 0, y: 70, width: frame.width, height: K.IconWidth))
        appsScrollView.autoresizingMask = [.flexibleWidth]
        appsScrollView.clipsToBounds = false
        appsScrollView.showsHorizontalScrollIndicator = false
        appsScrollView.alwaysBounceHorizontal = false

        let appsView = UIView(frame: CGRect(x: 0, y: 0, width: (CGFloat(apps.count) * (K.IconWidth + AppsMargin)) - AppsMargin + (AppsSideMargin * 2), height: K.IconWidth))
        appsView.backgroundColor = .clear
        appsView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]

        for (index, app) in apps.enumerated() {
            let button = AMGAppButton(with: app)
            button.addTarget(viewController, action: #selector(AMGAboutViewController.showApplication(_:)), for: .touchUpInside)
            button.frame = CGRect(x: AppsSideMargin + CGFloat(index) * (K.IconWidth + AppsMargin), y: 0, width: K.IconWidth, height: K.IconWidth)
            appsView.addSubview(button)
        }

        appsView.center = CGPoint(x: frame.width / 2, y: K.IconWidth / 2)
        appsScrollView.addSubview(appsView)
        appsScrollView.contentSize = appsView.frame.size

        addSubview(appsScrollView)
        self.appsScrollView = appsScrollView
        self.appsView = appsView

        let creditsLabel = AMGAboutFooterView.creditsLabel(for: viewController)
        addSubview(creditsLabel)

        for (index, action) in actions.enumerated() {
            let button = button(for: action, index: index, target: viewController)
            addSubview(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let appsScrollView = appsScrollView,
            let appsView = appsView else {
            return
        }
        
        if (appsScrollView.frame.width > appsView.frame.width) {
            appsView.center = CGPoint(x: appsScrollView.frame.width / 2, y: appsScrollView.frame.height / 2)
        }
        else {
            appsView.frame = CGRect(x: 0, y: 0, width: appsView.frame.width, height: appsView.frame.height)
        }
    }
    
    func discoverAllMyAppsLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: frame.width, height: 20))
        label.text = NSLocalizedString("Discover All My Apps", comment: "").localizedUppercase
        label.textAlignment = .center
        label.textColor = K.PrimaryTextColor
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        // Need Auto Layout
        // label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        label.autoresizingMask = .flexibleWidth
        return label
    }
    
    static func creditsLabel(for viewController: AMGAboutViewController) -> UILabel {
        guard let bundleInfo = Bundle.main.infoDictionary,
              let bundleDisplayName = bundleInfo["CFBundleDisplayName"] as? String,
              let bundleShortVersion = bundleInfo["CFBundleShortVersionString"] as? String else {
            return UILabel()
        }

        let creditsLabel = UILabel(frame: CGRect(x: 0, y: K.AppsHeaderHeight + 20, width: 320, height: 40))
        creditsLabel.autoresizingMask = .flexibleWidth
        creditsLabel.textAlignment = .center
        creditsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        // Need Auto Layout
        // creditsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        creditsLabel.textColor = K.PrimaryTextColor
        creditsLabel.numberOfLines = 2
        creditsLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@ v%@\n%@", comment: ""), viewController.localizedAppName ?? bundleDisplayName, bundleShortVersion, NSLocalizedString("Made by Studio AMANgA", comment: ""))
        return creditsLabel
    }
    
    func button(for action: AMGSettingsAction, index: Int, target: Any) -> UIButton {
        let normalAttributes: [NSAttributedString.Key : Any] = [
            .underlineStyle: 1,
            .foregroundColor: K.PrimaryTextColor]
        let highlightedAttributes: [NSAttributedString.Key : Any] = [
            .underlineStyle: 1,
            .foregroundColor: K.SecondaryTextColor]

        let button = UIButton(type: .custom)
        button.autoresizingMask = .flexibleWidth
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        // Need Auto Layout
        // button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

        button.setAttributedTitle(NSAttributedString(string: action.title, attributes: normalAttributes), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: action.title, attributes: highlightedAttributes), for: .highlighted)
        button.tag = index
        button.addTarget(target, action: #selector(AMGAboutViewController.performFooterAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: K.AppsHeaderHeight + 70 + CGFloat(index) * (K.ActionHeight + K.ActionMargin), width: 320, height: K.ActionHeight)

        return button
    }
}

#endif
