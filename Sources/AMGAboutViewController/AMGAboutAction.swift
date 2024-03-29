//
//  AMGAboutAction.swift
//
//  Created by Vincent Tourraine on 11/03/2019.
//  Copyright © 2019-2023 Studio AMANgA. All rights reserved.
//

#if !os(macOS) && !os(visionOS)

import Foundation

struct AMGSettingsDataRow {
    let title: String
    let systemImageName: String
    let action: (Any)->Void
}

struct AMGSettingsAction {
    let title: String
    let action: (AMGAboutViewController)->Void
}

#endif
