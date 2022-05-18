import SwiftUI

struct Home: View {
    
    @StateObject var taskModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack с закреплённым заголовком
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // MARK: View текущей недели
                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack(spacing: 10) {
                            
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                
                                VStack(spacing: 10) {
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background {
                                    ZStack {
                                        // MARK: Matching Geometry Effect
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(Color("AccentColor"))
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                }
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    tasksView()
                    
                } header: {
                    headerView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        // MARK: - Add Button
        .overlay(
            Button {
                taskModel.addNewTask.toggle()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("AccentColor"), in: Circle())
            }
                .padding()
            , alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            NewTask()
        }
    }
    
    // MARK: - Task View
    func tasksView() -> some View {
        LazyVStack(spacing: 20) {
            
            // Converting object as Our Task Model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                taskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    // MARK: - Task Card View
    func taskCardView(task: Task) -> some View {
        
        // MARK: Since Core Data values will give optional data
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    }
                    .scaleEffect(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0.8)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack {
                
                HStack(alignment: .top, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()) {
                    
                    // MARK: Team Memnbers
                    HStack(spacing: 0) {
                        
                        HStack(spacing: -10) {
                            
                            ForEach(1..<4) { _ in
                                Image("Profile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .stroke(.black, lineWidth: 5)
                                    }
                            }
                        }
                        .hLeading()
                        
                        // MARK: Check Button
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.top)
                }
            }
            .foregroundStyle(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background {
                Color("AccentColor")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            }
        }
        .hLeading()
    }
    
    // MARK: Заголовок
    func headerView() -> some View {
        
        HStack(spacing: 10) {
            VStack {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Сегодня")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: UI вспомогательные функции
extension View {
    
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
}
