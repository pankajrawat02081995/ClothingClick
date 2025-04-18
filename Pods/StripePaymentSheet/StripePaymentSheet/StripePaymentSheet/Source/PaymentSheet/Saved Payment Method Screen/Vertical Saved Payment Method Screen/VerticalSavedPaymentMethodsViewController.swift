//
//  VerticalSavedPaymentMethodsViewController.swift
//  StripePaymentSheet
//
//  Created by Nick Porter on 5/7/24.
//

import Foundation
@_spi(STP) import StripeCore
@_spi(STP) import StripePaymentsUI
@_spi(STP) import StripeUICore
import UIKit

@MainActor
protocol VerticalSavedPaymentMethodsViewControllerDelegate: AnyObject {
    /// Handles the selection of a payment method from the list or the modification of the list such as the removal or update of payment methods.
    ///
    /// - Parameters:
    ///    - viewController: The `VerticalSavedPaymentMethodsViewController` that completed its selection
    ///    - selectedPaymentMethod: The selected method of payment, if any.
    ///    - latestPaymentMethods: The most recent up-to-date list of payment methods, with the selected (if any) payment method at the front of the list.
    ///    - didTapToDismiss: Whether or not the customer tapped outside the sheet to dismiss it.
    func didComplete(
        viewController: VerticalSavedPaymentMethodsViewController,
        with selectedPaymentMethod: STPPaymentMethod?,
        latestPaymentMethods: [STPPaymentMethod],
        didTapToDismiss: Bool
    )
}

/// A view controller that shows a list of saved payment methods in a vertical orientation
class VerticalSavedPaymentMethodsViewController: UIViewController {

    // MARK: Private properties
    private let configuration: PaymentElementConfiguration
    private let elementsSession: STPElementsSession
    private let paymentMethodRemove: Bool
    private let isCBCEligible: Bool
    private let analyticsHelper: PaymentSheetAnalyticsHelper

    private var updateViewController: UpdatePaymentMethodViewController?

    private var isEditingPaymentMethods: Bool = false {
        didSet {
            let additionalButtonTitle = isEditingPaymentMethods ? UIButton.doneButtonTitle : UIButton.editButtonTitle
            navigationBar.additionalButton.setTitle(additionalButtonTitle, for: .normal)
            headerLabel.text = headerText

            // If we are entering edit mode, put all buttons in an edit state, otherwise put back in their previous state
            if isEditingPaymentMethods {
                paymentMethodRows.forEach {
                    let allowsRemoval = canRemovePaymentMethods
                    let paymentMethodType = $0.paymentMethod.type
                    let allowsUpdating = UpdatePaymentMethodViewModel.supportedPaymentMethods.contains { type in paymentMethodType == type }
                    $0.state = .editing(allowsRemoval: allowsRemoval,
                                        allowsUpdating: allowsUpdating)
                }
            } else if oldValue {
                // If we are exiting edit mode restore previous selected states
                paymentMethodRows.forEach { $0.state = $0.previousSelectedState }
                navigationBar.setStyle(navigationBarStyle())

                // If we are exiting edit mode and there is only one payment method left which can't be removed, select it and dismiss
                if paymentMethodRows.count == 1, let firstButton = paymentMethodRows.first {
                    firstButton.state = .selected
                    complete(afterDelay: 0.3)
                }
            }
        }
    }

    private var headerText: String {
        if isEditingPaymentMethods {
            return paymentMethods.count == 1 ?  .Localized.manage_payment_method : .Localized.manage_payment_methods
        }

        let nonCardPaymentMethods = paymentMethods.filter({ $0.type != .card })
        return nonCardPaymentMethods.isEmpty ? .Localized.select_card : .Localized.select_payment_method
    }

    var canRemovePaymentMethods: Bool {
        // Can remove a payment method if we have more than one payment method or if we have one payment method and `allowsRemovalOfLastSavedPaymentMethod` is true AND paymentMethodRemove is true
        return (paymentMethodRows.count > 1 ? true : configuration.allowsRemovalOfLastSavedPaymentMethod) && paymentMethodRemove
    }

    var canEditPaymentMethods: Bool {
        return hasCoBrandedCards && isCBCEligible
    }

