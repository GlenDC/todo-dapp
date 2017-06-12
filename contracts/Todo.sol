pragma solidity ^0.4.4;

contract TodoList {
    enum Priority {
        Low,
        Medium,
        High
    }

    struct Item {
        Priority priority;
        string   name;
        uint     deadline;
        bool     done;
    }

    address public owner;

    mapping(string => uint) itemIndices;

    Item[] public items;

    modifier ownerOnly()
    {
        require(msg.sender == owner);
        _;
    }

    modifier itemExists(string _name)
    {
        require(itemIndices[_name] > 0);
        _;
    }

    function TodoList()
        payable
    {
        owner = msg.sender;
    }

    function newItem(string name, uint deadline, Priority priority)
        external
        ownerOnly
        returns (bool)
    {
        // name has to be given
        if(bytes(name).length == 0) {
            return false;
        }
        // can't be in the past
        if(deadline < now) {
            return false;
        }

        // can't already exist
        if(itemIndices[name] > 0) {
            return false;
        }

        // register /new/ item
        var item = Item(priority, name, deadline, false);
        itemIndices[name] = items.push(item);
        return true;
    }

    // update /existing/ item
    function updateItem(string name, bool done)
        external
        ownerOnly
        itemExists(name)
    {
        var index = itemIndices[name] - 1;
        items[index].done = done;
    }

    function()
        payable
    {
        // TODO: receive tip
    }
}