//
//  TabBarInteractor.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol TabBarBusinessLogic {
  func doSomething(request: TabBar.Something.Request)
}

protocol TabBarDataStore {
  //var name: String { get set }
}

class TabBarInteractor: TabBarBusinessLogic, TabBarDataStore {
  var presenter: TabBarPresentationLogic?
  var worker: TabBarWorker?
  
  func doSomething(request: TabBar.Something.Request) {
    worker = TabBarWorker()
    worker?.doSomeWork()
    
    let response = TabBar.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
