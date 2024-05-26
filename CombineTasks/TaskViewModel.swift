//
//  TaskViewModel.swift
//  CombineTasks
//
//  Created by Руслан Абрамов on 26.05.2024.
//

import UIKit
import Combine
import SwiftUI

enum ViewState<Model> {
    case loading
    case data
    case error(_ error: Error)
}

struct EpisodeDto: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [URL]
    var imageData: Data?
    var charName: String?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case id
        case name
        case episode
        case characters
    }
}

struct CharacterDto: Decodable {
    let id: Int
    let name: String
    let image: URL
}

struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    var message = "try again later"
}

final class TaskViewModel: ObservableObject {
    @Published var state: ViewState<[EpisodeDto]> = .loading
    @Published var alertError: ErrorForAlert?
    @Published var dataToView: [EpisodeDto] = []
    var alertText = CurrentValueSubject<String, Never>("")
    var showErrorAlert = CurrentValueSubject<Bool, Never>(false)
    var showPortal = CurrentValueSubject<Bool, Never>(false)

    var cancellables: Set<AnyCancellable> = []

    init() {
        state = .loading
        showPortal.value.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.linear(duration: 2).delay(0.3)) {
                self.showPortal.value.toggle()
                self.fetch()
                self.state = .data
            }
        }

        showErrorAlert
            .sink { value in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    func fetch() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode/[1,2,3,4,5,6,7,8,9,10]") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [EpisodeDto].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.alertText.value = error.localizedDescription
                    withAnimation(.linear(duration: 3)) {
                        self.showErrorAlert.value = true
                    }
                    self.state = .error(error)
                }
            } receiveValue: { [unowned self] episodes in
                dataToView = episodes
            }
            .store(in: &cancellables)
    }

    func fetchCharacters() {
        for (index, episode) in dataToView.enumerated() {
            guard let urlString = episode.characters.randomElement()?.absoluteString,
                  let url = URL(string: urlString) else {
                continue
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: CharacterDto.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.alertText.value = error.localizedDescription
                    }
                } receiveValue: { [unowned self] character in
                    dataToView[index].charName = character.name
                    fetchImages(url: character.image) { [unowned self] imageData in
                        self.dataToView[index].imageData = imageData
                    }
                }
                .store(in: &cancellables)
        }
    }

    func fetchImages(url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard UIImage(data: data) != nil else {
                    return nil
                }
                return data
            }
            .receive(on: RunLoop.main)
            .replaceError(with: nil)
            .sink { image in
                completion(image)
            }
            .store(in: &cancellables)
    }
}
