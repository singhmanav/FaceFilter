//
//  ViewController.swift
//  FaceFilter
//
//  Created by Manav on 03/03/20.
//  Copyright © 2020 Manav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    static let headerElementKind = "header-element-kind"
    
    @IBOutlet weak var container: UIView!
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    var collectionView: UICollectionView!
    enum SectionKind: Int, CaseIterable {
        case image
    }
    let imageCache = NSCache<NSString, UIImage>()
    var dataSource: UICollectionViewDiffableDataSource<Int, UIImage>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = #imageLiteral(resourceName: "photo")
        configureHierarchy()
        configureDataSource()
    }
}

extension ViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex:Int, layoutEnvironment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
            
        }, configuration: config)
        return layout
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: container.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isDirectionalLockEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        container.addSubview(collectionView)
        
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, UIImage>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, image: UIImage) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell
                else { fatalError("Cannot create new cell") }
            cell.image = image
            cell.imageContentMode = .scaleAspectFit
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage>()
        snapshot.appendSections([0])
        ImageFilter.allCases.forEach { (identifier) in
            identifier.performFilter(with: self.image, completion: { [unowned self] (image) in
                snapshot.appendItems([image])
                self.dataSource.apply(snapshot, animatingDifferences: false)
            })
        }
        
        
    }
    
    func getFilteredImage(imageFilter: ImageFilter, imageKey: String, completion:  @escaping (_ image: UIImage, _ imageKey: String) -> Void) {
        if let cachedImage = imageCache.object(forKey: imageKey as NSString) {
            completion(cachedImage, imageKey)
        }
        imageFilter.performFilter(with: self.image, completion: { (image) in
            self.imageCache.setObject(image, forKey: imageKey as NSString)
            completion(image, imageKey)
        })
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = (collectionView.cellForItem(at: indexPath) as? ImageCell)?.image
    }
}

