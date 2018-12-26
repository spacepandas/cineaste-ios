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

        return documentsDirectory + "/" + String.exportMoviesFileName(with: Date().formatted)
    }

    static func saveForExport(_ movies: [StoredMovie]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(ImportExportObject(movies: movies))
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: Exporter.exportPath) {
            guard fileManager.createFile(atPath: Exporter.exportPath,
                                         contents: nil)
                else {
                    throw(ExportError.creatingFileAtPath)
            }
        }

        let url = URL(fileURLWithPath: Exporter.exportPath)
        try data.write(to: url)
    }
}
