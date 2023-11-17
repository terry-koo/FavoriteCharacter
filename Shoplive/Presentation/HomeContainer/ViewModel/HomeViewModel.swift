//
//  HomeViewModel.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

struct HomeViewModel {
    var currentPage: Observable<Page> = Observable(.search)
    var error: Observable<APIError?> = Observable(nil)
}
