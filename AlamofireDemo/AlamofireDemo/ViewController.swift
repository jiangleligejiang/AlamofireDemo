//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by jams on 2020/7/24.
//  Copyright © 2020 jams. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    static let FILM_URL = "https://swapi.dev/api/films"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchFilms { (error, films) in
            if let error = error {
                print("fetch films error: " + error.localizedDescription)
            } else {
                print("fetch films success: \(String(describing: films))")
            }
        }
        
        fetchFilmsByAlamofire { (error, films) in
            if let error = error {
                print("fetch films by alamofire error: " + error.localizedDescription)
            } else {
                print("fetch films by alamofire success: \(String(describing: films))")
            }
        }
    }
    
}

extension ViewController {
    
    typealias JSONDictionary = [String : Any]
    // iOS 13 GET 请求不能通过把参数设置到httpBody中：https://stackoverflow.com/questions/56955595/1103-error-domain-nsurlerrordomain-code-1103-resource-exceeds-maximum-size-i
    func fetchFilms(_ completion: @escaping(Error?, [Film]?) -> Void) {
        
        /*
        if let url = URL(string: Self.FILM_URL) {
            var request = URLRequest(url: url)
            let parameters: [String : String] = ["search" : "Hope"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(error, nil);
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let films = try decoder.decode(Films.self, from: data)
                        completion(nil, films.all)
                    } catch let parseError as NSError {
                        completion(parseError, nil);
                    }
                }
            }
            dataTask.resume()
        }
        */
        
        if var urlComponents = URLComponents(string: Self.FILM_URL) {
            urlComponents.queryItems = [URLQueryItem(name: "search", value: "Hope")]
            if let url = urlComponents.url {
                let request = URLRequest(url: url)
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(error, nil);
                    } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        do {
                            let decoder = JSONDecoder()
                            let films = try decoder.decode(Films.self, from: data)
                            completion(nil, films.all)
                        } catch let parseError as NSError {
                            completion(parseError, nil);
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    func fetchFilmsByAlamofire(_ completion: @escaping(Error?, [Film]?) -> Void) {
        AF.request(Self.FILM_URL, parameters: ["search" : "Hope"]).responseDecodable(of: Films.self) { response in
            if let films = response.value {
                completion(nil, films.all)
            } else {
                completion(response.error, nil)
            }
        }
    }
    
}

