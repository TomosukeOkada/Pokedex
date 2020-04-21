//
//  PokemonDetailRepository.swift
//  Domain
//
//  Created by Tomosuke Okada on 2020/03/11.
//

import DataStore
import Foundation

enum PokemonDetailRepositoryProvider {

    static func provide() -> PokemonDetailRepository {
        return PokemonDetailRepositoryImpl(
            pokemonDetailApiGateway: PokemonDetailAPIGatewayProvider.provide()
        )
    }
}

protocol PokemonDetailRepository {
    func get(name: String, completion: @escaping (Result<PokemonDetailResponse, Error>) -> Void)
}

private struct PokemonDetailRepositoryImpl: PokemonDetailRepository {

    let pokemonDetailApiGateway: PokemonDetailAPIGateway

    func get(name: String, completion: @escaping (Result<PokemonDetailResponse, Error>) -> Void) {
        self.pokemonDetailApiGateway.get(name: name) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