    /// Indicates whether the chevron should be shown
    /// True if any saved payment methods can be removed or edited
    var canRemoveOrEdit: Bool {
        let hasSupportedSavedPaymentMethods = paymentMethods.allSatisfy{ UpdatePaymentMethodViewModel.supportedPaymentMethods.contains($0.type) }
        guard hasSupportedSavedPaymentMethods else {
            fatalError("Saved payment methods contain unsupported payment methods.")
        }
        return configuration.allowsSetAsDefaultPM || canRemovePaymentMethods || canEditPaymentMethods
    }

    private var selectedPaymentMethod: STPPaymentMethod? {
        return paymentMethodRows.first { $0.isSelected }?.paymentMethod
    }

    private var paymentMethods: [STPPaymentMethod] {
        return paymentMethodRows.map { $0.paymentMethod }
    }

    private var hasCoBrandedCards: Bool {
        return !paymentMethods.filter { $0.isCoBrandedCard }.isEmpty
    }

    private lazy var savedPaymentMethodManager: SavedPaymentMethodManager = {
        SavedPaymentMethodManager(configuration: configuration, elementsSession: elementsSession)
    }()

    // MARK: Internal properties
    weak var delegate: VerticalSavedPaymentMethodsViewControllerDelegate?

    // MARK: - UI properties

