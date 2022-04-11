//
//  AMGAboutHeaderView.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

#if !os(macOS)

import UIKit

class AMGAboutHeaderView: UIView {

    convenience init(iconImageNamed iconImageName: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 320, height: 200))

        guard let image = UIImage(named: iconImageName) else {
            return
        }

        let iconImageView = UIImageView(image: image)
        iconImageView.contentMode = .center
        iconImageView.center = center
        iconImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.cornerCurve = .continuous
        addSubview(iconImageView)
    }
}

#endif
