//
//  taskViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 23.05.2024.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {

    var inputText = CurrentValueSubject<String, Never>("")
    var rows: [String] = []
    var cancellable: AnyCancellable?
    var isHiddenButton = CurrentValueSubject<Bool, Never>(true)

    init() {
        cancellable = inputText
            .sink { [unowned self] item in
                isHiddenButton.value = inputText.value.isEmpty ? true : false
                objectWillChange.send()
            }
    }

    func addText() {
        _ = inputText
            .flatMap{ item -> AnyPublisher<String, Never> in
                if !item.isEmpty  {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            }

            .sink{ [unowned self] item in
                inputText.value = ""
                rows.append(item)
                objectWillChange.send()
            }

    }

    func removeAll() {
        inputText.value = ""
        rows = []
        objectWillChange.send()
    }
}
