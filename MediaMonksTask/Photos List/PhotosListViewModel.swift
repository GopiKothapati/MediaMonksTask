//
//  PhotosListViewModel.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class PhotosListViewModel: CommonListViewModel<Photo>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let screenWidth = UIScreen.main.bounds.size.width

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photosCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseID.photosListCell.rawValue, for: indexPath) as? PhotosListCollectionViewCell else {
            return UICollectionViewCell()
        }
        photosCell.cellData = dataModels[indexPath.item]
        return photosCell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((screenWidth * 0.85) - 20) / 2, height: 250)
    }
}

