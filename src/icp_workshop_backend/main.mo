import Time "mo:base/Time";
import _Iter "mo:base/Iter";
import Text "mo:base/Text";
import List "mo:base/List";
import _Debug "mo:base/Debug";


actor TodoList {
  type Task = {
    id : Nat;
    description : Text;
    completed : Bool;
    timestamp : Int;
  };
let _currentTime : Int = Time.now();
  var tasks : List.List<Task> = List.nil();
public func addTask(description : Text) : async Nat {
  let task : Task = {
    id = 0;
    description = description;
    completed = false;
    timestamp = Time.now();
  };
  tasks := List.push(task, tasks);
  return task.id;
};


public query func getTasks() : async [Task] {
  return List.toArray(tasks);
};

public func getTask(id : Nat) : async ?Task {
  return List.get(tasks, id);
};

//Function to complete a task
public func completeTask(id : Nat) : async Bool {
  var found = false;

  tasks := List.map<Task, Task>(tasks, func(task) {
    if (task.id == id) {
      found := true;
      return {
        id = task.id;
        description = task.description;
        completed = true;
        timestamp = task.timestamp;
      };
    } else {
      return task;
    };
  });

  return found;
};

//Function to delete a task
public func deleteTask(id : Nat) : async Bool {
  var found = false;

  tasks := List.filter<Task>(tasks, func(task) {
    if (task.id == id) {
      found := true;
      return false;
    } else {
      return true;
    };
  });

  return found;
};

//Function to getIncomplete tasks
public query func getIncompleteTasks() : async [Task] {
  return List.toArray(List.filter<Task>(tasks, func(task) {
    return task.completed == false;
  }))
};

//Function to getCompleted tasks
public query func getCompletedTasks() : async [Task] {
  return List.toArray(List.filter<Task>(tasks, func(task) {
    return task.completed == true;
  }));
};

//Function to add a Due Date
public func addDueDate(id : Nat, dueDate : Int) : async Bool {
  var found = false;

  tasks := List.map<Task, Task>(tasks, func(task) {
    if (task.id == id) {
      found := true;
      return {
        id = task.id;
        description = task.description;
        completed = task.completed;
        timestamp = dueDate;
        dueDate = Time.now() + 168 * 60 * 60 * 1000; // 7 days in milliseconds
      };
    } else {
      return task;
    };
  });

  return found;
};

//Function to update task description
public func updateTaskDescription(id : Nat, newDescription : Text) : async Bool {
  var found = false;

  tasks := List.map<Task, Task>(tasks, func(task) {
    if (task.id == id) {
      found := true;
      return {
        id = task.id;
        description = newDescription;
        completed = task.completed;
        timestamp = task.timestamp;
      };
    } else {
      return task;
    };
  });

  return found;
};

//Function to get overdue tasks
public query func getOverdueTasks() : async [Task] {
  return List.toArray(List.filter<Task>(tasks, func(task) {
    return task.timestamp < Time.now();
  }));
};
};
//Function to get tasks by timestamp