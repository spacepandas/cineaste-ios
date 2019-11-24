//
//  MovieNightViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import ReSwift

// swiftlint:disable:next type_body_length
class MovieNightViewController: UITableViewController {
    @IBOutlet private weak var permissionDeniedView: UIView!
    @IBOutlet private weak var nearbyIcon: UIImageView!
    @IBOutlet private weak var permissionButton: UIButton!
    @IBOutlet private weak var permissionDeniedDescription: UILabel!
    @IBOutlet private weak var nearbyLinkPermissionDeniedTextView: LinkTextView!

    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var usageDescription: UILabel!
    @IBOutlet private weak var microphoneIcon: UIImageView!
    @IBOutlet private weak var bluetoothIcon: UIImageView!
    @IBOutlet private weak var nearbyLinkUsageDescriptionTextView: LinkTextView!

    var canUseNearby: Bool = true {
        didSet {
            updateTableView(with: canUseNearby)

            canUseNearby ? startTitleAnimation() : stopTitleAnimation()
        }
    }

    private var canUseBluetooth: Bool = true {
        didSet {
            bluetoothIcon.tintColor = canUseBluetooth
                ? .cineUsageActive
                : .cineUsageInactive
        }
    }

    private var canUseMicrophone: Bool = true {
        didSet {
            microphoneIcon.tintColor = canUseMicrophone
            ? .cineUsageActive
            : .cineUsageInactive
        }
    }

    private var microphonePermissionErrorHandler: ((Bool) -> Void)?
    private var bluetoothPowerErrorHandler: ((Bool) -> Void)?
    private var nearbyPermissionHandler: ((Bool) -> Void)?

    lazy var gnsMessageManager: GNSMessageManager =
        GNSMessageManager(apiKey: ApiKeyStore.nearbyKey) { (params: GNSMessageManagerParams?) in
            guard let params = params else { return }
            //Tracking user settings that affect Nearby
            params.microphonePermissionErrorHandler = self.microphonePermissionErrorHandler ?? { _ in }
            params.bluetoothPowerErrorHandler = self.bluetoothPowerErrorHandler ?? { _ in }
        }

    var ownNearbyMessage: NearbyMessage?

    private var timer: Timer?

    var currentPermission: GNSPermission?
    var currentPublication: GNSPublication?
    var currentSubscription: GNSSubscription?

    var nearbyMessages = [NearbyMessage]() {
        didSet {
            tableView.reloadData()
        }
    }

    private(set) var movies: [Movie] = [] {
        didSet {
            ownNearbyMessage = generateOwnNearbyMessage()
            tableView.reloadData()
            publishWatchlistMovies()
        }
    }

