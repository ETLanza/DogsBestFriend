//
//  BreedController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 7/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class BreedController {

    // MARK: - Properties
    static var breeds: [Breed] = []

    static let baseURL = URL(string: "https://dog.ceo/api")

    // MARK: - GET request for breeds from API
    static func getBreeds(completion: @escaping ((Bool) -> Void)) {
        guard let baseURL = baseURL else { completion(false); return }

        let fullURL = baseURL.appendingPathComponent("breeds").appendingPathComponent("list").appendingPathComponent("all")

        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        request.httpBody = nil

        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error with GET URL request: \(error.localizedDescription)")
            }

            guard let data = data else { completion(false); return }

            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
                completion(false)
                return
            }

            guard let breedList = json["message"] as? [String: [String]] else { completion(false); return }
            for (key, value) in breedList {
                if value.isEmpty {
                    let newBreed = Breed(name: key, breedURLComponentAsString: key)
                    breeds.append(newBreed)
                } else {
                    for i in value {
                        let breedString = "\(i) \(key)"
                        let breedImageString = "\(key)-\(i)"
                        let newBreed = Breed(name: breedString, breedURLComponentAsString: breedImageString)
                        breeds.append(newBreed)
                    }
                }
            }
            breeds.sort { $0.name < $1.name }
            completion(true)
        }
        dataTask.resume()
    }

    // MARK: - Random image GET request from API
    static func getRandomImageFor(breed: Breed, completion: @escaping ((UIImage?) -> Void)) {
        guard let baseURL = baseURL else { completion(nil); return }
        let fullURL = baseURL.appendingPathComponent("breed").appendingPathComponent(breed.breedURLComponentAsString).appendingPathComponent("images").appendingPathComponent("random")

        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        request.httpBody = nil

        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error with image data task: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Data error")
                completion(nil); return }

            do {
                guard let json = (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String]),
                let imageURLAsString = json["message"],
                let url = URL(string: imageURLAsString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            } catch {
                print("Error getting image: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
}
