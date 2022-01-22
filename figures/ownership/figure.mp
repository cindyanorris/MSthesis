input metauml;
beginfig(1);

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

leftToRight(75)(Ownership, RestrictTo);
drawObjects(Ownership, RestrictTo);

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
% EDGES
%%

link(realization)(Owned.n -- Ownership.s);
link(inheritance)(Owned.n -- RestrictTo.s);

endfig;
end
