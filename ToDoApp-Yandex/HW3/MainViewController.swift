import UIKit

class MainViewController: UIViewController {
    let networkingService = DefaultNetworkingService()
    let fileCache = FileCache()
    let dateFormatter = DateFormatter()
    let scrollView = UIScrollView()
    let containerView = UIView()
    let showButton = UIButton()
    var hideCompleted = false {
        didSet {
            tableView.reloadData()
        }
    }
    var tableViewHeightConstraint: NSLayoutConstraint?
    private lazy var counterLabel = UILabel()

    private lazy var stackView = setupStackView()
    private lazy var tableView = setupTableView()
    
    var visibleItems: [ToDoItem] {
        return hideCompleted ? fileCache.items.filter { !$0.done } : fileCache.items
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let newToDoItem = ResponseItem(id: UUID().uuidString,
                                       text: "Updated Item",
                                       importance: .basic,
                                       deadline: Double(Int64(Date().timeIntervalSince1970)),
                                       done: false,
                                       color: "#FFFFFF",
                                       created_at: Double(Int64(Date().timeIntervalSince1970)),
                                       changed_at: Double(Int64(Date().timeIntervalSince1970)),
                                       last_updated_by: "Beka's iPhone1")
//        networkingService.addTodoItem(newToDoItem, revision: 13){result in
//            switch result{
//            case .success(let item):
//                print("Succesfully added newToDoItem: \(item)")
//            case .failure(let item):
//                print("Failed to add newToDoItem: \(item)")
//            }
//        }
//        networkingService.getTodoItem(withId:"ABCDEF"){result in
//            switch result{
//            case .success(let item):
//                print("Succesfully found ToDoItem: \(item)")
//            case .failure(let item):
//                print("Failed to finding ToDoItem: \(item)")
//            }
//        }
//        networkingService.getToDoItems { result in
//                    switch result {
//                    case .success(let items):
//                        print("Successfully fetched todo items: ")//\(items)
//                    case .failure(let error):
//                        print("Failed to fetch todo items: \(error)")
//                    }
//                }
        networkingService.updateTodoItem(withId: "ABCDEF", item: newToDoItem){ result in
            switch result{
            case .success(let item):
                print ("Succesfully update ToDoItem: \(item)")
            case .failure(let error):
                print(newToDoItem)
                print("Falied to update ToDoItem: \(error)")
            }
            
        }
        
        
        dateFormatter.dateFormat = "dd MMM"
        
        fileCache.items = fileCache.loadFromJSONFile(named: "Tasks.geojson")
        setupNavigationBar()
        view.addSubview(scrollView)
        self.scrollView.backgroundColor = UIColor(named: "BackiOSPrimary")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        let addNewTaskButton = setupNewTaskButton()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewHeightConstraint?.isActive = false
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        tableViewHeightConstraint?.isActive = true
        
        let contentRect: CGRect = self.containerView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        updateCounterLabel()
        self.scrollView.contentSize = contentRect.size
        
        
    }
    
    @objc func updateTableViewHeight() {
        //print("updateTableViewHeight")
        tableViewHeightConstraint?.constant = tableView.contentSize.height
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    func saveItemsToJSONFile() {
        fileCache.saveToJSONFile(named: "Tasks.geojson")
    }
    func setupStackView() -> UIStackView{
        let stackView = UIStackView()
        
        showButton.setTitle("Скрыть", for: .normal)
        showButton.widthAnchor.constraint(equalToConstant: 148).isActive = true
        showButton.titleLabel?.textAlignment = .right
        showButton.contentHorizontalAlignment = .right
        showButton.setTitleColor(UIColor(named: "ColorBlue"), for: .normal) //
        showButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        
        
        counterLabel.widthAnchor.constraint(equalToConstant: 148).isActive = true
        counterLabel.textAlignment = .left
        counterLabel.textColor = UIColor(named: "LabelTertiary")
        counterLabel.text = "Выполнено - 0"
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.addArrangedSubview(counterLabel)
        stackView.addArrangedSubview(showButton)
        return stackView
    }
    func checkFileExistence() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory?.appendingPathComponent("Tasks.geojson")
        
        if let fileURL = fileURL {
            if fileManager.fileExists(atPath: fileURL.path) {
                print("The file exists at path: \(fileURL.path)")
            } else {
                print("The file does not exist at path: \(fileURL.path)")
            }
        } else {
            print("Invalid file URL")
        }
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = scrollView.backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Mои дела"
        self.navigationController?.navigationBar.layoutMargins.left = 32
        
    }
    
    func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.backgroundColor = UIColor(named: "BackSecondary")
        tableView.layer.cornerRadius = 15
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }
    func setupNewTaskButton() -> UIButton{
        let addNewTaskButton = UIButton()
        addNewTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addNewTaskButton.addTarget(self, action: #selector(addNewTaskButtonTapped), for: .touchUpInside)
        view.addSubview(addNewTaskButton)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 44, weight: .medium, scale: .large)
        let symbolImage = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfiguration)
        addNewTaskButton.setImage(symbolImage, for: .normal)
        NSLayoutConstraint.activate([
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 100),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 100),
            addNewTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewTaskButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        return addNewTaskButton
    }
    
    
    @objc func showButtonTapped() {
       // print("showButtonTapped")
        hideCompleted = false
        showButton.setTitle("Скрыть", for: .normal)
        showButton.removeTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        tableView.reloadData()
    }
    
    @objc func hideButtonTapped(){
      //  print("hideButtonTapped")
        hideCompleted = true
        showButton.setTitle("Показать", for: .normal)
        showButton.removeTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        tableView.reloadData()
    }
    
    @objc func addNewTaskButtonTapped() {
        let newTaskVC = ViewController()
        newTaskVC.didSaveItem = { [weak self] newItem in
            self?.fileCache.addItem(item: newItem)
            self?.fileCache.saveToJSONFile(named: "Tasks.geojson")
            self?.tableView.reloadData() // Reload the table view to reflect the changes
            self?.updateTableViewHeight()
        }
        present(newTaskVC, animated: true)
    }
    func updateCounterLabel(){
        let completedCount = fileCache.items.filter { $0.done }.count
      //  print("filecacheitems: \(fileCache.items)")
        if let counterLabel = stackView.arrangedSubviews.first as? UILabel {
            counterLabel.text = "Выполнено - \(completedCount)"
        }
    }
}
