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

%%
% Interface: Authority
%%
Interface.Authority("Authority")
    ("+canCall(address, bytes4) : bool");
classStereotypes.Authority("<<interface>>");

%%
% Interface: Authorization
%%
Interface Authorization("Authorization")
    ("+getAuthority() : Authority",
    "+setAuthority(Authority) : bool",
    "+isAuthorized(address, bytes4) : bool");
classStereotypes.Authorization("<<interface>>");

%%
% Interface: AccessControlList
%%
Interface AccessControlList("AccessControlList")
    ("+hasPermission(address, bytes4, uint8) : bool",
    "+getPermissions(address, bytes4) : uint256",
    "+grantPermission(address, bytes4, uint8) : bool",
    "+removePermission(address, bytes4, uint8) : bool",
    "+removeAllPermissions(address, bytes4) : bool");
classStereotypes.AccessControlList("<<interface>>");

%%
% Interface: Ownership
%%
Interface Ownership("Ownership")
    ("+getOwner() : address",
    "+setOwner(address) : bool");
classStereotypes.Ownership("<<interface>>");

%%
% Contract: RestrictTo
%%
Class.RestrictTo("RestrictTo")()
    ("-restrictTo(address)");
classStereotypes.RestrictTo("<<modifier>>");

leftToRight(75)(Registry, AccessControlList, Ownership, RestrictTo);
drawObjects(Registry, AccessControlList, Ownership, RestrictTo);

%%
% Contract: Owned
% Implements Interface(s): Ownership
% Extends Contract(s): RestrictTo
%%
Class.Owned("Owned")
    ("+owner : address")
    ("-restrictTo(address)",
    "getOwner() : address",
    "setOwner(address) : address");

Owned.c = 1/2[Ownership.s,RestrictTo.s] + (0, -150);
drawObject(Owned);

%%
% Contract: Guard
% Implements Interface(s): Authorization, Ownership
% Extends Contract(s): Owned
%%
Class.Guard("Guard")
    ("+authority : Authority")
    ("-restrictTo(address)",
    "-auth",
    "-authorized(bytes4)",
    "getAuthority() : Authority",
    "setAuthority() : Authority",
    "isAuthorized(address, bytes4) : bool");

Guard.n = Owned.s + (0, -130);
drawObject(Guard);

%%
% Contract: BasicACL
% Implements Interface(s): AccessControlList
% Extends Contract(s): Owned
%%
Class.BasicACL("BasicACL")
    ("+userResourcePermissions : mapping(address => mapping(bytes4 => uint256))")
    ("hasPermission(address, bytes4, uint8)",
    "getPermissions(address, bytes4)",
    "grantPermission(address, bytes4, uint8)",
    "removePermission(address, bytes4, uint8)",
    "removeAllPermissions(address, bytes4)");

xBasicACL = xpart AccessControlList.c;
yBasicACL = ypart Owned.c;
BasicACL.c = (xBasicACL, yBasicACL);
% BasicACL.c = AccessControlList.c + (0, -125);
drawObject(BasicACL);

%%
% Contract: ACLAuthority
% Implements Interface(s): Authority, AccessControlList
% Extends Contract(s): Owned
%%
Class.ACLAuthority("ACLAuthority")
    ("+acl : AccessControlList",
    "+requiredPermissions : mapping(bytes4 => uint8)")
    ("setACL(BasicACL) : bool",
    "addResourcePermission(bytes4, uint8) : bool",
    "hasPermission(address, bytes4, uint8) : bool",
    "getPermissions(address, bytes4) : uint256",
    "grantPermissions(address, bytes4, uint8) : bool",
    "removePermission(address, bytes4, uint8) : bool",
    "removeAllPermissions(address, bytes4): bool",
    "canCall(address, bytes4)");


% xACLAuthority = xpart 1/2[Authority.c, AccessControlList.c];
xACLAuthority = xpart BasicACL.c;
yACLAuthority = ypart Guard.c;
ACLAuthority.c = (xACLAuthority, yACLAuthority);
drawObject(ACLAuthority);

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
yVoterRegistrationAuthority = ypart Guard.c;
VoterRegistrationAuthority.c = (xVoterRegistrationAuthority, yVoterRegistrationAuthority);
drawObject(VoterRegistrationAuthority);


% xAuthority = xpart 1/2[Registry.c, AccessControlList.c];
% yAuthority = ypart 1/2[ACLAuthority.n, BasicACL.s];
% Authority.c = (xAuthority, yAuthority);
Authority.c = ACLAuthority.s + (0, -125);
drawObject(Authority);

xAuthorization = xpart Guard.c;
yAuthorization = ypart Authority.c;
Authorization.c = (xAuthorization, yAuthorization);
drawObject(Authorization);


link(realization)(VoterRegistrationAuthority.n -- Registry.s);
link(realization)(VoterRegistrationAuthority.s -- Authority.nw);
link(aggregationUni)(ACLAuthority.w -- VoterRegistrationAuthority.e);
link(inheritance)(VoterRegistrationAuthority.ne -- Owned.sw);

link(realization)(Owned.n -- Ownership.s);
link(inheritance)(Owned.n -- RestrictTo.s);

link(inheritance)(Guard.n -- Owned.s);
link(realization)(Guard.s -- Authorization.n);
link(aggregationUni)(Authority.ne -- Guard.s);

link(inheritance)(BasicACL.e -- Owned.w);
link(realization)(BasicACL.n -- AccessControlList.s);

link(realization)(ACLAuthority.s -- Authority.n);
link(realization)(1/3[ACLAuthority.n,ACLAuthority.ne] -- 1/3[AccessControlList.s,AccessControlList.se]);
% link(realization)(ACLAuthority.n + (3,0) -- ACLAuthority.n + (15,15) -- AccessControlList.s + (15,0)); % Angled line that's meh...
% link(realization)(1/2[ACLAuthority.n,ACLAuthority.ne] .. 1/2[BasicACL.e,Owned.w] .. 1/2[AccessControlList.s,AccessControlList.se]); % Curved line that looks bad
link(inheritance)(ACLAuthority.e -- 1/2[Owned.sw,Owned.s]);
link(aggregationUni)(BasicACL.s -- ACLAuthority.n);
drawObject(BasicACL); % Redraw the BasicACL above new links.


endfig;
end
