//
//  FeedImageViewModel+PrototypeData.swift
//  Prototype
//
//  Created by Cristian Felipe Patiño Rojas on 10/4/25.
//

extension FeedImageViewModel {
    static var prototypeFeed: [FeedImageViewModel] {
        return [
            FeedImageViewModel(
                description: "Golden hour hitting the rooftops of Barcelona — orange light, long shadows, and that calm before the night takes over.",
                location: "Barcelona, Spain",
                imageName: "image-0"
            ),
            FeedImageViewModel(
                description: "Silence.",
                location: "Kyoto\nJapan",
                imageName: "image-1"
            ),
            FeedImageViewModel(
                description: nil,
                location: "San Francisco, USA",
                imageName: "image-2"
            ),
            FeedImageViewModel(
                description: "Layers of mist rolling over mountain ridges, snow barely visible under the soft light of sunrise. The air is cold but the view makes you forget your fingertips.",
                location: "Banff National Park\nCanada",
                imageName: "image-3"
            ),
            FeedImageViewModel(
                description: "Books scattered across a wooden table. Coffee stains on old notebooks. Background jazz. A Sunday morning where nothing moves fast — and everything is perfect.",
                location: "Amsterdam, Netherlands",
                imageName: "image-4"
            ),
            FeedImageViewModel(
                description: "Endless sea, salty wind, and the sound of waves crashing like a heartbeat. If you sit quietly enough, the horizon starts to whisper back.",
                location: "Santorini\nGreece",
                imageName: "image-5"
            ),
            FeedImageViewModel(
                description: nil,
                location: nil,
                imageName: "image-0"
            ),
            FeedImageViewModel(
                description: "One step, two. Breath fogs in the cold air. Stone streets echo under leather soles. Lisbon wakes slowly.",
                location: "Lisbon\nPortugal",
                imageName: "image-1"
            ),
            FeedImageViewModel(
                description: "This one is intentionally long to test how far a UILabel can stretch in a self-sizing UITableViewCell without breaking layout or overflowing constraints. The purpose is to simulate real-world scenarios where user-generated content might push the UI to its limits. Think testimonials, posts, or freeform descriptions. If this description wraps to approximately six lines, we’ll know our layout is solid and resilient. If not... well, we’ll see constraints crash and burn in the console logs like fallen soldiers of Interface Builder.",
                location: "New York\nUSA",
                imageName: "image-2"
            ),
            FeedImageViewModel(
                description: "In the quiet of a snowy morning, a bicycle leaned against a café wall. The scent of roasted coffee sneaked out through the door as locals shuffled in with scarves and sleepy smiles. Somewhere, a dog barked. Somewhere else, someone opened a notebook and began to write.",
                location: nil,
                imageName: "image-3"
            )
        ]
    }
}
