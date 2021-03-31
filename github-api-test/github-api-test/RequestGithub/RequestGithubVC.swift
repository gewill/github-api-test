//
//  ViewController.swift
//  github-api-test
//
//  Created by Will on 31/03/2021.
//

import UIKit

/// request github page
final class RequestGithubVC: UIViewController {
    // MARK: - outlets

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var responseTextView: UITextView!

    // MARK: - properties

    private var viewModel = RequestGithubViewModel()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.didUpdate = { [weak self] in
            guard let `self` = self else { return }
            if let github = self.viewModel.githubs.first {
                self.dateLabel.text = "Last response update date:\n" + github.createAt.description
                self.responseTextView.text = github.content
            } else {
                self.dateLabel.text = "No response"
                self.responseTextView.text = nil
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.didUpdate = nil
    }

    // MARK: - private methods

    private func setupUI() {
  
        [dateLabel, responseTextView].forEach {
            $0?.layer.cornerRadius = 4
            $0?.clipsToBounds = true
        }

        dateLabel.text = nil
        responseTextView.text = nil
    }
}
