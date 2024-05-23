//
//  taskView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 23.05.2024.
//

import SwiftUI
import Combine

struct TaskView: View {
    @StateObject var viewModel = TaskViewModel()
    var body: some View {
        VStack {
            TextField("Введите число", text: $viewModel.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            HStack {
                Button("Добавить") {
                    viewModel.save()
                }
                Spacer()
                    .frame(width: 50)

                Button("Очистить список") {
                    viewModel.removeAll()
                }
            }
            if let error = viewModel.error?.rawValue {
                Text(error)
                    .font(.title3)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
            }
            List(viewModel.items, id: \.self){ item in
            Text("\(item)")
            }
        }

    }
}

#Preview {
    TaskView()
}
