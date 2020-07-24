//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by jams on 2020/7/24.
//  Copyright © 2020 jams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let FILM_URL = "https://swapi.dev/api/films"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchFilms { (error, films) in
            if let error = error {
                print("fetch films error: " + error.localizedDescription)
            } else {
                
            }
        }
    }
    
}

extension ViewController {
    
    typealias JSONDictionary = [String : Any]
    
    func fetchFilms(_ completion: @escaping(NSError?, [Film]?) -> Void) {
        if let url = URL(string: Self.FILM_URL) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("fetch films error: " + error.localizedDescription)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    do {
                        if let rsp = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
                            let result = rsp["results"] as? Array<Any>,
                            result.count > 0 {
                            let decoder = JSONDecoder()
                            let jsondata = try JSONSerialization.data(withJSONObject: result, options: [])
                            let films = try decoder.decode([Film].self, from: jsondata)
                            completion(nil, films)
                        }
                        
                    } catch let parseError as NSError {
                        print("parse error: " + parseError.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
}

