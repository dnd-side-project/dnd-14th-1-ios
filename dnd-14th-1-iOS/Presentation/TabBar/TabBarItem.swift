//
//  TabBarItem.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/11/26.
//

enum TabBarItem: CaseIterable {
    case eco
    case diagnosis
    case settings
    
    var title: String {
        switch self {
        case .eco:
            "나의에코"
        case .diagnosis:
            "진단"
        case .settings:
            "설정"
        }
    }
    
    var iconName: String {
        switch self {
        case .eco:
            "leaf"
        case .diagnosis:
            "chat"
        case .settings:
            "settings"
        }
    }
    
    var pageIndex: Int {
        switch self {
        case .eco:
            0
        case .diagnosis:
            1
        case .settings:
            2
        }
    }
}
