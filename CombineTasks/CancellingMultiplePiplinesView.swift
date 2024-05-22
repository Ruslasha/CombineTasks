//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI
import Combine

struct CancellingMultiplePiplinesView: View {

@StateObject private var viewModel = CancellingMultiplePipelinesViewModel()

    var body: some View {
        Group {
            HStack {
                TextField("Имя", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.firstNameValidation)
            }
            HStack {
                TextField("Фамилия", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.lastNameValidation)
            }
        }
        .padding()

        Button("Отменить все проверки") {
            viewModel.cancellAllValidation()
        }
    }
}

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""

    private var validationCancellable: Set<AnyCancellable> = []

    init() {
        $firstName
            .map { $0.isEmpty ? "-" : "+"}
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellable)

        $lastName
            .map { $0.isEmpty ? "-" : "+"}
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellable)
    }

    func cancellAllValidation() {
        firstNameValidation = ""
        lastNameValidation = ""
        validationCancellable.removeAll()
    }
}

#Preview {
    CancellingMultiplePiplinesView()
}
