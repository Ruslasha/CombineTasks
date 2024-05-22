//
//  BasketViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 22.05.2024.
//

import Combine
import Foundation

struct Good {
    let id = UUID()
    let name: String
    let price: Int
}

final class BasketViewModel: ObservableObject {

    @Published var goods: [Good] = [
        .init(name: "Хлеб", price: 15),
        .init(name: "Макароны", price: 453),
        .init(name: "Молоко", price: 21),
        .init(name: "Масло", price: 352),
        .init(name: "Чай", price: 555),
        .init(name: "Банан", price: 2300)
    ]


    @Published var Products: [Good] = []
    @Published var addProducts: Good?
    @Published var removeProducts: Good?
    @Published var sum = 0

    private var productCancellable: Set<AnyCancellable> = []

    init() {
        $addProducts
            .filter {$0?.price ?? 0 <= 1000}
            .sink(receiveValue: { product in
                guard let product else { return }
                self.Products.append(product)
            })
            .store(in: &productCancellable)

        $removeProducts
            .sink(receiveValue: { good in
                guard let index = self.Products.firstIndex(where:  {$0.name == good?.name}) else { return }
                self.Products.remove(at: index)
            })
            .store(in: &productCancellable)

        $Products
            .map { $0.reduce(0) {$0 + $1.price} }
            .scan(100) { sum, price in
                100 + price
            }
            .assign(to: \.sum, on: self)
    }

    func removeGood(index: Int) {
        removeProducts = goods[index]
        if goods[index].price < 1000 {
            sum -= goods[index].price
        }

    }

    func addGood(index: Int) {
        addProducts = goods[index]
        if goods[index].price < 1000 {
            sum += goods[index].price
        }
    }

    func removeAll() {
        Products.removeAll()
        sum = 100
    }
}
