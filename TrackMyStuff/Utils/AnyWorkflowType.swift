import Foundation

protocol AnyWorkflowType {
    func push(view: SourceViewType, on: SourceViewType)
    func pop(view: SourceViewType)
    func present(view: SourceViewType, from: SourceViewType)
    func present(view: SourceViewType, from: SourceViewType, completion: VoidCompletionBlock?)
    func dismiss(view: SourceViewType)
    func dismiss(view: SourceViewType, completion: VoidCompletionBlock?)
}

extension AnyWorkflowType {
    func push(view: SourceViewType, on sender: SourceViewType) {
        sender.push(view, animated: true)
    }

    func pop(view: SourceViewType) {
        view.pop(animated: true)
    }

    func present(view: SourceViewType, from sender: SourceViewType) {
        present(view: view, from: sender, completion: nil)
    }

    func present(view: SourceViewType, from sender: SourceViewType, completion: VoidCompletionBlock?) {
        sender.present(view, animated: true, completion: completion)
    }

    func dismiss(view: SourceViewType) {
        dismiss(view: view, completion: nil)
    }

    func dismiss(view: SourceViewType, completion: VoidCompletionBlock?) {
        view.presentingView?.dismiss(animated: true, completion: completion)
    }
}
