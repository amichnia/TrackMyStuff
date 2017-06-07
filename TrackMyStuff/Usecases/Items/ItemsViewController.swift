//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BTracker

class ItemsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel: ItemsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        setupUI()
        setupBindings()
        localize()
    }

    private func setupBindings() {
        viewModel.numberOfSections.asObservable().observeOnMain().subscribe(onNext: { _ in
            self.tableView.reloadData()
        }) >>> bag
    }

    private func setupUI() {

    }

    private func localize() {

    }

    @IBAction func addAction(_ sender: Any) {
        viewModel.addNewItem(from: self)
    }
}

extension ItemsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections.value
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemHeaderCell.identifier) as! ItemHeaderCell
        viewModel.setup(header, at: section)
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(R.reuseIdentifier.itemCell, for: indexPath)
        viewModel.setup(cell, at: indexPath)
        return cell
    }
}

extension ItemsViewController: UITableViewDelegate { }
