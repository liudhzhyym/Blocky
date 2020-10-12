//
//  CardValueTextView.swift
//  Blocky
//
//  Created by Max Chuquimia on 11/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit
import Combine

class CardValueTextView: UITextView {

    override var text: String! {
        didSet {
            updatePlaceholderDisplay()
        }
    }

    let placeholderLabel: UILabel = make {
        $0.font = Font.placeholder
        $0.textColor = Color.placeholder
    }

    private let line: UIView = make {
        $0.backgroundColor = Color.soaring
    }

    private var cancellables: [AnyCancellable] = []

    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
        bind()
    }

    required init?(coder: NSCoder) { die() }

    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0.5)
    }

}

private extension CardValueTextView {

    func setup() {
        isScrollEnabled = false
        contentInset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        font = Font.cardProperty
        textColor = Color.cove
        autocorrectionType = .no
        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.required, for: .vertical)
        addSubview(placeholderLabel)
        addSubview(line)

        NSLayoutConstraint.activate(
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            heightAnchor.constraint(greaterThanOrEqualTo: placeholderLabel.heightAnchor)
        )
    }

    func bind() {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .sink { [weak self] _ in
                self?.updatePlaceholderDisplay()
            }
            .store(in: &cancellables)
    }

    func updatePlaceholderDisplay() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
