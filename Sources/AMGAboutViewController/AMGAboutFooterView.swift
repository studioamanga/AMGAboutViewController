//
//  AMGAboutFooterView.h
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2020 Studio AMANgA. All rights reserved.
//

import UIKit
import AMGAppButton

//@class AMGAboutViewController;
//@class AMGApp;
//@class AMGSettingsAction;

class AMGAboutFooterView: UIView {

    var appsScrollView: UIScrollView?
    var appsView: UIView?
    
    struct K {
        static let AppsHeaderHeight: CGFloat = 170
        static let IconWidth: CGFloat = 70
        static let ActionHeight: CGFloat = 20
        static let ActionMargin: CGFloat = 10
    }
    
    init(for viewController: AMGAboutViewController, with apps: [AMGApp], actions: [AMGSettingsAction]) {
        let frame = CGRect(x: 0, y: 0, width: 320, height: K.AppsHeaderHeight + 120 + (K.ActionHeight + K.ActionMargin) * CGFloat(actions.count))
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth]

        // let footerLabel = [self discoverAllMyAppsLabel];
        // [self addSubview:footerLabel];

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
    
// - (instancetype)initForViewController:(AMGAboutViewController *)viewController withApps:(NSArray <AMGApp *> *)apps actions:(NSArray <AMGSettingsAction *> *)actions;

//+ (UILabel *)creditsLabelForViewController:(AMGAboutViewController *)viewController;
    
    static func creditsLabel(for viewController: AMGAboutViewController) -> UILabel {
        return UILabel()
    }
    
    func button(for action: AMGSettingsAction, index: Int, target: Any) -> UIButton {
        return UIButton()
    }

}
