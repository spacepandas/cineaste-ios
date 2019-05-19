//
//  Exporter.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

enum ExportError: Error {
    case creatingFileAtPath
}

enum Exporter {
    static var exportPath: String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
            )[0]

        return documentsDirectory
            + "/"
            + String.exportMoviesFileName(with: Date().formattedForRequest)
    }

    static func saveAsFileToExport(_ movies: [Movie]) throws {
        let encoder = JSONEncoder.tmdbEncoder

        let exportObject = ImportExportObject(
            movies: movies.sorted { $0.id < $1.id }
        )
        let data = try encoder.encode(exportObject)

        guard FileManager.default
            .createFile(atPath: Exporter.exportPath,
                        contents: data)
            else { throw(ExportError.creatingFileAtPath) }
    }
}
