const todo = artifacts.require('./todo.sol')

contract('todo', (accounts) => {
    const description = 'test contract';
    const status = 'new';
    const dueDate = new Date().valueOf();
    let privateTask = false;

    before(async () => {
        this.todo = await todo.deployed();
    })

    it ('deploys successfully', async () => {
        const address = await this.todo.address;
        const owner = await this.todo.owner();

        assert.notEqual(address, '');
        assert.notEqual(address, null);
        assert.notEqual(address, undefined);
        assert.equal(owner, accounts[0]);
    })

    it ('creates a tasks with default priority', async () => {
        await this.todo.createTask(description, status, dueDate, privateTask);
        const currentTaskIndex = await this.todo.currentIndex();
        const totalTasks = await this.todo.totalTasks();
        const tasks= await this.todo.getTasks();
        const task= tasks[0];

        assert.equal(totalTasks.toNumber(), 1);
        assert.equal(task['id'], currentTaskIndex-1);
        assert.equal(task['description'], description);
        assert.equal(task['status'], status);
        assert.equal(task['dueDate'], dueDate);
        assert.equal(task['privateTask'], privateTask);
    })

    it ('creates a tasks with HIGH priority', async () => {
        const priorityIntValue = 2;
        await this.todo.createTask(description, status, dueDate, privateTask, priorityIntValue);
        const currentTaskIndex = await this.todo.currentIndex();
        const tasks= await this.todo.getTasks();
        const task= tasks[currentTaskIndex-1];
        const priority = await this.todo.getPriority(currentTaskIndex-1);

        assert.equal(task['priority'], priorityIntValue);
        assert.equal(priority, "HIGH");
    })

    it ('updates status of a task', async () => {
        const newStatus = 'reviewing';
        const currentTaskIndex = await this.todo.currentIndex();
        await this.todo.updateTaskStatus(currentTaskIndex-1, newStatus);
        const tasks= await this.todo.getTasks();
        const task= tasks[currentTaskIndex-1];

        assert.equal(task['status'], newStatus);
    })

    it ('deletes a task', async () => {
        const currentTaskIndex = await this.todo.currentIndex();
        await this.todo.deleteTask(currentTaskIndex-1);
        const tasks= await this.todo.getTasks();
        const totalTasks = await this.todo.totalTasks();

        assert.notEqual(currentTaskIndex, tasks.length);
        assert.equal(totalTasks < currentTaskIndex, true);
        assert.equal(totalTasks, tasks.length);
    })

    it ('adds a friend', async () => {
        await this.todo.addFriend(accounts[1]);
        const friend = await this.todo.friends(0);

        assert.equal(friend, accounts[1]);
    })

    it ('deletes a friend', async () => {
        let totalFriends = await this.todo.totalFriends();
        assert.equal(totalFriends.toNumber(), 1);
        await this.todo.removeFriend(accounts[1]);
        totalFriends = await this.todo.totalFriends();

        assert.equal(totalFriends.toNumber(), 0);
    })

    describe("private tasks are properly hidden", function() {
        before(async () => {
            privateTask = true;
            this.todo = await todo.deployed();
            await this.todo.createTask(description, status, dueDate, privateTask);
        });

        it ('returns all tasks when called by owner', async () => {
            const tasks = await this.todo.getTasks();
            const totalTasks = await this.todo.totalTasks();

            assert.equal(totalTasks.toNumber(), tasks.length);
        });

        it ('addresses not in friends list are denied read access', async () => {
            let err = null;
            try {
                await this.todo.getTasks.call({ from: accounts[4] })
            } catch (error) {
                err = error;
            }

            assert.equal(err.message.endsWith('Read access denied'), true);
        });

        it ('private tasks are hidden from friends', async() => {
            await this.todo.addFriend(accounts[4]);
            const tasks = await this.todo.getTasks.call({ from: accounts[4] });
            const totalTasks = await this.todo.totalTasks();

            assert.notEqual(totalTasks.toNumber(), tasks.length);
        });
    });
})