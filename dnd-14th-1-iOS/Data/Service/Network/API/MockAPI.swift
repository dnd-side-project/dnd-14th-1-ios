//
//  MockAPI.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 1/31/26.
//

import Foundation
import Alamofire

enum MockAPI: Router {
    case fetchSomething(Int)
    case postSomething(Int, MockRequest)
    
}

extension MockAPI {
    
    var baseURL: String {
        return "" // TODO: API KEY
    }
    
    var path: String {
        switch self {
        case .fetchSomething(let id): "/fetchSomething/\(id)"
        case .postSomething(let id, _): "/postSomething/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSomething: .get
        case .postSomething: .post
        }
    }
    
    var headers: [String : String] { // MARK: - Access token은 이곳에서 넣지 않습니다!
        switch self {
        case .fetchSomething:
            return [:]
        case .postSomething:
            return [:]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchSomething:
            return nil
        case .postSomething(_, let request):
            return request.toDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .fetchSomething:
            return nil
        case .postSomething:
            return JSONEncoding.default
        }
    }
}
