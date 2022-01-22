input metauml;
beginfig(1);

%%
% Interface: AccessControlList
%%
Interface AccessControlList("AccessControlList")
    ("+hasPermission(address, bytes4, uint8) : bool",
    "+getPermissions(address, bytes4) : uint256",
    "+grantPermission(address, bytes4, uint8) : bool",
    "+revokePermission(address, bytes4, uint8) : bool",
    "+setPermissions(address, bytes4, uint256) : bool");
classStereotypes.AccessControlList("<<interface>>");
leftToRight(0)(AccessControlList);
drawObject(AccessControlList);

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
    "revokePermission(address, bytes4, uint8)",
    "setPermissions(address, bytes4, uint256): bool");

xBasicACL = xpart AccessControlList.c;
yBasicACL = ypart AccessControlList.c;
% BasicACL.c = (xBasicACL, yBasicACL) + (0, -125);
% BasicACL.c = AccessControlList.c + (0, -125);
BasicACL.n = AccessControlList.s + (0, -50);
drawObject(BasicACL);

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
xACLAuthority = xpart BasicACL.c;
yACLAuthority = ypart BasicACL.c;
% ACLAuthority.c = (xACLAuthority, yACLAuthority) + (0, -125);
ACLAuthority.n = BasicACL.s + (0, -50);
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
Authority.w = ACLAuthority.e + (50, 0);
drawObject(Authority);

link(realization)(BasicACL.n -- AccessControlList.s);

link(realization)(ACLAuthority.e -- Authority.w);
link(realization)(1/3[ACLAuthority.n,ACLAuthority.ne] -- 1/3[AccessControlList.s,AccessControlList.se]);
% link(realization)(ACLAuthority.n + (3,0) -- ACLAuthority.n + (15,15) -- AccessControlList.s + (15,0)); % Angled line that's meh...
% link(realization)(1/2[ACLAuthority.n,ACLAuthority.ne] .. 1/2[BasicACL.e,Owned.w] .. 1/2[AccessControlList.s,AccessControlList.se]); % Curved line that looks bad
link(aggregationUni)(BasicACL.s -- ACLAuthority.n);
drawObject(BasicACL); % Redraw the BasicACL above new links.


endfig;
end
