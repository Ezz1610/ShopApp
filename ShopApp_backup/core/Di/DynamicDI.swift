//
//  DynamicDI.swift
//  MovieApp
//
//  Created by mohamed ezz on 15/10/2025.
//

//
//import Foundation
//import Swinject
//
//final class DynamicDI {
//    static let shared = DynamicDI()
//    private let container: Container
//    
//    init() {
//        container = Container()
//        registerDependencies()
//    }
//    
//    private func registerDependencies() {
//        container.register(FetchDataProtocol.self) { _ in
//            RemoteDataHelper()
//        }
        
        //        container.register(MovieListUseCaseProtocol.self) { resolver in
        //            let dataHelper = resolver.resolve(FetchDataProtocol.self)!
        //            return MovieListUseCase(dataHelper: dataHelper)
        //        }
        //
        //        container.register(MovieViewModel.self) { resolver in
        //            let movieListUseCase = resolver.resolve(MovieListUseCaseProtocol.self)!
        //            return MovieViewModel(movieListUseCase: movieListUseCase)
        //        }
        //    }
        //
        //    func resolveMovieViewModel() -> MovieViewModel {
        //        guard let viewModel = container.resolve(MovieViewModel.self) else {
        //            fatalError("failed to resolve MovieViewModel")
        //        }
        //        return viewModel
        //    }
//    }
//}
