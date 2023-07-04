//import UIKit
//
//// MARK: - TodoItemDetailsViewController
//
//final class TodoItemDetailsViewController: UIViewController {
//    var didAddItem: ((ToDoItem) -> Void)?
//    
//    private lazy var navBarContainerView = makeNavBarContainerView()
//    private lazy var leftBarButton = makeLeftBarButton()
//    private lazy var titleLabel = makeTitleLabel()
//    private lazy var rightBarButton = makeRightBarButton()
//    private lazy var scrollView = makeScrollView()
//    private lazy var stackView = makeStackView()
//    private lazy var textView = makeTextView()
//    private lazy var detailsView = makeDetailsView()
//    private lazy var deleteButton = makeDeleteButton()
//    
//    private var newText: String? {
//        didSet {
//            guard let newText else {
//                return
//            }
//            
//            rightBarButton.isEnabled = !newText.isEmpty
//        }
//    }
//
//    private var selectedPriority: ToDoItem.Priority = .medium
//    private var selectedDeadlineDate: Date?
//    private var selectedColor: UIColor?
//    
//    private let item: ToDoItem?
//    
//    init(item: ToDoItem? = nil) {
//        self.item = item
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        nil
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupObservers()
//        setup()
//        setupItemIfNeeded()
//    }
//    
//    
//    @objc
//    private func didTapBarButton(sender: UIButton) {
//        sender.isSelected.toggle()
//        switch sender {
//        case leftBarButton:
//            dismiss(animated: true)
//        case rightBarButton:
//            guard let newText else {
//                return
//            }
//            
//            let item = ToDoItem(
//                text: newText,
//                priority: selectedPriority,
//                deadline: selectedDeadlineDate,
//                isCompleted: false,
//                createDate: Date(),
//            )
//        
//            didAddItem?(item)
//            dismiss(animated: true)
//        default:
//            break
//        }
//    }
//    
//    @objc
//    private func didTapDeleteButton() {
//        print("Delete button did tap")
//    }
//    
//    private func setupObservers() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//    
//    private func setup() {
//        [
//            navBarContainerView,
//            scrollView
//        ].forEach { view.addSubview($0) }
//        
//        view.keyboardLayoutGuide.followsUndockedKeyboard = true
//        
//        setupColors()
//        setupConstraints()
//    }
//
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate(
//            [
//                navBarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                navBarContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                navBarContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                navBarContainerView.heightAnchor.constraint(equalToConstant: 56)
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                leftBarButton.centerYAnchor.constraint(equalTo: navBarContainerView.centerYAnchor),
//                leftBarButton.leadingAnchor.constraint(
//                    equalTo: navBarContainerView.leadingAnchor,
//                    constant: 16
//                )
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                titleLabel.centerXAnchor.constraint(equalTo: navBarContainerView.centerXAnchor),
//                titleLabel.centerYAnchor.constraint(equalTo: navBarContainerView.centerYAnchor)
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                rightBarButton.centerYAnchor.constraint(equalTo: navBarContainerView.centerYAnchor),
//                rightBarButton.trailingAnchor.constraint(
//                    equalTo: navBarContainerView.trailingAnchor,
//                    constant: -16
//                )
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                scrollView.topAnchor.constraint(equalTo: navBarContainerView.bottomAnchor),
//                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
//            ]
//        )
//        NSLayoutConstraint.activate(
//            [
//                textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
//            ]
//        )
//    }
//    
//    private func setupItemIfNeeded() {
//        guard let item else {
//            return
//        }
//        
//        textView.text = item.text
//    }
//    
//    private func makeNavBarContainerView() -> UIView {
//        let view = UIView()
//        [
//            leftBarButton,
//            titleLabel,
//            rightBarButton
//        ].forEach { view.addSubview($0) }
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }
//    
//    private func makeLeftBarButton() -> UIButton {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(didTapBarButton), for: .touchUpInside)
//        button.setTitle("Отменить", for: .normal)  // TODO: - Localize
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }
//    
//    private func makeRightBarButton() -> UIButton {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(didTapBarButton), for: .touchUpInside)
//        button.isEnabled = (item != nil)
//        button.setTitle("Сохранить", for: .normal)  // TODO: - Localize
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }
//    
//    private func makeTitleLabel() -> UILabel {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.text = "Дело" // TODO: - Localize
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//    
//    private func makeScrollView() -> UIScrollView {
//        let scrollView = UIScrollView()
//        scrollView.addSubview(stackView)
//        scrollView.alwaysBounceVertical = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }
//    
//    private func makeStackView() -> UIStackView {
//        let stackView = UIStackView(
//            arrangedSubviews: [
//                textView,
//                detailsView,
//                deleteButton
//            ]
//        )
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }
//    
//    private func makeTextView() -> UITextView {
//        let textView = UITextView()
//        textView.delegate = self
//        textView.isScrollEnabled = false
//        textView.layer.cornerRadius = 16
//        textView.text = "Что надо сделать?"
//        textView.textContainerInset = UIEdgeInsets(
//            top: 16,
//            left: 16,
//            bottom: 16,
//            right: 16
//        )
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }
//    
//    private func makeDetailsView() -> UIView {
//        let view = TodoItemDetailsView(item: item)
//        view.delegate = self
//        return view
//    }
//    
//    private func makeDeleteButton() -> UIControl {
//        let button = DeleteControl()
//        button.isEnabled = (item != nil)
//        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
//        return button
//    }
//}
//
//// MARK: - TodoItemDetailsViewDelegate: UITextViewDelegate
//
//extension TodoItemDetailsViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        newText = textView.text
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = ""
//        textView.textColor = DSColor.labelPrimary.color
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        guard !textView.text.isEmpty else {
//            textView.text = "Что надо сделать?" // TODO: - Localize
//            textView.textColor = DSColor.labelTertiary.color
//            return
//        }
//        
//        textView.textColor = DSColor.labelPrimary.color
//    }
//}
//
//// MARK: - TodoItemDetailsViewDelegate
//
//extension TodoItemDetailsViewController: TodoItemDetailsViewDelegate {
//    func didSelectPriority(_ priority: TodoItem.Priority) {
//        selectedPriority = priority
//    }
//    
//    func didSelectDeadline(_ date: Date?) {
//        selectedDeadlineDate = date
//    }
//    
//    func didSelectColor(_ color: UIColor?) {
//        selectedColor = color
//    }
//}
