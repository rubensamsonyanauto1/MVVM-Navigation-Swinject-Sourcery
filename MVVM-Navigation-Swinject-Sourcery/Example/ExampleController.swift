import Foundation
import Swinject
import RxSwift

protocol ExampleViewModeling {}

protocol ExampleViewModelContext: HasLocalization, HasAnalytics, HasConfiguration {}
protocol ExampleViewModelService: HasUserService, HasDataService {}
protocol ExampleViewModelBusinessRules: HasLoginBusinessRules, HasLogoutBusinessRules {}

// sourcery: inject
final class ExampleViewModel: ExampleViewModeling {
    private let context: ExampleViewModelContext
    private let service: ExampleViewModelService
    private let businessRules: ExampleViewModelBusinessRules

    // sourcery: inject, skip="anythingElse"
    init(context: ExampleViewModelContext,
         service: ExampleViewModelService,
         businessRules: ExampleViewModelBusinessRules,
         anythingElse: Observable<Bool>) {
        self.context = context
        self.service = service
        self.businessRules = businessRules
    }
}

// sourcery: inject, storyboard=Main
final class ExampleViewController: UIViewController {

    // sourcery: inject
    var viewModel: ExampleViewModeling!
}





// MARK: Generation for APP

protocol HasLocalization {
    var locales: Localization { get }
}
protocol HasAnalytics {
    var analytics: Analytics { get }
}
protocol HasConfiguration {
    var configuration: ConfigurationService { get }
}
protocol HasDataService {
    var data: DataService { get }
}
protocol HasUserService {
    var user: UserService { get }
}
protocol HasLoginBusinessRules {
    var login: LoginBusinessRules { get }
}
protocol HasLogoutBusinessRules {
    var logout: LogoutBusinessRules { get }
}

struct ExampleViewModelContextImpl: ExampleViewModelContext {
    let locales: Localization
    let analytics: Analytics
    let configuration: ConfigurationService
}

struct ExampleViewModelServiceImpl: ExampleViewModelService {
    let user: UserService
    let data: DataService
}

struct ExampleViewModelBusinessRulesImpl: ExampleViewModelBusinessRules {
    let login: LoginBusinessRules
    let logout: LogoutBusinessRules
}

struct ResolverBuilder {
    let resolver: Resolver

    init() {
        resolver = Assembler([DependencyAssembly(),
                              ExampleViewModelAssembly(),
                              ExampleViewControllerAssembly(),
                              RootAssembly(),
                              ListAssembly(),
                              DetailAssembly(),
                              RxList.Assembly(),
                              AlertEventResponderAssembly(),
                              CommonEventResponderAssembly()]).resolver
    }
}

struct ExampleViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExampleViewController.self) { (resolver, anythingElse: Observable<Bool>) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExampleViewController") as! ExampleViewController
            controller.viewModel = resolver.resolve(ExampleViewModeling.self, argument: anythingElse)!
            return controller
        }
    }
}

extension Resolver {
    func resolveExampleViewController(viewModel: String? = nil, navigation: String? = nil, anythingElse: Observable<Bool>) -> ExampleViewController {
        return resolve(ExampleViewController.self, argument: anythingElse)!
    }
}

struct ExampleViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ExampleViewModelContext.self) { resolver in
            return ExampleViewModelContextImpl(locales: resolver.resolve(Localization.self)!,
                                               analytics: resolver.resolve(Analytics.self)!,
                                               configuration: resolver.resolve(ConfigurationService.self)!)
        }

        container.register(ExampleViewModelService.self) { resolver in
            return ExampleViewModelServiceImpl(user: resolver.resolve(UserService.self)!,
                                               data: resolver.resolve(DataService.self)!)
        }

        container.register(ExampleViewModelBusinessRules.self) { resolver in
            return ExampleViewModelBusinessRulesImpl(login: resolver.resolve(LoginBusinessRules.self)!,
                                                     logout: resolver.resolve(LogoutBusinessRules.self)!)
        }

        container.register(ExampleViewModeling.self) { resolver, anythingElse in
            return ExampleViewModel(context: resolver.resolve(ExampleViewModelContext.self)!,
                                        service: resolver.resolve(ExampleViewModelService.self)!,
                                        businessRules: resolver.resolve(ExampleViewModelBusinessRules.self)!,
                                        anythingElse: anythingElse)
        }
    }
}

