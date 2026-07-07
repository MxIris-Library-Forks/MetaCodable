struct OrderedDictionary<Key: Hashable, Value>: ExpressibleByDictionaryLiteral, Sequence {
    typealias Element = (key: Key, value: Value)

    private var orderedKeys: [Key] = []
    private var valuesByKey: [Key: Value] = [:]

    init() {}

    init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            self[key] = value
        }
    }

    var isEmpty: Bool {
        orderedKeys.isEmpty
    }

    var values: [Value] {
        orderedKeys.compactMap { valuesByKey[$0] }
    }

    subscript(key: Key) -> Value? {
        get {
            valuesByKey[key]
        }
        set {
            if let newValue {
                if valuesByKey[key] == nil {
                    orderedKeys.append(key)
                }
                valuesByKey[key] = newValue
            } else if valuesByKey.removeValue(forKey: key) != nil {
                orderedKeys.removeAll { $0 == key }
            }
        }
    }

    func makeIterator() -> AnyIterator<Element> {
        var currentIndex = orderedKeys.startIndex
        return AnyIterator {
            while currentIndex < orderedKeys.endIndex {
                let key = orderedKeys[currentIndex]
                currentIndex = orderedKeys.index(after: currentIndex)
                if let value = valuesByKey[key] {
                    return (key, value)
                }
            }
            return nil
        }
    }
}

struct OrderedSet<Element: Hashable>: ExpressibleByArrayLiteral, Sequence {
    private var orderedElements: [Element] = []
    private var containedElements: Set<Element> = []

    init() {}

    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    init<Elements: Sequence>(_ elements: Elements) where Elements.Element == Element {
        for element in elements where containedElements.insert(element).inserted {
            orderedElements.append(element)
        }
    }

    var isEmpty: Bool {
        orderedElements.isEmpty
    }

    func makeIterator() -> IndexingIterator<[Element]> {
        orderedElements.makeIterator()
    }
}
