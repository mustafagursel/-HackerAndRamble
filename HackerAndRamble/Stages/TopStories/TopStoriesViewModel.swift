//
//  TopStoriesViewModel.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

protocol TopStoriesViewModelProtocol {
    var stories: Observable<[FeedItem]> { get set }

    func getStories()
    func getMoreStories()
}

class TopStoriesViewModel: TopStoriesViewModelProtocol {
    var stories: Observable<[FeedItem]> = Observable([])
    @Injected var hackerNewsStore: HackerNewsStoreProtocol

    var page = 1

    func getStories() {
        hackerNewsStore.getNewsFeed(page) { [weak self] result in
            switch result {
            case .success(let stories):
                self?.stories.value = stories
            case .failure(let error):
                // inform user
                log(error.localizedDescription)
            }
        }
    }

    func getMoreStories() {
        page += 1
        guard page <= topStoriesMaxPage else { return }

        hackerNewsStore.getNewsFeed(page) { [weak self] result in
            switch result {
            case .success(let stories):
                self?.stories.value.append(contentsOf: stories)
            case .failure(let error):
                // inform user
                log(error.localizedDescription)
            }
        }
    }
}
