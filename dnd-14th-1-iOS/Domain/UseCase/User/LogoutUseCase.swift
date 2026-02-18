//
//  LogoutUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/18/26.
//

import Foundation
import Combine

protocol LogoutUseCase {
    func execte()
}

final class DefaultLogoutUseCase: LogoutUseCase {
    
    func execte() {
        KeychainWorker.shared.delete(key: .access)
        KeychainWorker.shared.delete(key: .refresh)
        NotificationCenter.default.post(name: NSNotification.Name("DidLogout"), object: nil)
    }
}