    lazy var navigationBar: SheetNavigationBar = {
        let navBar = SheetNavigationBar(isTestMode: configuration.apiClient.isTestmode,
                                        appearance: configuration.appearance)
        navBar.setStyle(navigationBarStyle())
        navBar.delegate = self
        navBar.additionalButton.configureCommonEditButton(isEditingPaymentMethods: isEditingPaymentMethods, appearance: configuration.appearance)
        // TODO(porter) Read color from new secondary action color from appearance
        navBar.additionalButton.setTitleColor(configuration.appearance.colors.primary, for: .normal)
        navBar.additionalButton.setTitleColor(configuration.appearance.colors.primary.disabledColor, for: .disabled)
        navBar.additionalButton.addTarget(self, action: #selector(didSelectEditSavedPaymentMethodsButton), for: .touchUpInside)
        return navBar
    }()

    private lazy var headerLabel: UILabel = {
        let label = PaymentSheetUI.makeHeaderLabel(appearance: configuration.appearance)
        label.text = headerText
        return label
    }()

    private lazy var stackView: UIStackView = {
        let spacerView = UIView(frame: .zero)
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = spacerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = UILayoutPriority(rawValue: 1)
        heightConstraint.isActive = true

        let stackView = UIStackView(arrangedSubviews: [headerLabel] + paymentMethodRows + [spacerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.setCustomSpacing(16, after: headerLabel)
        if let lastPaymentMethodRow = paymentMethodRows.last {
            stackView.setCustomSpacing(0, after: lastPaymentMethodRow)
        }
        return stackView
    }()

    private var paymentMethodRows: [SavedPaymentMethodRowButton] = []

    init(
        configuration: PaymentElementConfiguration,
        selectedPaymentMethod: STPPaymentMethod?,
        paymentMethods: [STPPaymentMethod],
        elementsSession: STPElementsSession,
        analyticsHelper: PaymentSheetAnalyticsHelper
    ) {
        self.configuration = configuration
        self.elementsSession = elementsSession
        self.paymentMethodRemove = elementsSession.allowsRemovalOfPaymentMethodsForPaymentSheet()
        self.isCBCEligible = elementsSession.isCardBrandChoiceEligible
        self.analyticsHelper = analyticsHelper
        super.init(nibName: nil, bundle: nil)
        self.paymentMethodRows = buildPaymentMethodRows(paymentMethods: paymentMethods)
        setInitialState(selectedPaymentMethod: selectedPaymentMethod)
    }

    private func isDefaultPaymentMethod(paymentMethodId: String) -> Bool {
        guard configuration.allowsSetAsDefaultPM, let defaultPaymentMethod = elementsSession.customer?.getDefaultPaymentMethod() else { return false }
        return configuration.allowsSetAsDefaultPM && paymentMethodId == defaultPaymentMethod.stripeId
    }

    private func buildPaymentMethodRows(paymentMethods: [STPPaymentMethod]) -> [SavedPaymentMethodRowButton] {
        return paymentMethods.map { paymentMethod in
            let button = SavedPaymentMethodRowButton(paymentMethod: paymentMethod,
                                                     appearance: configuration.appearance,
                                                     showDefaultPMBadge: isDefaultPaymentMethod(paymentMethodId: paymentMethod.stripeId))
            button.delegate = self
            return button
        }
    }

    private func setInitialState(selectedPaymentMethod: STPPaymentMethod?) {
        paymentMethodRows.first { $0.paymentMethod.stripeId == selectedPaymentMethod?.stripeId }?.state = .selected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = configuration.appearance.colors.background
        configuration.style.configure(self)

        view.addAndPinSubview(stackView, insets: PaymentSheetUI.defaultSheetMargins)

        // Add a height constraint to the view to ensure a minimum height of 200
        let minHeightConstraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: 200 - SheetNavigationBar.height)
        minHeightConstraint.priority = .defaultHigh
        minHeightConstraint.isActive = true
    }

    private func navigationBarStyle() -> SheetNavigationBar.Style {
        if let bottomSheet = self.bottomSheetController,
           bottomSheet.contentStack.count > 1 {
            return .back(showAdditionalButton: canRemoveOrEdit)
        } else {
            return .close(showAdditionalButton: canRemoveOrEdit)
        }
    }

    @objc func didSelectEditSavedPaymentMethodsButton() {
        isEditingPaymentMethods = !isEditingPaymentMethods
    }

    private func remove(paymentMethod: STPPaymentMethod) {
        guard let button = paymentMethodRows.first(where: { $0.paymentMethod.stripeId == paymentMethod.stripeId }) else { return }

        // Detach the payment method from the customer
        savedPaymentMethodManager.detach(paymentMethod: paymentMethod)
        analyticsHelper.logSavedPaymentMethodRemoved(paymentMethod: paymentMethod)

        // Remove the payment method row button
        paymentMethodRows.removeAll { $0.paymentMethod.stripeId == paymentMethod.stripeId }
        stackView.removeArrangedSubview(button, animated: true)

        // Select the first payment method if nothing is selected anymore
        // Note: this isn't necessarily the desired behavior, but the next payment method *will* be selected if you cancel out of the sheet at this point, so it's better to be consistent until we change that.
        if selectedPaymentMethod == nil {
            paymentMethodRows.first?.state = .selected
        }

        // Update the editing state if needed
        isEditingPaymentMethods = canRemoveOrEdit

        // If we deleted the last payment method kick back out to the main screen
        if paymentMethodRows.isEmpty {
            complete()
        }
    }

    private func complete(didTapToDismiss: Bool = false, afterDelay: TimeInterval = 0.0) {
        // Note this dispatch async gives a brief delay, even when `afterDelay` is 0
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) { [weak self] in
            guard let self = self else { return }
            // Edge-case: Dismiss `UpdateViewController` if presented, this can occur if `complete` is called before `UpdateViewController` is popped when we remove the last payment method via the `UpdateViewController`
            _ = self.updateViewController?.bottomSheetController?.popContentViewController()

            var latestPaymentMethods = self.paymentMethods
            // Move selected payment method to the front of `latestPaymentMethods`
            if let selectedPaymentMethod = self.selectedPaymentMethod {
                latestPaymentMethods.remove(selectedPaymentMethod)
                latestPaymentMethods.insert(selectedPaymentMethod, at: 0)
            }
            self.delegate?.didComplete(
                viewController: self,
                with: self.selectedPaymentMethod,
                latestPaymentMethods: latestPaymentMethods,
                didTapToDismiss: didTapToDismiss
            )
        }
    }
}

// MARK: - BottomSheetContentViewController
extension VerticalSavedPaymentMethodsViewController: BottomSheetContentViewController {
    var allowsDragToDismiss: Bool {
        return true
    }

    func didTapOrSwipeToDismiss() {
        complete(didTapToDismiss: true)
    }

    var requiresFullScreen: Bool {
        return false
    }
}

// MARK: - SheetNavigationBarDelegate
extension VerticalSavedPaymentMethodsViewController: SheetNavigationBarDelegate {
    func sheetNavigationBarDidClose(_ sheetNavigationBar: SheetNavigationBar) {
        // 'back' closed used in:
        //  Embedded
        complete()
    }

