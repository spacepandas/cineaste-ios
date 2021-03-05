//
//  DebugPrint.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

func releasePrint(_ object: Any) {
    Swift.print(object)
}

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
