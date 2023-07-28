extends Object
class_name SignalHelper

static func nodeHasSignal(node: Node, signalName: String):
    var hasSignal: bool = false

    for sig in node.get_signal_list():
        if(sig.name == signalName):
            hasSignal = true

    return hasSignal