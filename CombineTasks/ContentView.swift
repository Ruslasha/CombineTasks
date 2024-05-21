//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI
import Combine

struct FirstPipelineView: View {

    @StateObject var viewModel = FirstPipelineViewModel()


    var body: some View {
        VStack {
            HStack {
                TextField("Ваше имя", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.validationName)
            }
            .padding()

            HStack {
                TextField("Ваша фамилия", text: $viewModel.surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.validationSurname)
            }
            .padding()
        }
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var validationName = ""
    @Published var validationSurname = ""

    init() {
        $name
            .map { $0.isEmpty ? "-" : "+" }
            .assign(to: &$validationName)
        $surname
            .map { $0.isEmpty ? "-" : "+" }
            .assign(to: &$validationSurname)
    }
}

#Preview {
    FirstPipelineView()
}
