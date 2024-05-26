//
//  taskViewController.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 23.05.2024.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var text = ""
    @Published var age = 0
    @Published var error: InvalidNumberError?
    @Published var items: [Int] = []

    func save() {
        _ = validationPublisher(number: Int(text))
            .sink { [unowned self] complition in
                switch complition {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in

            }
    }

    func validationPublisher(number: Int?) -> AnyPublisher<Int, InvalidNumberError> {
        if let number = number {
            items.append(number)
            return Just(number)
                .setFailureType(to: InvalidNumberError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: InvalidNumberError.noNumber)
                .eraseToAnyPublisher()
        }
    }

    func removeAll() {
        items = []
        error = nil
    }
}

enum InvalidNumberError: String, Error, Identifiable {
    var id: String { rawValue }
    case noNumber = "Введенное значение не является числом."
}
