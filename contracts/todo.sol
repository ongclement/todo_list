pragma solidity 0.8.0;

// SPDX-License-Identifier: MIT

contract todo {
    uint public taskCounter = 0;
    mapping(uint => Task) public tasks;
    enum Priorities { LOW, MEDIUM, HIGH}
    Priorities constant defaultPriority = Priorities.LOW;

    struct Task {
        uint id;
        string description;
        string status;
        uint256 dueDate;
        Priorities priority;
    }

    event TaskCreated(
        uint id,
        string description,
        string status,
        uint256 dueDate,
        Priorities priority
    );

    event TaskStatusUpdated(
        uint id,
        string prevStatus,
        string newStatus
    );

    event TaskDeleted(
        uint id
    );

    constructor() {
    }

    function createTask(string memory _taskDescription, string memory _status, uint256 _dueDate ) public {
        taskCounter++;
        tasks[taskCounter] = Task(taskCounter, _taskDescription, _status, _dueDate, defaultPriority);
        emit TaskCreated(taskCounter, _taskDescription, _status, _dueDate, defaultPriority);
    }

    function createTask(string memory _taskDescription, string memory _status, uint256 _dueDate, uint _priority ) public {
        taskCounter++;
        Priorities priority = Priorities(_priority);
        tasks[taskCounter] = Task(taskCounter, _taskDescription, _status, _dueDate, priority);
        emit TaskCreated(taskCounter, _taskDescription, _status, _dueDate, priority);
    }

    function updateTaskStatus(uint _id, string memory _status) public {
        Task memory _task = tasks[_id];
        string memory _prevStatus = _task.status;
        _task.status = _status;
        tasks[_id] = _task;
        emit TaskStatusUpdated(_id, _prevStatus, _status);
    }

    function deleteTask(uint _id) public {
        delete tasks[_id];
        emit TaskDeleted(_id);
    }

    function getPriority(uint _id) public view returns (string memory) {
        Task memory _task = tasks[_id];
        return getPriorityWithInt(_task.priority);
    }

    function getPriorityWithInt(Priorities _priority) internal pure returns (string memory) {
        require(uint8(_priority) <= 2);

        if (Priorities.LOW == _priority) return "LOW";
        if (Priorities.MEDIUM == _priority) return "MEDIUM";
        if (Priorities.HIGH == _priority) return "HIGH";

        return "";
    }
}