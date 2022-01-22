input metauml;
beginfig(1);

%%
% Interface: Registry
%%
Interface Registry("Registry")
    ("+register(address) : bool",
    "+unregister(address) : bool",
    "+isRegistered(address) : bool");
classStereotypes.Registry("<<interface>>");
drawObject(Registry);

%%
% Contract: VoterRegistrationAuthority
% Implements Interface(s): VoterAuthority
% Extends Contract(s): Owned
%%
Class.VoterRegistrationAuthority("VoterRegistrationAuthority")
    ("+Permission : enum",
    "+acl : AccessControlList",
    "+sm : SignatureManager")
    ("register(address) : bool",
    "unregister(address) : bool",
    "isRegistered(address) : bool",
    "canCall(address, bytes4) : bool");

% xVoterRegistrationAuthority = xpart 1/2[Registry.c, Authority.c]; % Between Registry and Authority
xVoterRegistrationAuthority = xpart Registry.c;
yVoterRegistrationAuthority = ypart Registry.c;
% VoterRegistrationAuthority.c = (xVoterRegistrationAuthority, yVoterRegistrationAuthority);
VoterRegistrationAuthority.n = Registry.s + (0, -50);
drawObject(VoterRegistrationAuthority);

%%
% Contract: ACLAuthority
% Implements Interface(s): Authority, AccessControlList
% Extends Contract(s): Owned
%%
Class.ACLAuthority("ACLAuthority")
    ("+acl : AccessControlList",
    "+requiredPermissions : mapping(bytes4 => uint8)")
    ("setACL(AccessControlList) : bool",
    "addResourcePermission(bytes4, uint8) : bool",
    "hasPermission(address, bytes4, uint8) : bool",
    "getPermissions(address, bytes4) : uint256",
    "grantPermission(address, bytes4, uint8) : bool",
    "revokePermission(address, bytes4, uint8) : bool",
    "setPermissions(address, bytes4, uint256): bool",
    "canCall(address, bytes4)");

% xACLAuthority = xpart 1/2[Authority.c, AccessControlList.c];
xACLAuthority = xpart VoterRegistrationAuthority.c;
yACLAuthority = ypart VoterRegistrationAuthority.c;
% ACLAuthority.c = (xACLAuthority, yACLAuthority) + (0, -125);
ACLAuthority.w = VoterRegistrationAuthority.e + (50, 0);
drawObject(ACLAuthority);

%%
% Interface: Authority
%%
Interface.Authority("Authority")
    ("+canCall(address, bytes4) : bool");
classStereotypes.Authority("<<interface>>");


% xAuthority = xpart 1/2[Registry.c, AccessControlList.c];
% yAuthority = ypart 1/2[ACLAuthority.n, BasicACL.s];
% Authority.c = (xAuthority, yAuthority);
Authority.n = VoterRegistrationAuthority.s + (0, -50);
drawObject(Authority);

link(realization)(ACLAuthority.sw -- Authority.ne);
link(realization)(VoterRegistrationAuthority.s -- Authority.n);
link(realization)(VoterRegistrationAuthority.n -- Registry.s);
link(aggregationUni)(ACLAuthority.w -- VoterRegistrationAuthority.e);
% link(realization)(ACLAuthority.n + (3,0) -- ACLAuthority.n + (15,15) -- AccessControlList.s + (15,0)); % Angled line that's meh...
% link(realization)(1/2[ACLAuthority.n,ACLAuthority.ne] .. 1/2[BasicACL.e,Owned.w] .. 1/2[AccessControlList.s,AccessControlList.se]); % Curved line that looks bad


endfig;
end
