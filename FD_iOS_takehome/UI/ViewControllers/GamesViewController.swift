import UIKit

protocol StarredGameDelegate {
    func didStarGame(gameId: Int)
    func didUnStarGame(gameId: Int)
}

struct GamesCellInformation {
    let awayTeam: Teams
    let homeTeam: Teams
    let gameInfo: GameStates
    let isStarred: Bool
}

class GamesViewController: UIViewController {
    @IBOutlet weak var gamesTableView: UITableView!
    private final let gameCellIdentifier = "GameTableViewCell"
    private final let jsonFileName = "basketballData"
    public static var backGroundColor: UIColor?
    
    private var teams: [Teams]?
    private var response: SportsData?
    private var sortedGames = [GamesCellInformation]()
    private let jsonExtractor = JSONExtractorFromFile()
    private var shouldSortData = true
    private var starredGames = [Int]() {
        didSet {
            shouldSortData = true
            sortedGames.removeAll()
            gamesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAttributes()
        setupDelegates()
        
        if #available(iOS 13.0, *) {
            GamesViewController.backGroundColor = .systemGray6
        } else {
            GamesViewController.backGroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1)
        }
        
        view.backgroundColor = GamesViewController.backGroundColor
        setupTableView()
        response = jsonExtractor.loadJSON(fromFile: jsonFileName, as: SportsData.self)
        teams = response?.teams
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldSortData { //only called the first time the app is loaded and if starred games change
            resortData()
            shouldSortData = false
        }
    }
    
    private func resortData() {
        response?.games.forEach({ game in
            let awayTeam = teams!.filter { $0.id == game.away_team_id }[0]
            let homeTeam = teams!.filter { $0.id == game.home_team_id }[0]
            let stateforGame = response!.game_states.filter { $0.id == game.id }[0]
            let gameToAppend = GamesCellInformation(awayTeam: awayTeam, homeTeam: homeTeam, gameInfo: stateforGame, isStarred: starredGames.contains(stateforGame.game_id))
            sortedGames.append(gameToAppend)
        })
        
        sortedGames.sort { $0.isStarred && !$1.isStarred }
    }
    
    private func setupTableView() {
        gamesTableView.backgroundColor = GamesViewController.backGroundColor
        gamesTableView.separatorColor = GamesViewController.backGroundColor
        gamesTableView.separatorColor = GamesViewController.backGroundColor
        gamesTableView.contentInset.bottom = 20
        gamesTableView.register(UINib(nibName: gameCellIdentifier, bundle: nil), forCellReuseIdentifier: gameCellIdentifier)
    }
    
    private func setupNavigationBarAttributes() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.5585086346, blue: 0.978794992, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Games"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: .none, style: .plain, target: nil, action: nil)
    }
    
    private func setupDelegates() {
        gamesTableView.dataSource = self
        gamesTableView.delegate = self
    }
}

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return response?.games.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gameCellIdentifier, for: indexPath) as! GameTableViewCell
        setup(cell)
        let game = sortedGames[indexPath.section]
        cell.cellId = game.gameInfo.game_id
        cell.topLabel.text = game.awayTeam.name
        cell.bottomLabel.text = game.homeTeam.name
        cell.topLabelBar.backgroundColor = UIColor(hexString: game.awayTeam.color)
        cell.bottomLabelBar.backgroundColor = UIColor(hexString: game.homeTeam.color)
        cell.starImageView.isHidden = !starredGames.contains(game.gameInfo.game_id)
        
        let stateforGame = game.gameInfo
        cell.topScoreLabel.isHidden = stateforGame.away_team_score == nil
        cell.bottomScoreLabel.isHidden = stateforGame.home_team_score == nil
        cell.topScoreLabel.text = "\(stateforGame.away_team_score ?? -1)"
        cell.bottomScoreLabel.text = "\(stateforGame.home_team_score ?? -1)"
        
        switch stateforGame.game_status {
        case .final:
            cell.statusLabel.text = "FINAL"
            cell.statusLabel.font = .boldSystemFont(ofSize: 14)
            cell.statusLabel.textColor = .black
            if (stateforGame.away_team_score ?? 0) > (stateforGame.home_team_score ?? 0) {
                cell.topLabel.font = .boldSystemFont(ofSize: 15)
                cell.bottomScoreLabel.font = .systemFont(ofSize: 16)
            } else {
                cell.bottomLabel.font = .boldSystemFont(ofSize: 15)
                cell.topScoreLabel.font = .systemFont(ofSize: 16)
            }
        case .scheduled:
            cell.statusLabel.text = "\(stateforGame.game_start ?? "")\n\(stateforGame.broadcast)"
            cell.statusLabel.textColor = .systemGray
            cell.statusLabel.font = .boldSystemFont(ofSize: 13)
        case .inProgress:
            cell.statusLabel.text = "Q\(stateforGame.quarter ?? 0) \(stateforGame.time_left_in_quarter ?? "")"
            cell.statusLabel.textColor = .systemGreen
            cell.statusLabel.font = .systemFont(ofSize: 13)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playersViewController = PlayersViewController()
        let gameId = (tableView.cellForRow(at: indexPath) as! GameTableViewCell).cellId ?? 0
        let gameInfo = response?.games
        playersViewController.homeTeam = teams!.filter { $0.id == (gameInfo?.filter { $0.id == gameId }[0].home_team_id ) }[0].name
        playersViewController.awayTeam = teams!.filter { $0.id == (gameInfo?.filter { $0.id == gameId }[0].away_team_id ) }[0].name
        playersViewController.gameId = gameId
        playersViewController.response = response
        playersViewController.starredGameDelegate = self
        playersViewController.isStarred = starredGames.contains(gameId)
        navigationController?.pushViewController(playersViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GamesViewController.backGroundColor
    }
    
    private func setup(_ cell: UITableViewCell) {
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.tintColor = GamesViewController.backGroundColor
        cell.selectionStyle = .none
    }
}

extension GamesViewController: StarredGameDelegate {
    func didStarGame(gameId: Int) {
        starredGames.append(gameId)
    }
    
    func didUnStarGame(gameId: Int) {
        if let index = starredGames.firstIndex(of: gameId) {
            starredGames.remove(at: index)
        }
    }
}
