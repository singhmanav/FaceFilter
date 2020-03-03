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
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    var collectionView: UICollectionView!
    enum SectionKind: Int, CaseIterable {
        case image
    }
    var snapshot = NSDiffableDataSourceSnapshot<Int, Model>()
    var dataSource: UICollectionViewDiffableDataSource<Int, Model>! = nil
    private lazy var imagePicker: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = #imageLiteral(resourceName: "photo")
        configureHierarchy()
        configureDataSource()
        updateDataSource()
    }
    
    @IBAction func add(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
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
        dataSource = UICollectionViewDiffableDataSource<Int, Model>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: Model) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell
                else { fatalError("Cannot create new cell") }
            cell.image = model.image
            cell.title = model.filter
            return cell
        }
    }
    
    func updateDataSource() {
        snapshot.appendSections([0])
        ImageFilter.allCases.forEach { (identifier) in
            identifier.performFilter(with: self.image, completion: { [unowned self] (image) in
                DispatchQueue.main.async {
                    self.snapshot.appendItems([Model(image: image, filter: identifier.rawValue)])
                    self.dataSource.apply(self.snapshot, animatingDifferences: true)
                }
            })
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        image = (collectionView.cellForItem(at: indexPath) as? ImageCell)?.image
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            self.snapshot.deleteAllItems()
            updateDataSource()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

