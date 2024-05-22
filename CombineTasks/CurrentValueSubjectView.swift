//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI
import Combine

struct CurrentValueSubjectView: View {

    @StateObject private var viewModel = CurrentValueSubjectViewModel()

    var body: some View {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Два раза выбрали" : "") \(viewModel.selection.value)")
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
                .padding()
            Button("Выбрать колу") {
                viewModel.selection.value = "Cola"
            }
            .padding()

            Button("Выбрать бургер") {
                viewModel.selection.value = "бургер"
            }
            .padding()
        }
    }
}

class CurrentValueSubjectViewModel: ObservableObject {

    var selection = CurrentValueSubject<String, Never>("Корзина пуста")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)

    var cancellable: Set<AnyCancellable> = []

    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

#Preview {
    CurrentValueSubjectView()
}
