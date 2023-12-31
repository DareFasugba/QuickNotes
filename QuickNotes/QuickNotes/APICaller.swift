//
//  APICaller.swift
//  QuickNotes
//
//  Created by The Fasugba Crew  on 23/06/2023.
//

import Foundation
import OpenAISwift

final class APICaller {
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "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"
    }
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .gpt3(.davinci), maxTokens: 1000, completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
