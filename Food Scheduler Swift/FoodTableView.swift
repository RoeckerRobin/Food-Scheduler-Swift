import SwiftUI

 struct FoodTableView: View {
    
     @State  var foodList: [Food] = []
    @Environment(\.managedObjectContext) var moc
    @State private var selection: String?
    @State private var showAddPopup: Bool = false;
    @State private var showTestPopup: Bool = false;
    @State private var name: String = "";
    @State private var expiryDate = Date();
    @State private var numberOfObjectsGeneratedPerSecond: String = "";
    @State private var numberOfSeconds: String = "";
    private var key = "food_key"
     
    init() {
    }
     
     func getItems(foodList: inout [Food]) {
         guard
            let data = UserDefaults.standard.data(forKey: key),
            let savedItems = try? JSONDecoder().decode([Food].self, from: data)
         else { return }
         foodList = savedItems
         print("getItems")
         for savedItem in savedItems {
             name = savedItem.name;
             expiryDate = savedItem.expiryDate;
             addFoodItem(foodList: &self.foodList);
             print(savedItem.name)
         }
     }
     
     func saveItems(savedFoodList: [Food]) {
         if let encodedData = try? JSONEncoder().encode(savedFoodList) {
             UserDefaults.standard.set(encodedData, forKey: key)
         }
     }
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    HStack {
                        Text("Name")
                            .font(.title3)
                            .fontWeight(.bold);
                        Spacer();
                        Text("Expiry Date")
                            .font(.title3)
                            .fontWeight(.bold);
                    }
                    ForEach(foodList) { [self]food in
                            HStack {
                                Text(food.name)
                                Spacer()
                                Text(self.dateToString(date: food.expiryDate))
                        }
                        }.onDelete(perform: removeFoodItem)
                }.navigationTitle(Text("Food Scheduler"))
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            EditButton();
                        };ToolbarItem(placement: .navigationBarLeading) {
                            Button("Load", action: {
                                getItems(foodList: &self.foodList)
                            })
                        }
                        ToolbarItem(placement: .automatic) {
                            Button("Test Swift", action: {
                                self.clearTestForm()
                                self.showTestPopup = true;
                            }).popover(
                                isPresented: self.$showTestPopup,
                                arrowEdge: .bottom){
                                    self.testPopUp
                                }
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button("Add", action: {
                                self.clearAddForm()
                                self.showAddPopup = true;
                            }).popover(
                                isPresented: self.$showAddPopup,
                                arrowEdge: .bottom){
                                    self.addPopUp
                                }
                        }
                    }
            }
        }
    }
    
    func clearAddForm()
    {
        name = "";
        expiryDate = Date.now;
    }
    
    func clearTestForm()
    {
        numberOfSeconds = "";
        numberOfObjectsGeneratedPerSecond = "";
    }
    
    func addFoodItem(foodList: inout [Food])
    {
        self.showAddPopup = false;
        var newItem = Food(name: name, expiryDate: expiryDate);
        foodList.append(newItem);
        foodList.sort(by: {$0.expiryDate.compare($1.expiryDate) == .orderedAscending})
        print("Add")
        print(foodList)
        saveItems(savedFoodList: foodList)
    }
    
    func testSwift()
    {
        Task {
            var testArray: Array<NSObject> = Array()
            for i in 1...Int(numberOfSeconds)! {
                for j in 1...Int(numberOfObjectsGeneratedPerSecond)! {
                    testArray.append(NSObject())
                    print("Test")
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }

    func removeFoodItem(index: IndexSet)
    {
        if let first = index.first {
            foodList.remove(at: first)
            foodList.sort(by: {$0.expiryDate.compare($1.expiryDate) == .orderedAscending})
        }
        saveItems(savedFoodList: foodList)
    }
    
    func editFoodItem(index: IndexSet)
    {
        if let first = index.first {
            foodList.remove(at: first)
            foodList.sort(by: {$0.expiryDate.compare($1.expiryDate) == .orderedAscending})
        }
    }
    
    func dateToString(date: Date) -> String
    {
        let customFormatter = DateFormatter();
        customFormatter.dateFormat = "HH:mm d.M.yy";
        return customFormatter.string(from: date)
    }
    
    var addPopUp: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                DatePicker(
                    "Start Date",
                    selection: $expiryDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .bottomBar){
                    Button("Cancel"){
                        self.showAddPopup = false;
                    }
                }
                ToolbarItem(placement: .bottomBar){
                    Button("Confirm"){
                        self.addFoodItem(foodList: &self.foodList);
                        self.showAddPopup = false;
                    }.disabled(name.isEmpty || name.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
                }
            }
        }
    }
    
    var testPopUp: some View {
        NavigationView {
            Form {
                TextField("Number of objects generated per second", text: $numberOfObjectsGeneratedPerSecond).keyboardType(.numberPad)
                TextField("Number of seconds", text: $numberOfSeconds).keyboardType(.numberPad)
            }
            .navigationTitle("Test Swift")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        self.showTestPopup = false;
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Confirm"){
                        self.showTestPopup = false;
                        self.testSwift()
                    }.disabled(numberOfSeconds.isEmpty || numberOfObjectsGeneratedPerSecond.isEmpty)
                }
            }
        }
    }
    
    var editPopUp: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                DatePicker(
                    "Start Date",
                    selection: $expiryDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .bottomBar){
                    Button("Cancel"){
                        self.showAddPopup = false;
                    }
                }
                ToolbarItem(placement: .bottomBar){
                    Button("Confirm"){
                        self.addFoodItem(foodList: &self.foodList);
                        self.showAddPopup = false;
                    }
                }
            }
        }
    }
}

struct FoodTableView_Previews: PreviewProvider {
    static var previews: some View {
        FoodTableView()
    }
}
