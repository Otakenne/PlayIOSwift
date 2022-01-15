//
//  SettingsModels.swift
//  PlayIO
//
//  Created by Otakenne on 13/01/2022.
//

import Foundation

struct Section {
    var title: String
    var options: [Options]
}

struct Options {
    var title: String
    var handler: () -> Void
}
