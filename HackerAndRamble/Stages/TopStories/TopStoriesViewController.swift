//
//  TopStoriesViewController.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit
import SafariServices
import SwiftUI

protocol TopStoriesViewControllerDelegate {
    func didStoryDetailRequested(with hackerNewsId: Int)
}

class TopStoriesViewController: UIViewController {
    @Injected var viewModel: TopStoriesViewModelProtocol
    var delegate: TopStoriesViewControllerDelegate?

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: topStoriesCellReuseIdentifier)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        view.delegate = self
        view.dataSource = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Top Stories"

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        viewModel.stories.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.getStories()
    }

    private func createSecondaryText(with story: FeedItem?) -> NSAttributedString {
        guard let story = story else {
            return NSAttributedString(string: "")
        }

        let fullString = NSMutableAttributedString(string: "")

        let arrowUpImageAttachment = NSTextAttachment()
        arrowUpImageAttachment.image = UIImage(systemName: "arrow.up")
        fullString.append(NSAttributedString(attachment: arrowUpImageAttachment))
        fullString.append(NSAttributedString(string: " \(story.points ?? 0)    "))

        let commentImageAttachment = NSTextAttachment()
        commentImageAttachment.image = UIImage(systemName: "bubble.right")
        fullString.append(NSAttributedString(attachment: commentImageAttachment))
        fullString.append(NSAttributedString(string: " \(story.commentsCount)    "))

        if let domain = story.domain {
            let linkImageAttachment = NSTextAttachment()
            linkImageAttachment.image = UIImage(systemName: "link")
            fullString.append(NSAttributedString(attachment: linkImageAttachment))
            fullString.append(NSAttributedString(string: " \(domain)"))
        }

        return fullString
    }
}

// MARK: UITableViewDelegate

extension TopStoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = viewModel.stories.value[indexPath.row]
        if story.domain != nil,
            let url = URL(string: story.url ?? "") {
            let config = SFSafariViewController.Configuration()
            let safariViewController = SFSafariViewController(url: url, configuration: config)
            present(safariViewController, animated: true)
        } else {
            delegate?.didStoryDetailRequested(with: story.id)
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let story = viewModel.stories.value[indexPath.row]
        delegate?.didStoryDetailRequested(with: story.id)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.stories.value.count - indexPath.row < getMoreStoriesTriggerCount {
            viewModel.getMoreStories()
        }
    }
}

// MARK: UITableViewDataSource

extension TopStoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: topStoriesCellReuseIdentifier, for: indexPath)
        let story = viewModel.stories.value[indexPath.row]

        if story.domain != nil {
            cell.accessoryType = .detailButton
        } else {
            cell.accessoryType = .none
        }

        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = story.title
            config.secondaryAttributedText = createSecondaryText(with: story)
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = story.title
            cell.detailTextLabel?.attributedText = createSecondaryText(with: story)
        }

        return cell
    }
}

// MARK: - UI Preview

struct TopStoriesViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            return TopStoriesViewController()
        }
        .previewDevice("iPhone 12 Pro")
        .previewDisplayName("iPhone 12 Pro")
    }
}
