const todo = artifacts.require('./todo.sol')

contract('todo', (accounts) => {
    before(async () => {
        this.todo = await todo.deployed();
    })

    it ('deploys successfully', async () => {
        const address = await this.todo.address;
        assert.notEqual(address, '');
        assert.notEqual(address, null);
        assert.notEqual(address, undefined);
    })

    it ('creates a tasks', async () => {
        const description = 'test contract';
        await this.todo.createTask(description);
        const taskCount = await this.todo.taskCounter();
        const task = await this.todo.tasks(taskCount);

        assert.equal(taskCount.toNumber(), 1);
        assert.equal(task.id.toNumber(), taskCount.toNumber());
        assert.equal(task.description, description);
        assert.equal(task.completed, false);
    })

    it ('completes a task', async () => {
        await this.todo.completeTask(1);
        const task = await this.todo.tasks(1);
        assert.equal(task.completed, true);
    })

    it ('deletes a task', async () => {
        await this.todo.deleteTask(1);
        const task = await this.todo.tasks(1);
        assert.equal(task.id.toNumber(), 0);
        assert.equal(task.description, '');
        assert.equal(task.completed, false);
    })
})