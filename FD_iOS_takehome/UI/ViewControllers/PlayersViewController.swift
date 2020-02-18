import UIKit

struct PlayerCellInformation {
    let playerNameTeamInfo: String
    let pointsInfo: String
    let nerdScore: Double
}

class PlayersViewController: UIViewController {
    @IBOutlet weak var playersTableView: UITableView!
    private final let playerCellIdentifier = "PlayerTableViewCell"
    
    public var homeTeam: String?
    public var awayTeam: String?
    public var gameId: Int?
    public var response: SportsData?
    public var starredGameDelegate: StarredGameDelegate?
    public var isStarred = false
    
    private var players: [Players]?
    private var playerStats: [PlayerStats]?
    private var teams: [Teams]?
    private var games: [Games]?
    private var sortedPlayersByNerd = [PlayerCellInformation]()
    private var starIcon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupDelegates()
        setupTableView()
        
        players = response?.players
        playerStats = response?.player_stats
        teams = response?.teams
        games = response?.games
        
        sortPlayerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.size.width, vertical: 0), for: UIBarMetrics.default)
    }
    
    @objc private func handleStarClicked() {
        if isStarred {
            starIcon = UIImage(named: "star-unselected")
            starredGameDelegate?.didUnStarGame(gameId: gameId!)
        } else {
            starIcon = UIImage(named: "star-selected")
            starredGameDelegate?.didStarGame(gameId: gameId!)
        }
        
        isStarred = !isStarred
        navigationItem.rightBarButtonItem?.image = starIcon?.withRenderingMode(.alwaysOriginal)
    }
    
    private func sortPlayerData() {
        let playerStat = playerStats!.filter { $0.game_id == gameId }
        playerStat.forEach { playerStat in
            let player = players!.filter { $0.id == playerStat.player_id }[0]
            let teamAbbreviation = teams!.filter { $0.id == player.team_id }[0].abbrev
            var infoText = "\(playerStat.points) Pts, \(playerStat.assists) Ast"
            infoText += playerStat.rebounds != nil ? ", \(playerStat.rebounds ?? 0) Reb" : ""
            let playerInfo = PlayerCellInformation(playerNameTeamInfo: player.name + " - " + teamAbbreviation,
                                                   pointsInfo: infoText, nerdScore: playerStat.nerd)
            sortedPlayersByNerd.append(playerInfo)
        }
        
        sortedPlayersByNerd.sort(by: { $0.nerdScore > $1.nerdScore })
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        starIcon = isStarred ? UIImage(named: "star-selected") : UIImage(named: "star-unselected")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: starIcon?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleStarClicked))
        title = "\(awayTeam ?? "") @ \(homeTeam ?? "")"
    }
    
    private func setupTableView() {
        playersTableView.register(UINib(nibName: playerCellIdentifier, bundle: nil), forCellReuseIdentifier: playerCellIdentifier)
        playersTableView.separatorColor = .clear
        playersTableView.allowsSelection = false
        playersTableView.backgroundColor = GamesViewController.backGroundColor
    }
    
    private func setupDelegates() {
        playersTableView.dataSource = self
        playersTableView.delegate = self
    }
}

extension PlayersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStats!.filter { $0.game_id == gameId }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playerCellIdentifier) as! PlayerTableViewCell
        let playerInfo = sortedPlayersByNerd[indexPath.row]
        cell.nerdValueLabel.text = "\(playerInfo.nerdScore)"
        cell.playerNameLabel.text = playerInfo.playerNameTeamInfo
        cell.playerStatLineLabel.text = playerInfo.pointsInfo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
