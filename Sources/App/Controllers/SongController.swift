//
//  File.swift
//  
//
//  Created by Дмитрий Спичаков on 18.02.2023.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    // /songs route use
    func boot(routes: RoutesBuilder) throws {
        // name of /"nameRoute"
        let songs = routes.grouped("opa")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":itemID") { item in
            item.delete(use: delete)
        }
    }
    
    // GET req /opa route create
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST req /opa route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    
    // PUT Request /opa routes
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)

        return Song.find(song.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    // DELETE  Request /opa/id routes
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("itemID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

