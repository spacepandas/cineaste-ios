//
//  MovieNightViewController+Nearby.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

extension MovieNightViewController {
    func publishWatchlistMovies() {
        guard let ownMessage = ownNearbyMessage,
            let messageData = try? JSONEncoder.tmdbEncoder.encode(ownMessage)
            else { return }

        currentPublication = gnsMessageManager.publication(
            with: GNSMessage(content: messageData)
        )
    }

    func subscribeToNearbyMessages() {
        currentSubscription = gnsMessageManager.subscription(
            messageFoundHandler: { message in
                guard let nearbyMessage = self.convertGNSMessage(from: message)
                    else { return }

                // add nearbyMessage
                DispatchQueue.main.async {
                    if !self.nearbyMessages.contains(nearbyMessage) {
                        self.nearbyMessages.append(nearbyMessage)
                    }
                }
            },
            messageLostHandler: { message in
                guard let nearbyMessage = self.convertGNSMessage(from: message)
                    else { return }

                // remove nearbyMessage
                DispatchQueue.main.async {
                    self.nearbyMessages = self.nearbyMessages
                        .filter { $0 != nearbyMessage }
                }
            }
        )
    }

    private func convertGNSMessage(from message: GNSMessage?) -> NearbyMessage? {
        guard let data = message?.content,
            let nearbyMessage = try? JSONDecoder.tmdbDecoder
                .decode(NearbyMessage.self, from: data)
            else { return nil }

        return nearbyMessage
    }
}
