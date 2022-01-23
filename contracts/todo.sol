pragma solidity 0.8.0;

// SPDX-License-Identifier: MIT

contract todo {
    address public owner;
    uint public currentIndex = 0;
    uint public totalFriends = 0;
    uint public totalTasks = 0;
    mapping(uint => Task) private tasks;
    enum Priorities { LOW, MEDIUM, HIGH}
    Priorities constant defaultPriority = Priorities.LOW;
    address[] public friends;

    struct Task {
        uint id;
        string description;
        string status;
        uint256 dueDate;
        bool privateTask;
        Priorities priority;
    }

    event TaskCreated(
        uint id,
        string description,
        string status,
        uint256 dueDate,
        bool privateTask,
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

    event FriendAdded(
        address friend
    );

    event FriendRemoved(
        address friend
    );

    constructor() {
        owner = msg.sender;
    }

    modifier _ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    function createTask(string memory _taskDescription, string memory _status, uint256 _dueDate, bool _privateTask ) public {
        tasks[currentIndex] = Task(currentIndex, _taskDescription, _status, _dueDate, _privateTask, defaultPriority);
        emit TaskCreated(currentIndex, _taskDescription, _status, _dueDate, _privateTask, defaultPriority);
        currentIndex++;
        totalTasks++;
    }

    function createTask(string memory _taskDescription, string memory _status, uint256 _dueDate, bool _privateTask, uint _priority ) public {
        Priorities priority = Priorities(_priority);
        tasks[currentIndex] = Task(currentIndex, _taskDescription, _status, _dueDate, _privateTask, priority);
        emit TaskCreated(currentIndex, _taskDescription, _status, _dueDate, _privateTask, priority);
        currentIndex++;
        totalTasks++;
    }

    function updateTaskStatus(uint _id, string memory _status) public {
        Task memory _task = tasks[_id];
        string memory _prevStatus = _task.status;
        _task.status = _status;
        tasks[_id] = _task;
        emit TaskStatusUpdated(_id, _prevStatus, _status);
    }

    function deleteTask(uint _id) public {
        Task memory _task = tasks[_id];
        _task.status = 'deleted';
        tasks[_id] = _task;
        totalTasks--;
        emit TaskDeleted(_id);
    }

    function addFriend(address _toAdd) public {
        friends.push(_toAdd);
        totalFriends++;
        emit FriendAdded(_toAdd);
    }

    function removeFriend(address _toRemove) public {
        for(uint i=0; i<friends.length; i++) {
            if (friends[i] == _toRemove) {
                friends[i] = friends[friends.length - 1];
                friends.pop();
                totalFriends--;
                emit FriendRemoved(_toRemove);
            }
        }
    }

    function getPriority(uint _id) public view returns (string memory) {
        Task memory _task = tasks[_id];
        return getPriorityWithInt(_task.priority);
    }

    function getTasks() public view returns (Task[] memory) {
        require(validAddress(msg.sender), 'Read access denied');

        bool[] memory tasksToReturn = new bool[](currentIndex);
        uint localCounter = 0;

        for (uint256 i=0; i< currentIndex; i++) {
            Task memory _task = tasks[i];
            if (keccak256(abi.encodePacked((_task.status))) != keccak256(abi.encodePacked(('deleted')))) {
                if (msg.sender == owner || !_task.privateTask) {
                    tasksToReturn[i] = true;
                    localCounter++;
                }
            }
        }

        Task[] memory _tasks = new Task[](localCounter);
        uint returnCounter = 0;
        for (uint j=0; j<currentIndex; j++) {
            if (tasksToReturn[j]) {
                _tasks[returnCounter] = tasks[j];
                returnCounter++;
            }
        }

        return _tasks;
    }

    function getPriorityWithInt(Priorities _priority) internal pure returns (string memory) {
        require(uint8(_priority) <= 2);

        if (Priorities.LOW == _priority) return "LOW";
        if (Priorities.MEDIUM == _priority) return "MEDIUM";
        if (Priorities.HIGH == _priority) return "HIGH";

        return "";
    }

    function validAddress(address toCheck) internal view returns (bool) {
        bool valid = false;
        if (toCheck == owner) {
            valid = true;
        } else {
            for (uint i=0; i<totalFriends; i++) {
                if (friends[i] == toCheck) {
                    valid = true;
                }
            }
        }

        return valid;
    }
}