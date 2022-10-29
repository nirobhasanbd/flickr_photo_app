//
//  ViewController.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/25/22.
//

import UIKit
import Lightbox

class PhotoSearchViewController: BaseViewController, Alertable {
    
    enum Section {
        case main
    }
    
    private lazy var photoCollectionView: UICollectionView = {
        let collectionV = UIView.createCollectionView(delegate: self, dataSource: nil)
        collectionV.collectionViewLayout = FlickrSearchFlowLayout()
        collectionV.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: PhotoGalleryCell.cellIdentifier)
        collectionV.backgroundColor = .clear
        collectionV.isScrollEnabled = true
        collectionV.showsVerticalScrollIndicator = false
        collectionV.showsHorizontalScrollIndicator = false
        return collectionV
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchB = UISearchBar()
        searchB.delegate = self
        searchB.backgroundColor = .background
        searchB.barTintColor = .background
        searchB.setBackgroundImage(UIImage(named: AppImages.transparent.rawValue), for: .any, barMetrics: .default)
        //(searchB.value(forKey: "searchField") as? UITextField)?.backgroundColor = .background
        searchB.placeholder = "Search photos"
        searchB.translatesAutoresizingMaskIntoConstraints = false
        return searchB
    }()
    
    var refreshController = UIRefreshControl()
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PhotoModel>
    
    private lazy var dataSource = makeDataSource()
    private var viewModel = PhotoSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setupRefreshController()
        setupLayout()
        loadServerData()
    }
    
    deinit {
        print("deinit search vc")
    }
    
    private func addSubViews() {
        setupNavBar(title: .translate_id_0005)
        
        [searchBar, photoCollectionView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func setupRefreshController() {
        photoCollectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2.s)
            make.trailing.equalToSuperview().offset(-2.s)
            make.top.equalToSuperview().offset(navBarHeight)
            make.height.equalTo(40.s)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2.s)
            make.trailing.equalToSuperview().offset(-2.s)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    private func loadServerData() {
        self.showHUD()
        viewModel.searchPhoto {[weak self] message, error in
            self?.hideHUD()
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.applySnapshot(animatingDifferences: false)
            }
        }
    }
    
    @objc func handleRefresh() {
        print("handle refresh")
        viewModel.searchPhoto {[weak self] message, error in
            self?.refreshController.endRefreshing()
            if let error = error {
                self?.showAlert(message: error)
            } else {
                self?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    // MARK: - DataSource
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: photoCollectionView, cellProvider: { (collectionView, indexPath, photoModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.cellIdentifier, for: indexPath) as? PhotoGalleryCell else {
                fatalError("PhotoGalleryCell is not initialized properly")
            }
            cell.setupCell(indexPath: indexPath, photoModel: photoModel)
            return cell
        })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.photoModels)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate {
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

extension PhotoSearchViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        guard distanceFromBottom < height else { return }
        
        if !viewModel.apiCalling {
            viewModel.apiCalling = true
            showHUD()
            viewModel.loadMorePhoto {[weak self] message, error in
                self?.viewModel.apiCalling = false
                self?.hideHUD()
                if let error = error {
                    self?.showAlert(message: error)
                } else {
                    self?.applySnapshot(animatingDifferences: true)
                }
            }
        }
    }
}

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadServerData()
        photoCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
}