struct DependencyAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Localization.self) { resolver in
            return LocalizationImpl()
        }.inObjectScope(.weak)

        container.register(Analytics.self) { resolver in
            return AnalyticsImpl()
        }.inObjectScope(.weak)

        container.register(ConfigurationService.self) { resolver in
            return ConfigurationServiceImpl()
        }.inObjectScope(.weak)

        container.register(UserService.self) { resolver in
            return UserServiceImpl()
        }.inObjectScope(.weak)

        container.register(DataService.self) { resolver in
            return DataServiceImpl()
        }.inObjectScope(.weak)

        container.register(LoginBusinessRules.self) { resolver in
            return LoginBusinessRulesImpl()
        }.inObjectScope(.weak)

        container.register(LogoutBusinessRules.self) { resolver in
            return LogoutBusinessRulesImpl()
        }.inObjectScope(.weak)
    }
}

// MARK: Generation for TESTS

final class LocalizationMock: Localization {}
final class AnalyticsMock: Analytics {}
final class ConfigurationServiceMock: ConfigurationService {}
final class DataServiceMock: DataService {}
final class UserServiceMock: UserService {}
final class LoginBusinessRulesMock: LoginBusinessRules {}
final class LogoutBusinessRulesMock: LogoutBusinessRules {}

final class ExampleViewModelContextMock: ExampleViewModelContext {
    let localesMock: LocalizationMock
    var locales: Localization {
        return localesMock
    }
    let analyticsMock: AnalyticsMock
    var analytics: Analytics {
        return analyticsMock
    }
    let configurationMock: ConfigurationServiceMock
    var configuration: ConfigurationService {
        return configurationMock
    }

    init(localesMock: LocalizationMock = LocalizationMock(),
         analyticsMock: AnalyticsMock = AnalyticsMock(),
         configurationMock: ConfigurationServiceMock = ConfigurationServiceMock()) {
        self.localesMock = localesMock
        self.analyticsMock = analyticsMock
        self.configurationMock = configurationMock
    }
}

final class ExampleViewModelServiceMock: ExampleViewModelService {
    let userMock: UserServiceMock
    var user: UserService {
        return userMock
    }
    let dataMock: DataServiceMock
    var data: DataService {
        return dataMock
    }

    init(userMock: UserServiceMock = UserServiceMock(),
         dataMock: DataServiceMock = DataServiceMock()) {
        self.userMock = userMock
        self.dataMock = dataMock
    }
}

final class ExampleViewModelBusinessRulesMock: ExampleViewModelBusinessRules {
    let loginMock: LoginBusinessRulesMock
    var login: LoginBusinessRules {
        return loginMock
    }
    let logoutMock: LogoutBusinessRulesMock
    var logout: LogoutBusinessRules {
        return logoutMock
    }

    init(loginMock: LoginBusinessRulesMock = LoginBusinessRulesMock(),
         logoutMock: LogoutBusinessRulesMock = LogoutBusinessRulesMock()) {
        self.loginMock = loginMock
        self.logoutMock = logoutMock
    }
}

final class ExampleViewModelTestingContext {
    let context: ExampleViewModelContextMock
    let service: ExampleViewModelServiceMock
    let businessRules: ExampleViewModelBusinessRulesMock

    let sut: ExampleViewModel

    init(context: ExampleViewModelContextMock = ExampleViewModelContextMock(),
         service: ExampleViewModelServiceMock = ExampleViewModelServiceMock(),
         businessRules: ExampleViewModelBusinessRulesMock = ExampleViewModelBusinessRulesMock(),
         anythingElse: Observable<Bool>) {
        self.context = context
        self.service = service
        self.businessRules = businessRules

        sut = ExampleViewModel(context: context, service: service, businessRules: businessRules, anythingElse: anythingElse)
    }
}

/*
In test you just do:
var testContext: ExampleViewModelImplTestingContext!

beforeEach {
    testContext = ExampleViewModelImplTestingContext()
}

and you have everything you need for testing
testContext.context.localesMock
testContext.context.analyticsMock
testContext.context.configurationMock
testContext.service.userMock
etc.
*/
