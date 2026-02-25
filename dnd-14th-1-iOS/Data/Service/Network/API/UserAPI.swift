//
//  UserAPI.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Alamofire

enum UserAPI: Router {
    case fetchLogin(LoginRequest)
    case fetchUserProfile
    case fetchMyBadges
}

extension UserAPI {
    
    var baseURL: String {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchLogin: "/open-api/v1/auth/apple"
        case .fetchUserProfile: "/api/v1/users/me"
        case .fetchMyBadges: "/api/v1/badges/my"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchLogin: .post
        case .fetchUserProfile: .get
        case .fetchMyBadges: .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .fetchLogin:
            return [:]
        case .fetchUserProfile, .fetchMyBadges:
            var baseDictionary: [String: String] = [:]
            if let accessToken = KeychainWorker.shared.read(key: .access) {
                baseDictionary["Authorization"] = "Bearer \(accessToken)"
            }
            return baseDictionary
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchLogin(let request):
            return request.toDictionary()
        case .fetchUserProfile, .fetchMyBadges:
            return nil
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .fetchLogin:
            return JSONEncoding.default
        case .fetchUserProfile, .fetchMyBadges:
            return nil
        }
    }
}
