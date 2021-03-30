import Foundation

struct TickerV0 {
    
    enum Name: String {
        case btcpln
        case btcgbp
        case btcusd
        case btceur
        case btcusdc
        
        case ltcpln
        case ltcgbp
        case ltcusd
        case ltceur
        case ltcbtc
        
        case ethpln
        case ethgbp
        case ethusd
        case etheur
        case ethbtc
        case ethusdc
        
        case lskpln
        case lskusd
        case lskeur
        case lskbtc
        
        case bccpln
        case bccgbp
        case bccusd
        case bcceur
        case bccbtc
        case bccusdc
        
        case dashpln
        case dashusd
        case dasheur
        case dashbtc
        
        case gamepln
        case gameusd
        case gameeur
        case gamebtc
        
        case btgpln
        case btgusd
        case btgeur
        case btgbtc
        
        case kzcpln
        case kzcusd
        case kzceur
        case kzcbtc
        
        case xrppln
        case xrpgbp
        case xrpusd
        case xrpeur
        case xrpbtc
        
        case xinpln
        case xinusd
        case xineur
        case xinbtc
        
        case zecpln
        case zecusd
        case zeceur
        case zecbtc
        
        case gntpln
        case gntusd
        case gnteur
        case gntbtc
        
        case omgpln
        case omgusd
        case omgeur
        case omgbtc
        
        case ftopln
        case ftousd
        case ftoeur
        case ftobtc
        
        case reppln
        case repusd
        case repeur
        case repbtc
        
        case batpln
        case batusd
        case bateur
        case batbtc
        
        case zrxpln
        case zrxusd
        case zrxeur
        case zrxbtc
        
        case paypln
        case payusd
        case payeur
        case paybtc
        
        case neupln
        case neuusd
        case neueur
        case neubtc
        
        case trxpln
        case trxusd
        case trxeur
        case trxbtc
        
        case amltpln
        case amltusd
        case amlteur
        case amltbtc
        
        case exypln
        case exyusd
        case exyeur
        case exybtc
        
        case bobpln
        case bobusd
        case bobeur
        case bobbtc
        
        case lmlpln
        case lmlbtc
        
        case xlmpln
        case xlmusd
        case xlmeur
        case xlmbtc
        
        case xbxbtc
        
        case bcppln
        
        case bsvpln
        case bsvusd
        case bsveur
        case bsvbtc
        
        case usdcusd
        
        var baseCurrencyNameLength: Int {
            switch self {
            case .btcpln, .btcgbp, .btcusd, .btceur, .btcusdc,
                 .ltcpln, .ltcgbp, .ltcusd, .ltceur, .ltcbtc,
                 .ethpln, .ethgbp, .ethusd, .etheur, .ethbtc, .ethusdc,
                 .lskpln, .lskusd, .lskeur, .lskbtc,
                 .bccpln, .bccgbp, .bccusd, .bcceur, .bccbtc, .bccusdc,
                 .btgpln, .btgusd, .btgeur, .btgbtc,
                 .kzcpln, .kzcusd, .kzceur, .kzcbtc,
                 .xrppln, .xrpgbp, .xrpusd, .xrpeur, .xrpbtc,
                 .xinpln, .xinusd, .xineur, .xinbtc,
                 .zecpln, .zecusd, .zeceur, .zecbtc,
                 .gntpln, .gntusd, .gnteur, .gntbtc,
                 .omgpln, .omgusd, .omgeur, .omgbtc,
                 .ftopln, .ftousd, .ftoeur, .ftobtc,
                 .reppln, .repusd, .repeur, .repbtc,
                 .batpln, .batusd, .bateur, .batbtc,
                 .zrxpln, .zrxusd, .zrxeur, .zrxbtc,
                 .paypln, .payusd, .payeur, .paybtc,
                 .neupln, .neuusd, .neueur, .neubtc,
                 .trxpln, .trxusd, .trxeur, .trxbtc,
                 .exypln, .exyusd, .exyeur, .exybtc,
                 .bobpln, .bobusd, .bobeur, .bobbtc,
                 .lmlpln, .lmlbtc,
                 .xlmpln, .xlmusd, .xlmeur, .xlmbtc,
                 .xbxbtc,
                 .bcppln,
                 .bsvpln, .bsvusd, .bsveur, .bsvbtc:
                return 3
                
            case .dashpln, .dashusd, .dasheur, .dashbtc,
                 .gamepln, .gameusd, .gameeur, .gamebtc,
                 .amltpln, .amltusd, .amlteur, .amltbtc,
                 .usdcusd:
                return 4
            }
        }
        
        var counterCurrencyNameLength: Int {
            if self == .btcusdc || self == .ethusdc || self == .bccusdc {
                return 4
            } else {
                return 3
            }
        }
    }
    
    let name: Name
    
}
