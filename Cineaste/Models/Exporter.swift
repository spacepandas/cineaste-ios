//
//  Exporter.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum ExportError: Error {
    case creatingFileAtPath
    case writingContentInFile
}

enum Exporter {
    static var exportPath: String {
        let documentsDirectory =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask,
                                                true)[0]

        return documentsDirectory + "/" + String.exportMoviesFileName(with: Date().formatted)
    }

    static func export(_ movies: [StoredMovie]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(ImportExportObject(movies: movies))
        try Exporter.saveToDocumentsDirectory(data)
    }

}

extension Exporter {
    private static func saveToDocumentsDirectory(_ data: Data) throws {
        let fileManager = FileManager.default

        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: Exporter.exportPath) {
            guard fileManager.createFile(atPath: Exporter.exportPath,
                                         contents: nil,
                                         attributes: nil)
                else {
                    throw(ExportError.creatingFileAtPath)
            }
        }

        // Write that JSON to the file created earlier
        guard let file = FileHandle(forWritingAtPath: Exporter.exportPath) else {
            throw(ExportError.writingContentInFile)
        }
        file.truncateFile(atOffset: 0)
        file.write(data)
    }
}
