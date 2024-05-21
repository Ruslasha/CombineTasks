//
//  TaxiView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 21.05.2024.
//

//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI
import Combine

struct TaxiView: View {

    @StateObject var viewModel = TaxiViewModel()


    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundStyle(.green)
            Text(viewModel.status)
                .foregroundStyle(.blue)
            Spacer()
            Button {
                viewModel.cancel()
            } label: {
                Text("Отменить подписку")
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 20)

            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Ищем машину..." ? 1.0 : 0.0)

            Button {
                viewModel.refresh()
            } label: {
                Text("Вызвать такси")
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

            }
            .background(.gray)
            .cornerRadius(8)
            .padding()
        }
    }
}

class TaxiViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""

    private var cancallable: AnyCancellable?

    init() {
        cancallable = $data
            .map { [unowned self] value -> String in
                status = "Ищем машину..."
                return value
            }
            .delay(for: 7, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                self.data = "Водитель будет через 10 мин"
                self.status = "Машина найдета"
            }
    }

    func refresh() {
        data = "Повторный вызов"
    }

    func cancel() {
        status = "Операция отменена"
        cancallable?.cancel()
        cancallable = nil
    }
}

#Preview {
    TaxiView()
}

