//
//  AuthService.swift
//  AutoParkingNetwork
//
//  Created by Saleh Majidov on 24/06/2024.
//

import Moya

public protocol AuthServiceProtocol: BaseServiceProtocol {
    
    func step1(operatorValue: String, number: String, completion: @escaping (Result<Step1Response, WrongResponse>) -> ())
    
    func step2(request: Step2Request, completion: @escaping (Result<Step2Response, WrongResponse>) -> ())
    
    func logout(token: String, completion: @escaping (Result<NoResponse, WrongResponse>) -> ())
    
    func getPaymentCards(token: String, completion: @escaping (Result<PaymentMethodResponse, WrongResponse>) -> ())
    
    func startBook(token: String, parkId: String, selectedCarId: String, selectedPaymentMethod: PaymentMethod, completion: @escaping (Result<BookingAddResponse, WrongResponse>) -> ())
    
    func stopBook(token: String, userParkId: String, completion: @escaping (Result<PaymentMethodResponse, WrongResponse>) -> ())
}

public class AuthService: BaseService, AuthServiceProtocol {
    
    private var provider: MoyaProvider<AuthAPI>!
    
    var timestamp = Int(Date().timeIntervalSince1970)
    
    override init() {
        super.init()
        
            #if DEBUG
            let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
            self.provider = MoyaProvider<AuthAPI>(plugins: [self.authPlugin, networkLoggerPlugin])
            #else
//            self.provider = MoyaProvider<AuthAPI>(plugins: [self.authPlugin, self.languagePlugin])
            #endif

        
    }
    
    public func step1(operatorValue: String, number: String, completion: @escaping (Result<Step1Response, WrongResponse>) -> ()) {
        let timestamp = Int(Date().timeIntervalSince1970)
        self.request(provider, target: .step1(operatorValue: operatorValue, number: number, ts: timestamp)) { result in
    
            completion(result)
        }
    }
    
    public func step2(request: Step2Request, completion: @escaping (Result<Step2Response, WrongResponse>) -> ()) {
        self.request(provider, target: .step2(request: request)) { result in
    
            completion(result)
        }
    }
    
    public func logout(token: String, completion: @escaping (Result<NoResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .logout(token: token)) { result in
    
            completion(result)
        }
    }
    
    public func getPaymentCards(token: String, completion: @escaping (Result<PaymentMethodResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .fetchPaymentMethods(token: token)) { result in
    
            completion(result)
        }
    }
    
    public func startBook(token: String, parkId: String, selectedCarId: String, selectedPaymentMethod: PaymentMethod, completion: @escaping (Result<BookingAddResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .addBooking(token: token, parkId: parkId, selectedCarId: selectedCarId, selectedPaymentMethod: selectedPaymentMethod)) { result in
    
            completion(result)
        }
    }
    
    public func stopBook(token: String, userParkId: String, completion: @escaping (Result<PaymentMethodResponse, WrongResponse>) -> ()) {
        self.request(provider, target: .stopBooking(token: token, userParkId: userParkId)) { result in
    
            completion(result)
        }
    }
}
