//
//  Router.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 1/28/26.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Router {

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.method = method
        urlRequest.headers = HTTPHeaders(headers)

        if let parameters {
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}

extension Encodable {
    
    func toDictionary() -> [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: object) as? [String: Any] else { return nil }
        return dict
    }
}

