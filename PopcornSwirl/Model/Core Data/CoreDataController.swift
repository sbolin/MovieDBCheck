//
//  CoreDataController.swift
//  PopcornSwirl
//
//  Created by Scott Bolin on 10/24/20.
//

import Foundation
import CoreData

class CoreDataController {
    //MARK: - Create CoreData Stack
    static let shared = CoreDataController() // singleton
    init() {} // Change from private to allow subclassing with new init for unit testing
    
    lazy var modelName = "MovieModel"
    lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error creating persistent container: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var bookmarkPredicate: NSPredicate = {
        return NSPredicate(format: "%K = %@", #keyPath(MovieEntity.bookmarked), true)
    }()

    lazy var favoritePredicate: NSPredicate = {
        return NSPredicate(format: "%K = %@", #keyPath(MovieEntity.favorite), true)
    }()

    lazy var watchedPredicate: NSPredicate = {
        return NSPredicate(format: "%K = %@", #keyPath(MovieEntity.watched), true)
    }()
    
    lazy var boughtPredicate: NSPredicate = {
        return NSPredicate(format: "%K = %@", #keyPath(MovieEntity.bought), true)
    }()
    
    lazy var namePredicate: NSPredicate = {
        return NSPredicate(format: "%K = %@", #keyPath(MovieEntity.bought), true)
    }()
    
    lazy var movieResultsController: NSFetchedResultsController<MovieEntity> = {
        let request = MovieEntity.movieFetchRequest()
        let nameSort = NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)
        request.sortDescriptors = [nameSort]// [todoIDSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    //MARK: - SaveContext
    func saveMovies(movies: [Movie]) { //[MovieData] -> [Movie]
        persistentContainer.performBackgroundTask { [weak self] (context) in
            guard let self = self else { return }
//            self.saveDataToCoreData(movies: movies, context: context)
        }
    }
    
    func favoriteTapped(_ movie: MovieDataStore.MovieItem, favoriteStatus: Bool) {
        
    }
    func watchedTapped(_ movie: MovieDataStore.MovieItem, watchedStatus: Bool) {
        
    }
    func bookmarkTapped(_ movie: MovieDataStore.MovieItem, bookmarkStatus: Bool) {
        
    }
    func buyTapped(_ movie: MovieDataStore.MovieItem, buyStatus: Bool) {
        
    }
    func noteAdded(_ movie: MovieDataStore.MovieItem, noteText: String) {
        
    }
    
/*
    private func saveDataToCoreData(movies: [Movie], context: NSManagedObjectContext) { //[MovieData] -> [Movie]
        context.perform {
            for movie in movies {
                let movieEntity = MovieEntity(context: context)
                movieEntity.title = movie.title
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.runtime = Int32(movie.runtime)
                movieEntity.voteAverage = movie.voteAverage
                movieEntity.posterPath = movie.posterPath
                movieEntity.backdropPath = movie.backdropPath
                movieEntity.overview = movie.overview
                
                movieEntity.id = Int32(movie.id)
                movieEntity.genre = movie.genreText
                movieEntity.voteCount = Int32(movie.voteCount)
                movieEntity.adult = movie.adult
                movieEntity.video = movie.video
                movieEntity.popularity = movie.popularity
//                movieEntity.backdropImage
//                movieEntity.posterImage
                movieEntity.bookmarked = false
                movieEntity.favorite = false
                movieEntity.watched = false
                movieEntity.bought = false
                movieEntity.note = ""
                
//                movieEntity.actor
//                movieEntity.director
//                movieEntity.companies
//                movieEntity.actors
                
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
 */
}
