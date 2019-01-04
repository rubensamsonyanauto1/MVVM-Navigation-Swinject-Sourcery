import Foundation

// MARK: Localization

// sourcery: injectable
protocol Localization {}

struct LocalizationImpl: Localization {}

// MARK: Analytics

// sourcery: injectable
protocol Analytics {}

struct AnalyticsImpl: Analytics {}

// MARK: Configuration

// sourcery: injectable
protocol ConfigurationService {}

struct ConfigurationServiceImpl: ConfigurationService {}

// MARK: DataService

// sourcery: injectable
protocol DataService {}

struct DataServiceImpl: DataService {}

// MARK: UserService

// sourcery: injectable
protocol UserService {}

struct UserServiceImpl: UserService {}

// MARK: LoginBusinessRules

// sourcery: injectable
protocol LoginBusinessRules {}

struct LoginBusinessRulesImpl: LoginBusinessRules {}

// MARK: LogoutBusinessRules

// sourcery: injectable
protocol LogoutBusinessRules {}

struct LogoutBusinessRulesImpl: LogoutBusinessRules {}