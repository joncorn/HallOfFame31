//
//  Person.swift
//  HallOfFame31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

struct Person: Codable {
    let firstName: String
    let lastName: String
    let personID: Int?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case personID = "person_id"
    }
}
