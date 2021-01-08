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
    
    let persistentContainer: NSPersistentContainer
    var modelName = "MovieModel"
    
    init() {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            } // error
        } // persistentContainer
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    } // init
    
    static var bookmarkedMovies: NSFetchRequest<MovieEntity> {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.movieFetchRequest()
        let sort = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
        let predicate = NSPredicate(format: "%K == %d", #keyPath(MovieEntity.bookmarked), true)
        request.sortDescriptors = sort
        request.predicate = predicate
        return request
    }
    
    static var watchedMovies: NSFetchRequest<MovieEntity> {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.movieFetchRequest()
        let sort = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
        let predicate = NSPredicate(format: "%K == %d", #keyPath(MovieEntity.watched), true)
        request.sortDescriptors = sort
        request.predicate = predicate
        return request
    }
    
    static var favoriteMovies: NSFetchRequest<MovieEntity> {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.movieFetchRequest()
        let sort = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
        let predicate = NSPredicate(format: "%K == %d", #keyPath(MovieEntity.favorite), true)
        request.sortDescriptors = sort
        request.predicate = predicate
        return request
    }
    
    static var boughtMovies: NSFetchRequest<MovieEntity> {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.movieFetchRequest()
        let sort = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
        let predicate = NSPredicate(format: "%K == %d", #keyPath(MovieEntity.bought), true)
        request.sortDescriptors = sort
        request.predicate = predicate
        return request
    }
    
    func favoriteTapped(_ movie: MovieDataStore.MovieItem, favoriteStatus: Bool) {
        let context = persistentContainer.viewContext
        let movieEntity = findMovieByID(using: movie.id, in: context)
        context.perform {
            movieEntity.favorite = favoriteStatus
            self.saveContext(object: movieEntity, context: context)
        }
        
    }
    func watchedTapped(_ movie: MovieDataStore.MovieItem, watchedStatus: Bool) {
        let context = persistentContainer.viewContext
        let movieEntity = findMovieByID(using: movie.id, in: context)
        context.perform {
            movieEntity.watched = watchedStatus
            self.saveContext(object: movieEntity, context: context)
        }
    }
    func bookmarkTapped(_ movie: MovieDataStore.MovieItem, bookmarkStatus: Bool) {
        let context = persistentContainer.viewContext
        let movieEntity = findMovieByID(using: movie.id, in: context)
        context.perform {
            movieEntity.bookmarked = bookmarkStatus
            self.saveContext(object: movieEntity, context: context)
        }
    }
    func buyTapped(_ movie: MovieDataStore.MovieItem, buyStatus: Bool) {
        let context = persistentContainer.viewContext
        let movieEntity = findMovieByID(using: movie.id, in: context)
        context.perform {
            movieEntity.bought = buyStatus
            self.saveContext(object: movieEntity, context: context)
        }
    }
    func updateNote(_ movie: MovieDataStore.MovieItem, noteText: String) {
        let context = persistentContainer.viewContext
        let movieEntity = findMovieByID(using: movie.id, in: context)
        context.perform {
            movieEntity.note = noteText
            self.saveContext(object: movieEntity, context: context)
        }
    }
    
    //MARK: - SaveContext
    func saveContext(object: NSManagedObject, context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
            context.refresh(object, mergeChanges: true)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.localizedDescription)")
            context.rollback()
        }
    }
    
    func findMovieByID(using movieID: Int, in context: NSManagedObjectContext) -> MovieEntity {
        let request = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MovieEntity.movieId), movieID)
        
        if let movie = try? context.fetch(request).first {
            return movie
        } else {
            fatalError("Could not find movie from movieID: \(movieID)")
        }
    }
}
