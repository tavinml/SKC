//
//  DatePickerController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 17/11/26.
//

import SwiftUI
import UIKit

final class DatePickerController: UIViewController {
    
    var onDateSelected: ((Date) -> Void)?
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        setupNavigationBar()
    }
    
    @objc
    private func tapCancelButton() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc
    private func tapConfirmButton() {
        let selectedDate = datePicker.date
        
        onDateSelected?(selectedDate)
        
        navigationController?.dismiss(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(datePicker)
        
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
    
    
    private func setupNavigationBar() {
        
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(tapCancelButton))
        
        cancelButton.accessibilityLabel = "Cancelar"
        
        let confirmButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                            style: .prominent,
                                            target: self,
                                            action: #selector(tapConfirmButton))
        
        confirmButton.accessibilityLabel = "Confirmar"
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = confirmButton
    }
    
}

private struct DatePickerControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DatePickerController {
        DatePickerController()
    }
    
    func updateUIViewController(_ uiViewController: DatePickerController, context: Context) {}
}

#Preview {
    DatePickerControllerPreview()
}
