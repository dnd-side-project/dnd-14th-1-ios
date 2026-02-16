//
//  ViewModelType.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/15/26.
//

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
