// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title The Immutable Future
 * @dev A decentralized record-keeping contract for ideas and innovations.
 */
contract Project {
    struct Idea {
        uint256 id;
        string title;
        string description;
        address creator;
        uint256 timestamp;
    }

    uint256 public ideaCount;
    mapping(uint256 => Idea) public ideas;

    event IdeaCreated(uint256 indexed id, string title, address indexed creator, uint256 timestamp);
    event IdeaUpdated(uint256 indexed id, string newDescription, uint256 timestamp);
    event IdeaRemoved(uint256 indexed id, address indexed remover, uint256 timestamp);

    /**
     * @notice Submit a new idea to the blockchain.
     * @param _title The title of the idea.
     * @param _description A brief description of the idea.
     */
    function createIdea(string calldata _title, string calldata _description) external {
        ideaCount++;
        ideas[ideaCount] = Idea({
            id: ideaCount,
            title: _title,
            description: _description,
            creator: msg.sender,
            timestamp: block.timestamp
        });
        emit IdeaCreated(ideaCount, _title, msg.sender, block.timestamp);
    }

    /**
     * @notice Update an existing idea’s description.
     * @param _id The ID of the idea to update.
     * @param _newDescription The new description.
     */
    function updateIdea(uint256 _id, string calldata _newDescription) external {
        Idea storage idea = ideas[_id];
        require(idea.creator == msg.sender, "Only the creator can update their idea");
        idea.description = _newDescription;
        emit IdeaUpdated(_id, _newDescription, block.timestamp);
    }

    /**
     * @notice Remove your idea from the record.
     * @param _id The ID of the idea to remove.
     */
    function removeIdea(uint256 _id) external {
        Idea storage idea = ideas[_id];
        require(idea.creator == msg.sender, "Only the creator can remove their idea");
        delete ideas[_id];
        emit IdeaRemoved(_id, msg.sender, block.timestamp);
    }
}
