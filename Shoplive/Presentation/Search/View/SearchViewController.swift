//
//  SearchViewController.swift
//  Shoplive
//
//  Created by Terry Koo on 11/14/23.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchViewController: UIViewController {
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
        guard let searchViewModel else { return }
        
        searchViewModel.characterCollectionDatas.observe(on: self) { [weak self] data in
            guard let self else { return }
            
            characterCardCollectionView.reloadData()
        }
        
        searchViewModel.isFetching.observe(on: self) { [weak self] isFetching in
            guard let self else { return }
            
            if isFetching {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
    
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
        
        searchBar.delegate = self
        
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(characterCardCollectionView)
        
        characterCardCollectionView.delegate = self
        characterCardCollectionView.dataSource = self
        
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

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel?.searchTextDidChange(searchText)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let searchViewModel else { return 0 }
        
        return searchViewModel.getCharacterCollectionDataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCardCollectionViewCell.identifier, for: indexPath) as! CharacterCardCollectionViewCell
        
        guard let searchViewModel else { return cell }
        
        let characterData = searchViewModel.getCharacterData(index: indexPath.row)
        cell.setData(characterData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchViewModel?.selectFavoriteCharacter(index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 200
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if contentOffsetY > contentHeight - scrollViewHeight - threshold {
            if searchBar.text?.isEmpty ?? true {
                searchViewModel?.getCharaterCollections()
            } else {
                searchViewModel?.searchCharacter(searchBar.text!)
            }
        }
    }
    
}

