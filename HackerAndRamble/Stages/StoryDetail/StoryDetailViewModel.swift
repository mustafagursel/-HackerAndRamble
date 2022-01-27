//
//  StoryDetailViewModel.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

protocol StoryDetailViewModelProtocol {
    var items: Observable<[Item]> { get set }

    func getStoryDetail(with hackerNewsId: Int)
}

class StoryDetailViewModel: StoryDetailViewModelProtocol {
    var items: Observable<[Item]> = Observable([])
    @Injected var hackerNewsStore: HackerNewsStoreProtocol

    func getStoryDetail(with hackerNewsId: Int) {
        hackerNewsStore.getItem(hackerNewsId) { [weak self] result in
            switch result {
            case .success(let item):
                guard let self = self else { return }
                self.items.value = self.flattenItemTree(item)
            case .failure(let error):
                // inform user
                log(error.localizedDescription)
            }
        }
    }

    func flattenItemTree(_ item: Item) -> [Item] {
        var result: [Item] = []
        var stack: [Item] = [item]

        while stack.isEmpty == false {
            let current = stack.removeLast()
            result.append(current)

            for item in current.comments.reversed() {
                stack.append(item)
            }
        }

        return result
    }
}
