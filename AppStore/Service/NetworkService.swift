//
//  NetworkService.swift
//  AppStore
//
//  Created by Dmitry Volkov on 29/03/2025.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> () ) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
                
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("DEBUG: ERROR")
                completion([], nil)
                return
            }
                    
            guard let data = data else { return }
                    
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                print(searchResult.resultCount)
                completion(searchResult.results, nil)
            } catch {
                print("DEBUG: Failed to decode")
                completion([], error)
            }
        }.resume()
    }
    
    
}
