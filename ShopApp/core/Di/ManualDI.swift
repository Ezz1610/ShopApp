//
//  File.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

import Foundation
import Swinject


final class ManualDI {
    static let shared = ManualDI()
    
    private init() {}
    
    func resolveMovieViewModel() -> MovieViewModel {
        return MovieViewModel(movieListUseCase: resolveMovieListUseCase())
    }
    
    private func resolveMovieListUseCase() -> MovieListUseCaseProtocol {
        return MovieListUseCase(dataHelper: resolveFetchDataHelper())
    }
    
    private func resolveFetchDataHelper() -> FetchDataProtocol {
        return RemoteDataHelper()
    }
}
