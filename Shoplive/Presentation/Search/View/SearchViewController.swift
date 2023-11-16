//
//  SearchViewController.swift
//  Shoplive
//
//  Created by Terry Koo on 11/14/23.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewController: UIViewController {
    var searchViewModel: SearchViewModel?
    
    private let characterCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let padding = (width - (width / 2.2) * 2) / 3
        
        layout.itemSize = CGSize(width: width / 2.2, height: height / 3)
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: 10, right: padding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCardCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCardCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "마블 영웅 이름을 검색하시오."
        searchBar.returnKeyType = .done
        return searchBar
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayout()
        
        bind()
    }
    
    private func bind() {
}

// UI
extension SearchViewController {
    private func setupViewsAndLayout() {
        view.backgroundColor = .white
        setupSearchBarView()
        setupCollectionView()
        setupDismissKeyboard()
    }
    
    private func setupSearchBarView() {
        view.addSubview(searchBar)
        
        
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(characterCardCollectionView)
        
        
        characterCardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func showLoading() {
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
