const todo = artifacts.require('./todo.sol')

contract('todo', (accounts) => {
    const description = 'test contract';
    const status = 'new';
    const dueDate = new Date().valueOf();

    before(async () => {
        this.todo = await todo.deployed();
    })

    it ('deploys successfully', async () => {
        const address = await this.todo.address;
        assert.notEqual(address, '');
        assert.notEqual(address, null);
        assert.notEqual(address, undefined);
    })

    it ('creates a tasks with default priority', async () => {
        await this.todo.createTask(description, status, dueDate);
        const taskCount = await this.todo.taskCounter();
        const task = await this.todo.tasks(taskCount);

        assert.equal(taskCount.toNumber(), 1);
        assert.equal(task.id.toNumber(), taskCount.toNumber());
        assert.equal(task.description, description);
        assert.equal(task.status, status);
        assert.equal(task.dueDate, dueDate);
    })

    it ('creates a tasks with HIGH priority', async () => {
        const priorityIntValue = 2;
        await this.todo.createTask(description, status, dueDate, priorityIntValue);
        const taskCount = await this.todo.taskCounter();
        const task = await this.todo.tasks(taskCount);
        const priority = await this.todo.getPriority(taskCount);

        assert.equal(task.priority, priorityIntValue);
        assert.equal(priority, "HIGH");
    })

    it ('updates status of a task', async () => {
        const newStatus = 'reviewing';
        await this.todo.updateTaskStatus(1, newStatus);
        const task = await this.todo.tasks(1);
        assert.equal(task.status, newStatus);
    })

    it ('deletes a task', async () => {
        await this.todo.deleteTask(1);
        const task = await this.todo.tasks(1);
        assert.equal(task.id.toNumber(), 0);
        assert.equal(task.description, '');
        assert.equal(task.status, '');
    })
})