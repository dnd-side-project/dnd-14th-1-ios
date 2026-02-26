//
//  LoginRequest.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct LoginRequest: Encodable {
    let deviceID: String
    let platform: String
    let packageName: String
    let idToken: String

    enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case platform, packageName, idToken
    }
}
