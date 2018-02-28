//
//  TextViewContent.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

//swiftlint:disable line_length
enum TextViewType {
    case imprint
    case licence

    var content: String {
        switch self {
        case .imprint:
            return """
            Cineaste ist ein Open Source Projekt von zwei Informatik Studenten. Das Kernfeature der App liegt darin, möglichst leicht Filme für einen gemeinsamen Filmeabend zu finden. Über den "Matching"-Button sucht dein Handy nach Freunden in deiner Umgebung und findet Filme, die ihr Alle sehen wollt.\n\nDie Daten werden dabei über Bluetooth übertragen. Das heißt, dass deine Filmlisten zu jedem Zeitpunkt sicher auf deinem Gerät sind und dort auch bleiben. Daten werden also nur innerhalb deines Wohnzimmers ausgetauscht.\n\nCineaste befindet sich noch im Anfangsstadium und könnte manchmal nicht richtig funktionieren. Natürlich geben wir unser Bestes um das Erlebnis so gut wie möglich zu machen, dabei sind wir aber auf dein Feedback angewiesen. Schreib doch einfach ein Kommentar im Play Store oder entwickle einfach gemeinsam mit uns Cineaste weiter! Dazu findest du unten das GitHub Icon. Für die Filme zapfen wir übrigens TheMovieDb an. Auch hier kannst du über das Icon mal vorbeischaun.\n\nBesonderer Dank geht an Philipp Wolf für das Design!
            """
        case .licence:
            return """
            Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.
            """
        }
    }
}
