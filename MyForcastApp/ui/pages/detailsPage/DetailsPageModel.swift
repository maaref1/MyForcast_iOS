//
//  DetailsPageModel.swift
//
//

import Foundation

struct DetailsPageModel {
    
}

enum DetailsPageInputAction {
    case performAction(input: DetailsPageInputModel)
}

enum DetailsPageOutputResult {
    case didFinish(result: Any)
    case didFailed(error: String)
    case loadingState(state: Bool)
}

enum DetailsServiceOutputResult {
    case didFinish(result: Any)
    case didFailed(error: String)
    case loadingState(state: Bool)
}

struct DetailsPageInputModel {
}
