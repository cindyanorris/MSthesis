contract RegistrationAuthority is Owned, Registry, Authority {
  enum Permissions {
    Vote
  }

  ACLAuthority acl;
  mapping (bytes32 => bytes4) resourceSignatures;

  function RegistrationAuthority () public {
    acl = new ACLAuthority(true);

    signatureMap['vote'] = bytes4(sha3('vote()'));
    // signatureMap['vote'] = bytes4(sha3('vote(uint8[],uint8[])'));

    acl.addResourcePermission(resourceSignature('vote'), uint8(Permissions.Vote));
  }

  function register (address _voter) public restrictTo(owner) returns (bool _success) {
    return acl.grantPermission(_voter, resourceSignatures['vote'], uint8(Permissions.Vote));
  }

  function unregister (address _voter) public restrictTo(owner) returns (bool _success) {
    return acl.revokePermission(_voter, resourceSignatures['vote'], uint8(Permissions.Vote));
  }

  function isRegistered (address _voter) public constant returns (bool _isRegistered) {
    return acl.hasPermission(_voter, resourceSignatures['vote'], uint8(Permissions.Vote));
  }

  function canCall (address _subject, bytes4 _resource) public constant returns (bool _canCall) {
    return acl.hasPermission(_subject, _resource, uint8(Permissions.Vote));
  }
}
