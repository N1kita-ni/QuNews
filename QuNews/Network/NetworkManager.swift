//
//  ApiCaller.swift
//  QuNews
//
//  Created by Никита Ничепорук on 9/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import UIKit
 
final class NetworkManager {
    static let shared = NetworkManager()
    private let newsURL = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d03a3d74ac3f4e79994072da491a0b98"
    private let searchURL = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d03a3d74ac3f4e79994072da491a0b98&q="
    private init() {}
    
    func getNews(onComplition: @escaping (Result<[Article], Error>) -> ()) {
        let remoteURL = URL(string: newsURL)
        guard let url = remoteURL else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                onComplition(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    onComplition(.success(result.articles))
                }
                catch {
                    onComplition(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func search(with text: String, onComplition: @escaping (Result<[Article], Error>) -> ()) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let remoteSearchURL = searchURL + text
        guard let url = URL(string: remoteSearchURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                onComplition(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                    onComplition(.success(result.articles))
                }
                catch {
                    onComplition(.failure(error))
                }
            }
        }
        task.resume()
    }
}

