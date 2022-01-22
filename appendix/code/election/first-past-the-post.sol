interface Phase {
  function hasPermission
    (address _subject, bytes4 _resource, uint8 _permission)
    public view returns
    (bool _hasPermission)
  ;

  function getPermissions
    (address _subject, bytes4 _resource)
    public view returns
    (uint256 _permissions)
  ;
}

contract FiniteStateMachine {

  function nextPhase () internal {
    phase = Phase(uint(phase) + 1);
  }

  // Check current stage.
  modifier atPhase(Phase _phase) {
    require(phase == _phase);
    _;
  }

  // This modifier goes to the next phase after the function is done.
  modifier transitionNextPhase() {
    _;
    nextPhase();
  }

  // Perform timed transitions. Be sure to mention this modifier first,
  // otherwise the guards will not take the new stage into account.
  modifier timedTransitions() {
    if (phase == Phase.Frozen && now >= voteStartTime)
      nextPhase();
    if (phase == Phase.Vote && now >= voteEndTime)
      nextPhase();
    // The other stages transition by transaction
    _;
  }

}

contract Test {
  enum Phase { Configuration, Frozen, Vote, Tally }

  struct PhaseConfiguration {
    Phase phase;
    uint startTime;
    uint endTime;
    Phase nextPhase;
  }

  mapping (Phase => PhaseConfiguration) phases;
  Phase public phase = Phase.Configuration;

  constructor () public {
    phases[Phase.Configuration] = PhaseConfiguration({
      phase: Phase.Configuration,
      startTime: block.timestamp,
      endTime: uint256(-1),
      nextPhase: Phase.Frozen
    });
  }


}

contract FirstPastThePost is Owned, Guard {
  uint public creationTime = now;

  Choice[] public choices;
  mapping(address => bool) public voted;
  Choice public winner;

  enum Phase { Configuration, Frozen, Vote, Tally }

  struct PhaseProperties {
    Phase phase;
    uint startTime;
    uint endTime;
    Phase nextPhase;
  }

  mapping (Phase => PhaseProperties) phases;
  Phase public phase = Phase.Configuration;

  constructor () public {
    phases[Phase.Configuration] = PhaseProperties({
      phase: Phase.Configuration,
      start_time: now,
      next_phase: Phase.Configuration
    });
  }

  function setPhase (Phase _phase) public returns (bool _success) {
  }

  // This is a type for a single proposal.
  struct Choice {
    // Short name (up to 32 bytes).
    bytes32 name;

    // TODO: choice description?
    // bytes32 description;

    // Number of accumulated votes.
    uint40 voteCount;
  }

  // Restrict calls to _account.
  modifier restrictTo(address _account) {
    require(msg.sender == _account);
    _;
  }

  // Check current stage.
  modifier atPhase(Phase _phase) {
    require(phase == _phase);
    _;
  }

  // This modifier goes to the next phase after the function is done.
  modifier transitionNextPhase () {
    _;
    nextPhase();
  }

  // Move into next phase.
  function nextPhase () internal {
    // phase = Phase(uint(phase) + 1);
    phase = phases[phase].nextPhase;
  }

  // Perform timed transitions. Be sure to mention this modifier first,
  // otherwise the guards will not take the new stage into account.
  modifier timedTransition () {
    if (block.timestamp >= phases[phase].endTime)
      nextPhase();
    // The other stages transition by transaction
    _;
  }

  modifier vote () {
    _;
  }

  /* Election Functions */
  // Freeze the configuration.
  function freeze () restrictTo(owner) atPhase(Phase.Configuration) transitionNextPhase {
    require(voteStartTime > now);
    require(choices.length > 1);
    freezeTime = now;
    delete owner;
  }

  // Cast a ballot.
  function vote (uint8 choice) timedTransitions atPhase(Phase.Vote) {
    // Each address can only vote once.
    require(!voted[msg.sender]);
    voted[msg.sender] = true;

    choices[choice].voteCount += 1;
  }

  // Tally ballots.
  function tally () timedTransitions atPhase(Phase.Tally) {
    winner = choices[0];
    for (uint8 i = 0; i < choices.length; i++) {
      if (choices[i].voteCount > winner.voteCount)
        winner = choices[i];
    }
  }

  /* Configuration Functions */
  constructor () {}

  function setVoteStartTime (uint _voteStartTime) atPhase(Phase.Configuration) restrictTo(owner) {
    voteStartTime = _voteStartTime;
  }

  function setVoteEndTime (uint _voteEndTime) atPhase(Phase.Configuration) restrictTo(owner) {
    voteEndTime = _voteEndTime;
  }

  function addChoices (bytes32[] _choices) atPhase(Phase.Configuration) restrictTo(owner) {
    for (uint i = 0; i < _choices.length; i++) {
      choices.push(Choice({
        name: _choices[i],
        voteCount: 0
      }));
    }
  }

  function addChoice (bytes32 _name) atPhase(Phase.Configuration) restrictTo(owner) {
    choices.push(Choice({
      name: _name,
      voteCount: 0
    }));
  }

  //   function modifyChoice(uint8 key, bytes32 _name)
  //     atPhase(Phase.Configuration)
  //     restrictTo(owner)
  //   {
  //     require(key < choices.length-1);
  //
  //     choices[key] = Choice({
  //       name: _name,
  //       voteCount: 0
  //     });
  //   }
}
