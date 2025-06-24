//
//  Bundle+Extensions.swift
//  DemoApp
//
//  Created by Alexander on 23.06.25.
//

import Foundation

extension Bundle {
    static var unsplashAccessKey: String {
        Bundle.main.object(forInfoDictionaryKey: "UnsplashAccessKey") as? String ?? ""
    }
}
