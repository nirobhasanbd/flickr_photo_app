//
//  CustomTabBarController.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/25/22.
//

import UIKit


/**It's an enum for identify bottom tab items*/
enum TabItemType {
    case recent_icon
    case search_icon
    case settings_icon
    
    /**
     *Return Image for normal tab when not selected
     */
    var image: UIImage? {
        switch self {
        case .recent_icon: do {return UIImage.init(named: AppImages.tab_recent.rawValue)}
        case .search_icon: do {return UIImage.init(named: AppImages.tab_search.rawValue)}
        case .settings_icon: do {return UIImage.init(named: AppImages.tab_settings.rawValue)}
        }
    }
    
    /**Return title of the tab that will show at tab bottom*/
    var title: String {
        switch self {
        case .recent_icon: do {return AppTexts.translate_id_0001.rawValue.tr}
        case .search_icon: do {return AppTexts.translate_id_0002.rawValue.tr}
        case .settings_icon: do {return AppTexts.translate_id_0003.rawValue.tr}
        }
    }
    
    var tag: Int {
        switch self {
        case .recent_icon: do {return 0}
        case .search_icon: do {return 1}
        case .settings_icon: do {return 2}
        }
    }
}

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var recentPhotoVC: RecentPhotoViewController!
    private var searchVC: PhotoSearchViewController!
    private var settingsVC: SettingsViewController!
    
    private var isLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
       
        UITabBar.appearance().tintColor = .blueText
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blueText], for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    public func setupTabBar() {
        
        recentPhotoVC = RecentPhotoViewController()
        let recentPhotoNC = CustomNavigationController(rootViewController: recentPhotoVC)
        recentPhotoNC.navigationBar.isHidden = true
        recentPhotoNC.tabBarItem = createTabBarItem(.recent_icon)
        
        searchVC = PhotoSearchViewController()
        let searchNC = CustomNavigationController(rootViewController: searchVC)
        searchNC.navigationBar.isHidden = true
        searchNC.tabBarItem = createTabBarItem(.search_icon)
        
        settingsVC = SettingsViewController()
        let settingsNC = CustomNavigationController(rootViewController: settingsVC)
        settingsNC.navigationBar.isHidden = true
        settingsNC.tabBarItem = createTabBarItem(.settings_icon)
        
        viewControllers = [recentPhotoNC, searchNC, settingsNC]
        
        isLoaded = true
    }
    
    func createTabBarItem(_ type: TabItemType) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = type.title
        tabBarItem.image = type.image
        tabBarItem.tag = type.tag
        tabBarItem.selectedImage = type.image
        return tabBarItem
    }
    
    func setSelectedIndex(index: Int) {
        self.selectedIndex = index
    }
    
}
