//
//  TaskViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 26.05.2024.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var dataToView: [String] = []

    var fruits = ["Яблоко", "Банан", "Апельсин"]
    var otherFruits = ["Фрукт 4", "Фрукт 5", "Фрукт 7"]

    func fetch() {
           Just(fruits)
            .flatMap{ $0.publisher }
            .collect()
            .assign(to: &$dataToView)
    }

    func addFruit() {
        _ = otherFruits.publisher
            .first()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [unowned self] value in
                dataToView.append(value)
                otherFruits.removeFirst()
                return
            })
    }

    func deleteLastFruct() {
        dataToView.removeLast()
    }
}
