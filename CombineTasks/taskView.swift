//
//  taskView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 23.05.2024.
//

import Combine
import SwiftUI

struct taskView: View {
    @ObservedObject private var viewModel = TaskViewModel()

    var body: some View {
        VStack {
            TextField("Введите строку", text: $viewModel.inputText.value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Button("Добавить") {
                    viewModel.addText()
                }
                .disabled(viewModel.isHiddenButton.value)
                Spacer()
                    .frame(width: 50)
                Button("Очистить список") {
                    viewModel.removeAll()
                }.tint(.blue)
            }
            .frame(height: 70)

            List(viewModel.rows, id: \.self) { item in
                Text(item)
            }.font(.title)
        }
        .padding()
    }
}

#Preview {
    taskView()
}
