import UIKit
import Combine

extension Notification.Name {
    static let event = Notification.Name("signal")
}

struct People {
    let name: String
}

let nameLabel = UILabel()

let namePublisher = NotificationCenter.Publisher(center: .default, name: .event).map {
    ($0.object as? People)?.name
}

let nameSubscriber = Subscribers.Assign(object: nameLabel, keyPath: \.text)

namePublisher.subscribe(nameSubscriber)

let people = People(name: "Jack")

NotificationCenter.default.post(name: .event, object: people)

print(String(describing: nameLabel.text))
