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
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
    }
    
    // GET req /songs route create
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST req /songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
}

