import Foundation

protocol TypeIndexer: AnyObject {
    static func make(buildPlan: BuildPlan, indexStore: IndexStore, graph: SourceGraph) -> Self
    func perform() throws
}

final class Indexer {
    static func perform(buildPlan: BuildPlan, indexStore: IndexStore, graph: SourceGraph) throws {
        try make(buildPlan: buildPlan, indexStore: indexStore, graph: graph).perform()
    }

    static func make(buildPlan: BuildPlan, indexStore: IndexStore, graph: SourceGraph) -> Self {
        return self.init(buildPlan: buildPlan, indexStore: indexStore, graph: graph, configuration: inject())
    }

    private let buildPlan: BuildPlan
    private let indexStore: IndexStore
    private let graph: SourceGraph

    private let indexers: [TypeIndexer.Type]

    required init(buildPlan: BuildPlan, indexStore: IndexStore, graph: SourceGraph, configuration: Configuration) {
        self.buildPlan = buildPlan
        self.indexStore = indexStore
        self.graph = graph
        self.indexers = [
            IndexStoreIndexer.self,
            XibIndexer.self
        ]
    }

    func perform() throws {
        try indexers.forEach {
            try $0.make(buildPlan: buildPlan, indexStore: indexStore, graph: graph).perform()
        }
    }
}
