//
//  Model.swift
//  QuNews
//
//  Created by Никита Ничепорук on 9/30/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation

struct ApiResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
}

struct Source: Codable {
    let name: String
}