    deinit {
        currentPermission = nil
        currentPublication = nil
        currentSubscription = nil

        microphonePermissionErrorHandler = nil
        bluetoothPowerErrorHandler = nil
        nearbyPermissionHandler = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        resizeLargeTitle()

        title = String.movieNightTitle

        nearbyLinkPermissionDeniedTextView.delegate = self
        nearbyLinkUsageDescriptionTextView.delegate = self

        canUseNearby = GNSPermission.isGranted()
        canUseBluetooth = true
        canUseMicrophone = true

        configureViews()
        localizeContent()

        configureDebugModeHelper()
        configureTableView()
        configureStateObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if canUseNearby {
            startTitleAnimation()
        }

        currentPermission = GNSPermission(changedHandler: nearbyPermissionHandler)
        publishWatchlistMovies()
        subscribeToNearbyMessages()

        store.subscribe(self) { subscription in
            subscription
                .select(MovieNightViewController.select)
                .skipRepeats()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopTitleAnimation()
        store.unsubscribe(self)
    }

    // MARK: - Actions

    @IBAction func cancelMovieNight() {
        dismiss(animated: true)
    }

    @IBAction func allowNearby() {
        GNSPermission.setGranted(true)
    }

    @objc
    func toggleSearchingForFriendsMode() {
        #if DEBUG
        guard nearbyMessages.isEmpty else {
            nearbyMessages = []
            return
        }

        let simulatorMovies = [
            NearbyMovie(
                id: 515_042,
                title: "Free Solo",
                posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg"),
            NearbyMovie(
                id: 10_898,
                title: "The Little Mermaid II: Return to the Sea",
                posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg"),
            NearbyMovie(
                id: 10_144,
                title: "The Little Mermaid",
                posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg")
        ]
        let developerMovies = [
            NearbyMovie(
                id: 515_042,
                title: "Free Solo",
                posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg"),
            NearbyMovie(
                id: 10_898,
                title: "The Little Mermaid II: Return to the Sea",
                posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg")
        ]

        nearbyMessages = [
            NearbyMessage(
                userName: "Simulator",
                deviceId: "1",
                movies: simulatorMovies),
            NearbyMessage(
                userName: "Developer",
                deviceId: "2",
                movies: developerMovies)
        ]
        #endif
    }

    // MARK: - Configuration

    private func configureDebugModeHelper() {
        #if DEBUG
        let tripleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleSearchingForFriendsMode))
        tripleTapGestureRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGestureRecognizer)
        #endif
    }

    private func localizeContent() {
        permissionButton.setTitle(String.enableNearby, for: .normal)
        permissionDeniedDescription.text = String.nearbyPermissionDenied
        usageDescription.text = String.nearbyUsage
        nearbyLinkPermissionDeniedTextView.text = String.nearbyLink
        nearbyLinkUsageDescriptionTextView.text = String.nearbyLink
    }

    private func configureViews() {
        nearbyIcon.tintColor = .cineFooter
        permissionDeniedDescription.textColor = .cineFooter
        usageDescription.textColor = .cineFooter

        let nearbyPermissionStyle = nearbyLinkPermissionDeniedTextView.paragraphStyle
        nearbyPermissionStyle.alignment = .center
        nearbyPermissionStyle.lineSpacing = 3
        nearbyLinkPermissionDeniedTextView.paragraphStyle = nearbyPermissionStyle

        let nearbyUsageStyle = nearbyLinkUsageDescriptionTextView.paragraphStyle
        nearbyUsageStyle.alignment = .left
        nearbyUsageStyle.lineSpacing = 3
        nearbyLinkUsageDescriptionTextView.paragraphStyle = nearbyUsageStyle
    }

    private func configureTableView() {
        tableView.backgroundColor = UIColor.cineListBackground

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.alwaysBounceVertical = false
    }

    private func configureStateObserver() {
        bluetoothPowerErrorHandler = { [weak self] hasError in
            self?.canUseBluetooth = !hasError
        }

        microphonePermissionErrorHandler = { [weak self] hasError in
            self?.canUseMicrophone = !hasError
        }

        nearbyPermissionHandler = { [weak self] granted in
            if self?.canUseNearby != granted {
                self?.canUseNearby = granted
            }
        }
    }

    // MARK: - Custom

    private func updateTableView(with canUseNearby: Bool) {
        tableView.tableFooterView = canUseNearby ? footerView : UIView()
        tableView.backgroundView = canUseNearby ? nil : permissionDeniedView
    }

    private func generateOwnNearbyMessage() -> NearbyMessage {
        guard let username = UserDefaults.standard.username
            else { fatalError("ViewController should never be presented without a username") }

        let nearbyMovies = movies.compactMap(NearbyMovie.init)
        return NearbyMessage(with: username, movies: nearbyMovies)
    }

    private func startTitleAnimation() {
        guard timer == nil else { return }
        timer = Timer(timeInterval: 0.6, repeats: true) { [weak self] _ in
            self?.title = self?.animateTitle()
        }

        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .common)
    }

    private func stopTitleAnimation() {
        timer?.invalidate()
        timer = nil

        title = String.movieNightTitle
    }

    private func animateTitle() -> String {
        var title = self.title ?? String.movieNightTitle

        if title == "\(String.movieNightTitle)" {
            title = "\(String.movieNightTitle)."
        } else if title == "\(String.movieNightTitle)." {
            title = "\(String.movieNightTitle).."
        } else if title == "\(String.movieNightTitle).." {
            title = "\(String.movieNightTitle)..."
        } else if title == "\(String.movieNightTitle)..." {
            title = "\(String.movieNightTitle)"
        }
        return title
    }

    private func resizeLargeTitle() {
        guard var largeTitleAttributes = navigationController?.navigationBar
                .largeTitleTextAttributes
            else { return }

        let largestPossibleTitle = "\(String.movieNightTitle)..."
        largeTitleAttributes[.font] = resizedFont(for: largestPossibleTitle)

        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
    }

    // credits: https://stackoverflow.com/a/49082928
    private func resizedFont(for title: String) -> UIFont {
        var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        var largeTitleWidth = title.size(withAttributes: [
            .font: UIFont.systemFont(ofSize: fontSize)
            ]).width

        let maxWidth = UIScreen.main.bounds.size.width - 60
        while largeTitleWidth > maxWidth {
            fontSize -= 1
            largeTitleWidth = title.size(withAttributes: [
                .font: UIFont.systemFont(ofSize: fontSize)
                ]).width
        }

        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showMovieMatches?:
            guard let (title, nearbyMessages) = sender as? (String, [NearbyMessage])
                else { return }

            let vc = segue.destination as? MovieMatchViewController
            vc?.configure(
                with: title,
                messagesToMatch: nearbyMessages)
        default:
            return
        }
    }
}

extension MovieNightViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        let safariVC = CustomSafariViewController(url: URL)
        present(safariVC, animated: true)

        return false
    }
}

extension MovieNightViewController: StoreSubscriber {
    struct State: Equatable {
        let movies: [Movie]
    }

    private static func select(state: AppState) -> State {
        let movies = state.movies
            .filter { !($0.watched ?? false) }
            .sorted { $0.title > $1.title }
        return .init(movies: movies)
    }

    func newState(state: State) {
        movies = state.movies
    }
}

extension MovieNightViewController: Instantiable {
    static var storyboard: Storyboard { return .movieNight }
    static var storyboardID: String? { return "MovieNightViewController" }
}
