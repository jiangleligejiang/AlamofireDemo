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
    static let POST_URL = "http://httpbin.org/anything"
    static let UPLOAD_URL = "https://catbox.moe/user/api.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
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
        
        postFormData { (error, result) in
            if let error = error {
                print("post form data error: \(error.localizedDescription)")
            } else {
                print("post form data success: \(String(describing: dump(result)))")
            }
        }
        
        postFormDataByAlamofire { (error, result) in
            if let error = error {
                print("post form data by alamofire error: \(error.localizedDescription)")
            } else {
                print("post form data by alamofire success: \(String(describing: dump(result)))")
            }
        }
        */
        uploadImage { (error, result) in
            if let error = error {
                print("upload image error: \(error.localizedDescription)")
            } else {
                print("upload image success: \(result!))")
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

extension ViewController {
    
    func postFormData(_ completion: @escaping(Error?, Dictionary<String, Any>?) -> Void) {
        if let url = URL(string: Self.POST_URL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let postDict: [String : Any] = ["name" : "jams", "age" : 24]
            guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
                return
            }
            request.httpBody = postData
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(error, nil)
                } else if let data = data,
                let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
                        completion(nil, dict)
                    } catch  let parseError  {
                        completion(parseError, nil)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func postFormDataByAlamofire(_ completion: @escaping(Error?, Dictionary<String, Any>?) -> Void) {
        AF.request(Self.POST_URL, method: .post, parameters: ["name" : "jams", "age" : 24]).responseJSON { (response) in
            if let response = response.value as? Dictionary<String, Any> {
                completion(nil, response)
            } else {
                completion(response.error, nil)
            }
        }
    }
    
}

extension ViewController {
    
    func uploadImage(_ completion: @escaping(Error?, String?) -> Void) {
        guard let image = UIImage.init(named: "test"), let imageData = image.pngData(), let url = URL(string: Self.UPLOAD_URL) else {
            return
        }
        
        let boundary = UUID().uuidString
                
        var request = URLRequest(url: url)
        request.method = .post
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let fieldName = "reqtype"
        let fieldValue = "fileupload"

        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data;name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)
        
        let filename = "test.png"

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data;name=\"fileToUpload\";filename=\"\(filename)\"\r\n\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        let uploadTask = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data, let rspString = String(data: data, encoding: .utf8) {
                completion(nil, rspString)
            }
        
        }
        uploadTask.resume()
    }
    
}