    func sheetNavigationBarDidBack(_ sheetNavigationBar: SheetNavigationBar) {
        // 'back' style used in:
        //  PS.Complete & Vertical
        //  PS.FC & Vertical
        complete()
    }
}

// MARK: - PaymentMethodRowButtonDelegate
extension VerticalSavedPaymentMethodsViewController: SavedPaymentMethodRowButtonDelegate {

    func didSelectButton(_ button: SavedPaymentMethodRowButton, with paymentMethod: STPPaymentMethod) {
        analyticsHelper.logSavedPMScreenOptionSelected(option: .saved(paymentMethod: paymentMethod))
        // Set payment method as default
        CustomerPaymentOption.setDefaultPaymentMethod(
            .stripeId(paymentMethod.stripeId),
            forCustomer: configuration.customer?.id
        )

        // Deselect previous button
        paymentMethodRows.first { $0 != button && $0.isSelected }?.state = .unselected

        // Disable interaction to prevent double selecting or entering edit mode since we will be dismissing soon
        self.view.isUserInteractionEnabled = false
        self.navigationBar.isUserInteractionEnabled = false

        self.complete()
    }

    func didSelectUpdateButton(_ button: SavedPaymentMethodRowButton, with paymentMethod: STPPaymentMethod) {
        let updateViewModel = UpdatePaymentMethodViewModel(paymentMethod: paymentMethod,
                                                           appearance: configuration.appearance,
                                                           hostedSurface: .paymentSheet,
                                                           cardBrandFilter: configuration.cardBrandFilter,
                                                           canEdit: paymentMethod.isCoBrandedCard && isCBCEligible,
                                                           canRemove: canRemovePaymentMethods)
        let updateViewController = UpdatePaymentMethodViewController(
                                                            removeSavedPaymentMethodMessage: configuration.removeSavedPaymentMethodMessage,
                                                            isTestMode: configuration.apiClient.isTestmode,
                                                            viewModel: updateViewModel)
        updateViewController.delegate = self
        self.updateViewController = updateViewController
        self.bottomSheetController?.pushContentViewController(updateViewController)
    }
}

// MARK: - UpdatePaymentMethodViewControllerDelegate
extension VerticalSavedPaymentMethodsViewController: UpdatePaymentMethodViewControllerDelegate {
    func didRemove(viewController: UpdatePaymentMethodViewController, paymentMethod: STPPaymentMethod) {
        remove(paymentMethod: paymentMethod)
       _ = viewController.bottomSheetController?.popContentViewController()
    }

    func didUpdate(viewController: UpdatePaymentMethodViewController, paymentMethod: STPPaymentMethod, updateParams: STPPaymentMethodUpdateParams) async throws {
        // Update the payment method
        let updatedPaymentMethod = try await savedPaymentMethodManager.update(paymentMethod: paymentMethod, with: updateParams)

        replace(paymentMethod: paymentMethod, with: updatedPaymentMethod)
        _ = viewController.bottomSheetController?.popContentViewController()
    }

    func shouldCloseSheet(_: UpdatePaymentMethodViewController) {
        complete(didTapToDismiss: true)
    }

    private func replace(paymentMethod: STPPaymentMethod, with updatedPaymentMethod: STPPaymentMethod) {
        guard let oldButton = paymentMethodRows.first(where: { $0.paymentMethod.stripeId == paymentMethod.stripeId }),
              let oldButtonModelIndex = paymentMethodRows.firstIndex(of: oldButton),
              let oldButtonViewIndex = stackView.arrangedSubviews.firstIndex(of: oldButton) else {
            stpAssertionFailure("Unable to retrieve the original button/payment method for replacement.")
            return
        }

        // Create the new button
        let newButton = SavedPaymentMethodRowButton(paymentMethod: updatedPaymentMethod, appearance: configuration.appearance, showDefaultPMBadge: isDefaultPaymentMethod(paymentMethodId: updatedPaymentMethod.stripeId))

        newButton.delegate = self
        newButton.previousSelectedState = oldButton.previousSelectedState
        newButton.state = oldButton.state

        // Replace the old button with the new button in the model
        paymentMethodRows[oldButtonModelIndex] = newButton

        // Replace the old button with the new button in the stack view
        oldButton.removeFromSuperview()
        stackView.insertArrangedSubview(newButton, at: oldButtonViewIndex)
    }

}
