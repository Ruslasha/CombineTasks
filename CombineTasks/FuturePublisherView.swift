//
//  ContentView.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 20.05.2024.
//

import SwiftUI
import Combine

struct FuturePublisherView: View {

    @StateObject var viewModel = FuturePublisherViewModel()
    var body: some View {
        VStack {
            Text(viewModel.firstResult)

            Button("Запуск") {
                viewModel.runAgain()
            }

            Text(viewModel.secondResult)
        }
        .padding()
        .onAppear {
            viewModel.fetch()
        }
    }
}

class FuturePublisherViewModel: ObservableObject {
    @Published var firstResult = ""
    @Published var secondResult = ""

    var cancellable: AnyCancellable?

    let futurePublisher = Deferred {
        Future<String, Never> { promise in
            promise(.success("future Publisher сработал"))
            print("future Publisher сработал")
        }
    }

    func createFetch(url: URL) -> AnyPublisher<String?, Error> {

        Future { promise in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                promise(.success(response?.url?.absoluteString ?? ""))
            }

            task.resume()
        }
        .eraseToAnyPublisher()
    }

    func fetch() {
        guard let url = URL(string: "https://google.com") else { return }

        cancellable = createFetch(url: url)
            .receive(on: RunLoop.main)
            .sink { comlition in
                print(comlition)
            } receiveValue: { [unowned self] value in
                firstResult = value ?? ""
            }
    }

    func runAgain() {
        futurePublisher
            .assign(to: &$secondResult)
    }

}

#Preview {
    FuturePublisherView()
}
