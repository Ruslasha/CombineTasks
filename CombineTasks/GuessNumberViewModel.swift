//
//  GuessNumberViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 22.05.2024.
//

import Foundation
import Combine

final class GuessNumberViewModel: ObservableObject {
    var selectionNumber = CurrentValueSubject<Int, Never>(Int.random(in: 1...100))
    var selection = CurrentValueSubject<Int, Never>(0)
    var message = CurrentValueSubject<String, Never>("")

    var cancellable: AnyCancellable?
    @Published var isShowNumber = false

    init() {
        cancellable = selection
            .map { _ in
                self.message.value = "П"
            }
            .delay(for: 0.8, scheduler: DispatchQueue.main)
            .sink { [unowned self] newValue in
                if selection.value < selectionNumber.value {
                    self.message.value = "Введенное число меньше загаданного"
                    objectWillChange.send()
                } else if selection.value > selectionNumber.value {
                    self.message.value = "Введенное число больше загаданного"
                    objectWillChange.send()
                } else {
                    self.message.value = "Вы угадали"
                    objectWillChange.send()
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
        isShowNumber = true
    }
}
