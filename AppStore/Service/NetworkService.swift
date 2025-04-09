//
//  NetworkService.swift
//  AppStore
//
//  Created by Dmitry Volkov on 29/03/2025.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> () ) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchGenericJSONData(urlString: urlString, completion: completion)

    }
    
    func fetchBestApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)

    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let dataString = String(data: data!, encoding: .utf8)
                print(dataString)
                let objects = try JSONDecoder().decode(T.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
