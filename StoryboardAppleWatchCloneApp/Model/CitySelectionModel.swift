//
//  CitySelectionModel.swift
//  StoryboardAppleWatchCloneApp
//
//  Created by racoon on 6/17/24.
//

import Foundation


struct Item {
    var title: String
    var timeZone: TimeZone
}

struct Section {
    var sectionTitle: String
    var items: [Item]
}
