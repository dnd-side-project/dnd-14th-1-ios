//
//  AppConfig.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import Foundation

struct AppConfig {
    static let BASE_URL = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
}
