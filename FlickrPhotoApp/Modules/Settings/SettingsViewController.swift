//
//  SettingsViewController.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/27/22.
//

import UIKit
import SnapKit

class SettingsViewController: BaseViewController {
    
    private let testLbl: UILabel = {
        let lbl = UIView.createLabel(text: .translate_id_0001)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar(title: .translate_id_0003, backButtonClicked: {[weak self] in
            print("back button clicked")
            self?.navigationController?.popViewController(animated: true)
        })
        self.view.addSubview(testLbl)
        
        testLbl.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(self.navBarHeight)
        }
        
    }
    
    deinit {
        print("deinit settings vc")
    }

}
