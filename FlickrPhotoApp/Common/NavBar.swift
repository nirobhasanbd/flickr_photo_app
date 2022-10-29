//
//  NavBar.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/25/22.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit

typealias BackButtonClicked = () -> Void
typealias RightButtonClicked = () -> Void

final class NavBar: UIView {
    private var backButtonClicked: BackButtonClicked?
    private var rightButtonClicked: RightButtonClicked?
    
    private var rightButton: UIButton!
    private var titleLbl: UILabel!
    private var title: String!
    private var rightBtnImgName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String, rightBtnImgName: String? = nil, backButtonClicked: BackButtonClicked? = nil, rightButtonClicked: RightButtonClicked? = nil) {
        let frame = CGRect.zero
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .background
        
        self.backButtonClicked = backButtonClicked
        self.rightButtonClicked = rightButtonClicked
        
        self.title = title
        self.rightBtnImgName = rightBtnImgName
        
        setupUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let _ = backButtonClicked {
            let leftBtn = UIView.createButton(imageName: .arrowBack)
            leftBtn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
            self.addSubview(leftBtn)
            leftBtn.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20.s)
                make.centerY.equalToSuperview()
            }
        }
        
        if let rightBtnImgName = rightBtnImgName {
            rightButton = UIView.createButton(rightBtnImgName)
            rightButton.isHidden = true
            rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
            
            self.addSubview(rightButton)
            rightButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-20.s)
                make.centerY.equalToSuperview()
                make.height.equalTo(26.s)
                make.width.equalTo(26.s)
            }
            rightButton.round(radius: 13.s, borderColor: .white, borderWidth: 1.s)
        }
        
        titleLbl = UIView.createLabel(self.title)
        titleLbl.numberOfLines = 1
        titleLbl.textAlignment = .center
        titleLbl.font = .InterBold(ofSize: 16.sp)
        titleLbl.textColor = .whiteBlack
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(16.s)
        }
    }
    
    func updateTitle(title: AppTexts) {
        self.title = title.rawValue.tr
        titleLbl.text = self.title
    }
    
    @objc private func backButtonPressed(sender: UIButton) {
        self.backButtonClicked?()
    }
    
    @objc private func rightButtonPressed(sender: UIButton) {
        self.rightButtonClicked?()
    }
}
