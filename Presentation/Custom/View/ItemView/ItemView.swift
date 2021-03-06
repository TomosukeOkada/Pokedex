//
//  ItemView.swift
//  Presentation
//
//  Created by Tomosuke Okada on 2021/02/11.
//

import Domain
import UIKit

protocol ItemViewDelegate: AnyObject {

    func didTapItemView(_ item: Item)
}

final class ItemView: XibLoadableView {

    @IBOutlet private weak var spriteImageView: UIImageView!

    @IBOutlet private weak var innerView: HoverView! {
        willSet {
            newValue.delegate = self
        }
    }

    @IBOutlet private weak var numberLabel: UILabel!

    @IBOutlet private weak var nameLabel: UILabel!

    private var item: Item?

    private weak var delegate: ItemViewDelegate?

    func setItem(_ item: Item, delegate: ItemViewDelegate?) {
        self.item = item
        self.delegate = delegate
        self.spriteImageView.loadImage(with: item.imageUrl)
        self.numberLabel.text = L10n.Common.number(item.number)
        self.nameLabel.text = item.name
    }

    func abbreviate() {
        let x: CGFloat = UIScreen.main.bounds.width * 0.375
        self.innerView.transform = .init(translationX: x, y: 0.0)
        self.innerView.alpha = 0.3
    }

    func expand() {
        self.innerView.transform = .identity
        self.innerView.alpha = 1.0
    }

    private func animateImage() {
        let keyframeTranslateY      = CAKeyframeAnimation(keyPath: "transform.translation.y")
        keyframeTranslateY.values   = [0.0, -5.0, 0,0, -2.5, 0.0]
        keyframeTranslateY.keyTimes = [0, 0.25, 0.4, 0.6, 1.0]
        keyframeTranslateY.duration = 0.2

        self.spriteImageView.layer.add(keyframeTranslateY, forKey: "jumping")
    }
}

extension ItemView: HoverViewDelegate {

    func didTouchDown() {
        self.animateImage()
    }

    func didTouchUpInside() {
        guard let item = self.item else {
            return
        }
        self.delegate?.didTapItemView(item)
    }
}
