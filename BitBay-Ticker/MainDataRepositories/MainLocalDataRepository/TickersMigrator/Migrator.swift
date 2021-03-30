protocol Migrator {
    
    var canBeMigrated: Bool { get }
    
    func loadMigratedTickers() -> [Ticker]?
    
}
