//
//  PersonController.swift
//  HallOfFame31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

class PersonController {
    
    // MARK: - String Helpers
    static private let baseURL = URL(string: "https://ios-api.devmountain.com/api")
    static private let personEndpoint = "person"
    static private let peopleEndpoint = "people"
    static private let contentTypeKey = "Content-Type"
    static private let contentTypeValue = "application/json"
    
    // MARK: - Methods
    // POST (Create)
    static func postPerson(firstName: String, lastName: String, completion: @escaping (Result<Person, NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        print(personURL)
        
        // Prepare POST Request
        var postRequest = URLRequest(url: personURL)
        postRequest.httpMethod = "POST"
        // header
        postRequest.addValue(contentTypeValue, forHTTPHeaderField: contentTypeKey)
        // body
        let postedPerson = Person(firstName: firstName, lastName: lastName, personID: nil)
        
        do {
            let encoder = JSONEncoder()
            let personData = try encoder.encode(postedPerson)
            postRequest.httpBody = personData
        } catch {
            print(error, error.localizedDescription)
            return completion(.failure(.thrownError(error)))
        }
        
        // DataTask
        URLSession.shared.dataTask(with: postRequest) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode([Person].self, from: data)
                return completion(.success(person[0]))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
        
    }
    
    
    // GET (Read)
    static func getPeople(completion: @escaping (Result<[Person], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        print(peopleURL)
        // url session
        URLSession.shared.dataTask(with: peopleURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            // check data
            guard let data = data else { return completion(.failure(.noData))}
            // decode people
            do {
                let decoder = JSONDecoder()
                let people = try decoder.decode([Person].self, from: data)
                return completion(.success(people))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
