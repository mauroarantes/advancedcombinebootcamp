//
//  AdvancedCombineBootcamp.swift
//  AdvancedCombineBootcamp
//
//  Created by Mauro Arantes on 11/02/2022.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher: [String] = []
//    @Published var basicPublisher: String = "first publish"
//    let currentValuePublisher = CurrentValueSubject<Int, Never>("first publish")
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
//        let items = ["one", "two", "three"]
        let items: [Int] = Array(1..<11)
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
//                self.basicPublisher = items[x]
//                self.currentValuePublisher.send(items[x])
                self.passThroughPublisher.send(items[x])
                
                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}

class AdvancedCombineBootcampViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var error: String = ""
    //The data service is usually injected in init
    let dataService = AdvancedCombineDataService()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.passThroughPublisher
        
            //Sequence Operations
        /*
//            .first()
//            .first(where: { int in
//                return int > 4
//            })
//            .first(where: {$0 > 4})
//            .tryFirst(where: { int in
//                if int == 3 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1
//            })
//            .last()
//            .last(where: {$0 < 4})
//            .tryLast(where: { int in
//                if int == 13 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1
//            })
//            .dropFirst(3)
//            .tryDrop(while: { int in
//                if int == 15 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 6
//            })
//            .prefix(4)
//            .prefix(while: {$0 < 5})
//            .output(at: 1)
//            .output(in: 2..<4)  */
        
        //Math Operations
        /*
//            .max()
//            .max(by: { int1, int2 in
//                return int1 < int2
//            })
//            .min()
//            .tryMin(by: ) */
        
        //Filter/Reduce Operations
//            .map()
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
//            .compactMap({ int in
//                if int == 5 {
//                    return nil
//                }
//                return String(int)
//            })
//            .tryCompactMap()
//            .filter({($0 > 3) && ($0 < 7)})
//            .tryFilter()
//            .removeDuplicates()
//            .replaceNil(with: 5)
//            .replaceEmpty(with: )
//            .replaceError(with: )
//            .scan(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .scan(0, {$0 + $1})
//            .scan(0, +)
//            .reduce(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .reduce(0, +)
//            .collect(3)
//            .allSatisfy({$0 < 50})
//            .debounce(for: 0.5, scheduler: DispatchQueue.main)
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
//            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
        
            .map({String($0)})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error)"
//                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedValue in
//                self?.data = returnedValue
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
    }
    
}

struct AdvancedCombineBootcamp: View {
    
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self){
                    Text($0)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
