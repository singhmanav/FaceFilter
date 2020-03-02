//
//  ViewController.swift
//  FaceFilter
//
//  Created by Manav on 03/03/20.
//  Copyright © 2020 Manav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var image: UIImage!
    
    enum SectionKind: Int, CaseIterable {
        case image
    }
    var dataSource: UICollectionViewDiffableDataSource<Int, ImageFilter>! = nil
    
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
                widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)))
            
            
            let orthogonallyScrolls = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            let containerGroupFractionalWidth = CGFloat(0.85)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupFractionalWidth),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = orthogonallyScrolls
            
            return section
            
        }, configuration: config)
        return layout
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, ImageFilter>(collectionView: collectionView) {
            [unowned self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: ImageFilter) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
                else { fatalError("Cannot create new cell") }
            
            // Populate the cell with our item description.
           
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            identifier.performFilter(with: self.image, completion: { (image) in
                cell.imageView.image = image
            })
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageFilter>()
        snapshot.appendSections([0])
        snapshot.appendItems([ImageFilter.allCases[3]])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

