input metauml;
beginfig(1);

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

leftToRight(300)(Guard);

drawObject(Guard);
% drawObject(Authority);
% drawObject(Authorization);

xAuthorization = xpart Guard.se + 0;
yAuthorization = ypart Guard.se - 150;
Authorization.c = (xAuthorization, yAuthorization);
drawObject(Authorization);

xAuthority = xpart Guard.sw - 0;
yAuthority = ypart Guard.sw - 150;
Authority.c = (xAuthority, yAuthority);
drawObject(Authority);

link(realization)(Guard.s -- Authorization.n);
link(aggregationUni)(Authority.n -- Guard.s);

endfig;
end
