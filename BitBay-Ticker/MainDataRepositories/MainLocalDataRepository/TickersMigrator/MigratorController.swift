struct MigratorController {
    
    private let migratorFromV0ToV2: Migrator
    private let migratorFromV1ToV2: Migrator
    
    init(migratorFromV0ToV2: Migrator = MigratorFromV0ToV2(),
         migratorFromV1ToV2: Migrator = MigratorFromV1ToV2()) {
        self.migratorFromV0ToV2 = migratorFromV0ToV2
        self.migratorFromV1ToV2 = migratorFromV1ToV2
    }
    
    func migrateOldTickersToCurrentTickers() -> [Ticker]? {
        if migratorFromV1ToV2.canBeMigrated {
            return migratorFromV1ToV2.loadMigratedTickers()
        }
        
        if migratorFromV0ToV2.canBeMigrated {
            return migratorFromV1ToV2.loadMigratedTickers()
        }
        
        return nil
    }
    
}
