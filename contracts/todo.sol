pragma solidity 0.8.0;

// SPDX-License-Identifier: MIT

contract todo {
    uint public taskCounter = 0;
    mapping(uint => Task) public tasks;

    struct Task {
        uint id;
        string description;
        bool completed;
    }

    event TaskCreated(
        uint id,
        string description
    );

    event TaskCompleted(
        uint id
    );

    event TaskDeleted(
        uint id
    );

    constructor() {
    }

    function createTask(string memory _taskDescription) public {
        taskCounter++;
        tasks[taskCounter] = Task(taskCounter, _taskDescription, false);
        emit TaskCreated(taskCounter, _taskDescription);
    }

    function completeTask(uint _id) public {
        Task memory _task = tasks[_id];
        _task.completed = true;
        tasks[_id] = _task;
        emit TaskCompleted(_id);
    }

    function deleteTask(uint _id) public {
        delete tasks[_id];
        emit TaskDeleted(_id);
    }
}