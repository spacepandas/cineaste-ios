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

    static func saveAsFileToExport(_ movies: [StoredMovie]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let exportObject = ImportExportObject(movies: movies)
        let data = try encoder.encode(exportObject)

        guard FileManager.default
            .createFile(atPath: Exporter.exportPath,
                        contents: data)
            else { throw(ExportError.creatingFileAtPath) }
    }
}
