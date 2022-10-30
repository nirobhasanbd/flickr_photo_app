//
//  RecentPhotoViewController.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/27/22.
//

import UIKit
import SnapKit
import Lightbox

class RecentPhotoViewController: BaseViewController, Alertable {
    
    private lazy var photoCollectionView: UICollectionView = {
        let collectionV = UIView.createCollectionView(delegate: self, dataSource: self)
        collectionV.collectionViewLayout = FlickrSearchFlowLayout()
        collectionV.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: PhotoGalleryCell.cellIdentifier)
        collectionV.backgroundColor = .clear
        collectionV.isScrollEnabled = true
        collectionV.showsVerticalScrollIndicator = false
        collectionV.showsHorizontalScrollIndicator = false
        return collectionV
    }()
    
    var refreshController = UIRefreshControl()
    private var viewModel = RecentPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChangedNotification, object: nil)
        
        addSubViews()
        setupRefreshController()
        setupLayout()
        loadServerData()
    }
    
    deinit {
        print("deinit search vc")
        NotificationCenter.default.removeObserver(self, name: .languageChangedNotification, object: nil)
    }
    
    @objc func languageChanged(notification: NSNotification) {
        updateNavbarTitle(title: .translate_id_0004)
    }
    
    private func addSubViews() {
        setupNavBar(title: .translate_id_0004)
        
        [photoCollectionView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func setupRefreshController() {
        photoCollectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupLayout() {
        photoCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2.s)
            make.trailing.equalToSuperview().offset(-2.s)
            make.top.equalToSuperview().offset(navBarHeight)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    private func loadServerData() {
        self.showHUD()
        viewModel.getRecentPhoto {[weak self] message, error in
            self?.hideHUD()
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.photoCollectionView.reloadData()
            }
        }
    }
    
    @objc func handleRefresh() {
        print("handle refresh")
        viewModel.getRecentPhoto {[weak self] message, error in
            self?.refreshController.endRefreshing()
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.photoCollectionView.reloadData()
            }
        }
    }
}

extension RecentPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LightboxConfig.preload = 2
        let images: [LightboxImage] = viewModel.photoModels.compactMap { photoModel in
            guard let url = photoModel.url else { return nil}
            return LightboxImage(imageURL: url, text: photoModel.title ?? "")
        }
        
        let controller = LightboxController(images: images)
        // bellow two lines are important
        controller.dynamicBackground = true
        controller.dynamicBackground = false
        self.present(controller, animated: true)
        controller.goTo(indexPath.item, animated: false)
    }
}

extension RecentPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.cellIdentifier, for: indexPath) as? PhotoGalleryCell else {
            fatalError("PhotoGalleryCell is not initialized properly")
        }
        let photoModel = viewModel.photoModels[indexPath.item]
        cell.setupCell(indexPath: indexPath, photoModel: photoModel)
        return cell
    }
}

extension RecentPhotoViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        guard distanceFromBottom < height && viewModel.totalPages >= viewModel.page else { return }
        
        if !viewModel.apiCalling {
            viewModel.apiCalling = true
            showHUD()
            viewModel.loadMorePhoto {[weak self] message, error in
                self?.viewModel.apiCalling = false
                self?.hideHUD()
                if let error = error {
                    self?.showAlert(message: error)
                } else {
                    self?.photoCollectionView.reloadData()
                }
            }
        }
    }
}
