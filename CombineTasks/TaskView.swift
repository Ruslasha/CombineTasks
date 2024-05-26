//
//  TaskView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 26.05.2024.
//

import SwiftUI

struct TaskView: View {
    @StateObject private var viewModel = TaskViewModel()
    var body: some View {
        VStack{
            TextField("Введите число", text: $viewModel.textField)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Проверить простоту числа"){
                viewModel.fetch()
            }
            .padding()
            Text(viewModel.result)
                .foregroundStyle(.green)
        }
        .padding()
    }
}

#Preview {
    TaskView()
}
