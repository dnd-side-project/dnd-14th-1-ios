//
//  KeychainWorker.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 1/31/26.
//

import Foundation

final class KeychainWorker {
    
    enum TokenType: String {
        case access
        case refresh
        case userId
    }
    
    private let serviceIdentifier = Bundle.main.bundleIdentifier ?? "ac.dnd.dnd-14th-1-iOS"
    
    static let shared = KeychainWorker()
    private init() {}
    
    func create(key: TokenType, value: String) {
        // 이미 존재하는 키체인 삭제
        var query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
        
        // 새로운 키체인 생성
        query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount: key.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("\(key) 키체인 생성 실패 :", SecCopyErrorMessageString(status, nil) ?? "")
        }
    }
    
    func read(key: TokenType) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
    
        switch status {
        case errSecSuccess:
            if let retrievedData: Data = dataTypeRef as? Data {
                return String(data: retrievedData, encoding: String.Encoding.utf8)
            } else {
                print("\(key) 키체인 조회 실패 :", SecCopyErrorMessageString(status, nil) ?? "")
                return nil
            }
        case errSecItemNotFound:
            print("\(key) 키체인이 존재하지 않습니다")
            return nil
        default:
            print("\(key) 키체인 조회 실패 :", SecCopyErrorMessageString(status, nil) ?? "")
            return nil
        }
    }
    
    func delete(key: TokenType) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount: key.rawValue
        ]
        let status = SecItemDelete(query)
        
        switch status {
        case errSecSuccess: print("\(key) 키체인 삭제 완료")
        case errSecItemNotFound: print("\(key) 키체인이 존재하지 않습니다")
        default: print("\(key) 키체인 삭제 실패 :", SecCopyErrorMessageString(status, nil) ?? "")
        }
    }
}
