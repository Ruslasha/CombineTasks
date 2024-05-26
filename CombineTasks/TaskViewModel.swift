//
//  TaskViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 26.05.2024.
//

import Foundation
import Combine

struct Good: Hashable {
    let imageName: String
    let price: Int
    let name: String
}

final class TaskViewModel: ObservableObject {
    @Published var state: ViewStateGoods<String> = .connecting("00:00")
    @Published var dataToView: [Good] = []

    var goods: [Good] = [.init(imageName: "star", price: 100, name: "Молоко"),
                         .init(imageName: "star", price: 150, name: "Сыр"),
                         .init(imageName: "", price: 160, name: "Колбаса"),
                         .init(imageName: "star", price: 170, name: "Чипсы"),
                         .init(imageName: "star", price: 50, name: "Огурец"),
                         .init(imageName: "star", price: 234, name: "Банан"),
                         .init(imageName: "star", price: 532, name: "Помидор")]

    let verifyState = PassthroughSubject<String, Never>()
    let secondsState = PassthroughSubject<Int, Never>()

    var cancellable: AnyCancellable?
    var timerCancellable: AnyCancellable?

    init() {
    }

    func fetch() {
        _ = goods.publisher
            .filter {
                $0.price > 100 && $0.imageName != ""
            }
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [unowned self] value in
                dataToView.append(value)
                print(value)
            })
    }

    func start() {
        var leftTime = 30
        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] datum in
                secondsState.send(leftTime)
                verifyState.send("00:\(String(format: "%02d", leftTime))")
                if leftTime > 6 {
                    state = .connecting("00:\(String(format: "%02d", leftTime))")
                } else if leftTime < 4 {
                    state = .loaded("00:\(String(format: "%02d", leftTime))")
                } else if leftTime < 7 {
                    state = .loading("00:\(String(format: "%02d", leftTime))")
                } else {
                    state = .error(NSError(domain: "Error time", code: 101))
                }
                if leftTime == 20 {
                    timerCancellable?.cancel()
                }
                leftTime -= 1
            })
    }
}
