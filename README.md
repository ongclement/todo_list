# ToDo List

ToDo application powered by ethereum smart contract with unit tests written with Mocha framework. To deploy the smart contract locally, the following program(s) is/are required:

1. <a hef='https://www.trufflesuite.com/ganache'>Ganache</a> - a personal blockchain for rapid DApp development. Start up Ganache and you should see multiple wallet accounts with 100.00 ether.
2. <a href='https://nodejs.org/en/download/'>NodeJS</a> - required to use the NPM package installer
3. Truffle - install via  npm with the following command:

        npm install -g truffle@5.3.8
   
To deploy the contract onto your local blockchain network, run the following truffle commands in the project directory on the terminal. The following command compiles the contract code based on configs provided in truffle-config.js.


        truffle compile

This command deploys the contract based on the migration files located under the /migrations directory.

        truffle migrate --reset

To run truffle unit tests,

         truffle test

Following this, you may interact with the contract via truffle console:

        truffle console

To retrieve an instance of the smart contract,
        
        const contract = await todo.deployed()

To create a new task, follow an example of the constructor as shown below,

        contract.createTask('This is my task description','Pending Status',1642964858,false)
<table>
<tr><td>Description</td><td>String</td></tr>
<tr><td>Status</td><td>String</td></tr>
<tr><td>Due Date in UNIX timestamp</td><td>Integer</td></tr>
<tr><td>Private Task</td><td>Boolean</td></tr>
<tr><td>Priority(optional)<br/>LOW-0, MED-1, HIGH-2</td><td>Integer</td></tr>
</table>

To retrieve all tasks,

        const task = await contract.getTasks();

To update task status,

        contract.updateTaskStatus(0, 'New Status')
<table>
<tr><td>Task ID</td><td>Integer</td></tr>
<tr><td>Status</td><td>String</td></tr>
</table>

To delete task,

        contract.deleteTask(0)
<table>
<tr><td>Task ID</td><td>Integer</td></tr>
</table>

You will be able to get other addresses in your local blockchain network via the `accounts` array. To whitelist a friend's address to view your tasks,

        contract.addFriend(accounts[1])

To remove a friend's address from the whitelist,

        contract.removeFriend(accounts[1])

To invoke a transaction using an address that is not the owner's,

        contract.getTasks.call({from: account[1]})

