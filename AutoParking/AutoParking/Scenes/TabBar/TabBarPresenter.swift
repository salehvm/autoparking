//
//  TabBarPresenter.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol TabBarPresentationLogic
{
  func presentSomething(response: TabBar.Something.Response)
}

class TabBarPresenter: TabBarPresentationLogic
{
  weak var viewController: TabBarDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: TabBar.Something.Response)
  {
    let viewModel = TabBar.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
