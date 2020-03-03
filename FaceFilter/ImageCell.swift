//
//  CollectionViewCell.swift
//  FaceFilter
//
//  Created by Manav on 03/03/20.
//  Copyright © 2020 Manav. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = imageContentMode
        return imageView
    }()
    
    private var heading: UILabel = {
        let heading = UILabel()
        return heading
    }()
    
    var title: String? = .init() {
        didSet {
            heading.text = title
        }
    }
    
    var imageContentMode: UIImageView.ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageContentMode
        }
    }
    
    var image: UIImage? = .init() {
        didSet {
            imageView.image = image
        }
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = !isSelected ? UIColor.lightText.cgColor : UIColor.link.cgColor
        }
    }

    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageCell {
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(heading)
        imageContentMode = .scaleAspectFill
        heading.textColor = .darkText
        heading.numberOfLines = 1
        heading.minimumScaleFactor = 0.5
        heading.textAlignment = .center
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.lightText.cgColor
        heading.adjustsFontSizeToFitWidth = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        let inset: CGFloat = 0.0
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            heading.heightAnchor.constraint(equalToConstant: 30),
            heading.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            heading.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            heading.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
            ])
    }
}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
