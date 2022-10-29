//
//  PhotoGalleryCell.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/25/22.
//

import UIKit
import SnapKit
import SDWebImage

class PhotoGalleryCell: UICollectionViewCell {
    
    private let photoView: UIImageView = {
        let imageView = UIView.createImageView(imageName: .transparent)
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return imageView
    }()
    
    private var photoModel: PhotoModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        [photoView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        photoView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func setupCell(indexPath: IndexPath, photoModel: PhotoModel) {
        self.photoModel = photoModel
        photoView.sd_setImage(with: photoModel.url, placeholderImage: UIImage(named: AppImages.transparent.rawValue))
    }
}
