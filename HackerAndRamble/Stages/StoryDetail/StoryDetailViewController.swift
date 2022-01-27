//
//  StoryDetailViewController.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import UIKit
import SafariServices
import SwiftUI

class StoryDetailViewController: UIViewController {
    @Injected var viewModel: StoryDetailViewModelProtocol
    var hackerNewsId: Int!

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: storyDetailCellReuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        viewModel.items.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.getStoryDetail(with: hackerNewsId)
    }

    private func createCommentTitle(
        with comment: Item,
        attributes: [NSAttributedString.Key : Any] = [:]) -> NSAttributedString {
            let fullString = NSMutableAttributedString(string: "")

            if let user = comment.user {
                let arrowUpImageAttachment = NSTextAttachment()
                arrowUpImageAttachment.image = UIImage(systemName: "person")
                fullString.append(NSAttributedString(attachment: arrowUpImageAttachment))
                fullString.append(NSAttributedString(string: " \(user)    "))
            }

            let timeAgoImageAttachment = NSTextAttachment()
            timeAgoImageAttachment.image = UIImage(systemName: "clock.arrow.circlepath")
            fullString.append(NSAttributedString(attachment: timeAgoImageAttachment))
            fullString.append(NSAttributedString(string: " \(comment.timeAgo) "))

            fullString.addAttributes(attributes, range: NSMakeRange(0, fullString.length))
            return fullString
    }

    private func createCommentText(
        with comment: Item,
        attributes: [NSAttributedString.Key : Any] = [:]) -> NSAttributedString {

            var detailtext = NSMutableAttributedString(string: "")
            let content = comment.content ?? (comment.url ?? "")
            let data = Data(content.utf8)
            if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                detailtext = attributedString
            }

            detailtext.addAttributes(attributes, range: NSMakeRange(0, detailtext.length))
            return detailtext
    }
}

// MARK: UITableViewDelegate

extension StoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: false)
        }

        guard indexPath.row == 0 else { return }

        let rootItem = viewModel.items.value[indexPath.row]

        if rootItem.domain != nil,
            let url = URL(string: rootItem.url ?? "") {
            let config = SFSafariViewController.Configuration()
            let safariViewController = SFSafariViewController(url: url, configuration: config)
            present(safariViewController, animated: true)
        }
    }
}

// MARK: UITableViewDataSource

extension StoryDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyDetailCellReuseIdentifier, for: indexPath)
        let comment = viewModel.items.value[indexPath.row]

        let indent: Double = Double(comment.level ?? 0) * 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = indent
        paragraphStyle.firstLineHeadIndent = indent

        let attributedText = createCommentTitle(
            with: comment,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        let secondaryAttributedText = createCommentText(
            with: comment,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.attributedText = attributedText
            config.secondaryAttributedText = secondaryAttributedText
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.attributedText = attributedText
            cell.detailTextLabel?.attributedText = secondaryAttributedText
        }

        return cell
    }
}

// MARK: - UI Preview

struct StoryDetailViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let view = StoryDetailViewController()
            view.hackerNewsId = 19087418
            return view
        }
        .previewDevice("iPhone 12 Pro")
        .previewDisplayName("iPhone 12 Pro")
    }
}
