//
//  AMGAboutAction.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2022 Studio AMANgA. All rights reserved.
//

#if !os(macOS)

import Foundation

struct AMGSettingsDataRow {
    let title: String
    let imageName: String
    let systemImageName: String
    let action: (Any)->Void
}

struct AMGSettingsAction {
    let title: String
    let action: (AMGAboutViewController)->Void
}

#endif
