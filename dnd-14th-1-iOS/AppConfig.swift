//
//  AppConfig.swift
//  dnd-14th-1-iOS
//
//  Created by a on 1/31/26.
//

import Foundation

struct AppConfig {
    static let baseURL: String = {
        guard let url = Bundle.main.infoDictionary?["BASE_URL"] as? String, !url.isEmpty else {
            fatalError("BASE_URL must be set in the Info.plist and cannot be empty.")
        }
        return url
    }()
}
