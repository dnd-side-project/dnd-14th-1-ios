//
//  EcoAPI.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/27/26.
//

import Foundation
import Alamofire

enum EcoAPI: Router {
    case fetchEcoTier
}

extension EcoAPI {
    
    var baseURL: String {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchEcoTier: return "/api/v1/users/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchEcoTier: return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .fetchEcoTier:
            var baseDictionary: [String: String] = [:]
            if let accessToken = KeychainWorker.shared.read(key: .access) {
                baseDictionary["Authorization"] = "Bearer \(accessToken)"
            }
            return baseDictionary
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchEcoTier: return nil
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .fetchEcoTier: return nil
        }
    }
}
