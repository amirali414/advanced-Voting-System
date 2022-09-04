// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract voting {



  uint public uid;
  uint public minimumAmount;
  address public immutable owner;
  uint public totalProjects;
  uint public totalAmountCollected;
  uint public seasonStarting;
  uint public season;



  enum contractState {
    freeze,
    running
  }

  enum votingState {
    active,
    closed
  }


  contractState public State;



  constructor () {
    uid = 0;
    owner = msg.sender;
    totalProjects = 0;
    minimumAmount = 1000000000000000000 / 10;
    State = contractState.running;
    totalAmountCollected = 0;
    season = 1;
    seasonStarting = block.timestamp;
  }



  struct project {
    uint id;
    address owner;
    string title;
    uint votes;
    votingState state;
  }


  project[] public projectsArray;


  mapping (uint => mapping (uint => project)) public Projects;



  event created (address _owner, uint _cost, string _title);
  event deActivated (address _owner, bool _status);
  event voted (address _voter, uint _id, uint _cost);
  event freezed (address _owner, contractState _state);
  event newSeason (address _owner, uint _newSeason);
  event closed(address _owner, uint _id);



  modifier onlyOwner {
    require(msg.sender == owner, "Only owners can call this function");
    _;
  }

  modifier minimumValue {
    require(msg.value == minimumAmount);
    _;
  }

  modifier onlyVotingOwner (uint _id) {
    require(msg.sender == Projects[season][_id].owner, "Only voting owner can call this function");
    _;
  }

  modifier isActive (uint _id) {
    require(Projects[season][_id].state == votingState.active);
    _;
  }



  function freeze () public onlyOwner returns (bool) {
    if (State == contractState.running) {
      State = contractState.freeze;
      emit freezed(msg.sender, contractState.freeze);
    }else {
      State = contractState.running;
      emit freezed(msg.sender, contractState.running);
    }
    return true;
  }

  function createVoting (string memory _title) public payable minimumValue returns (bool) {
    Projects[season][uid] = project({
      id : uid,
      owner : msg.sender,
      title : _title,
      votes : 0,
      state : votingState.active
    });
    projectsArray.push(Projects[season][uid]);
    totalAmountCollected += msg.value;
    emit created(msg.sender, minimumAmount, _title);
    return true;
  }

  function vote (uint _id) public payable minimumValue isActive (_id) returns (bool) {
    Projects[season][_id].votes += 1;
    projectsArray[_id].votes += 1;
    totalAmountCollected += msg.value;
    emit voted(msg.sender, _id, minimumAmount);
    return true;
  }

  function closeVoting (uint _id) public onlyVotingOwner (_id) returns (bool) {
    Projects[season][_id].state = votingState.closed;
    projectsArray[_id].state = votingState.closed;
    emit closed(msg.sender, _id);
    return true;
  }

    function closeSeason () public returns (bool) {
    require(seasonStarting + 2630000 <= block.timestamp, "Still left");
    season += 1;
    uid = 0;
    delete projectsArray;
    seasonStarting = block.timestamp;
    emit newSeason(msg.sender, season);
    return true;
    } 
}