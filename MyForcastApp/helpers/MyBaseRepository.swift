//
//  MyBaseRepository.swift
//  MyForcastApp
//
//  Created by MacBook Air on 18/08/2022.
//

import Foundation

class MyBaseRepository {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}
