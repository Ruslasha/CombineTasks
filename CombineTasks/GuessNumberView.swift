//
//  GuessNumberView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 22.05.2024.
//

import SwiftUI

struct GuessNumberView: View {
    @StateObject var viewModel = GuessNumberViewModel()

    var body: some View {
        VStack {
            TextField("Введите число от 1 до 100", text: Binding(get: {
                "\(viewModel.selection.value)"
            }, set: { value in
                viewModel.selection.value = Int(value) ?? 0
            }))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            Text("\(viewModel.selectionNumber.value)")
                .opacity(viewModel.isShowNumber ? 1 : 0)
            Text("\(viewModel.message.value)")
                .padding()

            Button {

                viewModel.cancel()
            } label: {
                Text("Завершить игру")
            }
        }
    }

}
#Preview {
    GuessNumberView()
}
