//
//  CustomTabItemView.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import UIKit
import SnapKit

class CustomTabItemView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    init(frame: CGRect, labelText: String) {
        super.init(frame: frame)
        titleLabel.text = labelText
        setupUI()
        inactive()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(lineView.snp.centerX)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
        }
    }
    
    func active() {
        titleLabel.textColor = .purple
        lineView.isHidden = false
    }
    
    func inactive() {
        titleLabel.textColor = .lightGray
        lineView.isHidden = true
    }

}
