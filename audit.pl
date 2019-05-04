% Next Generation Access Control audit manager
:- module(audit, [audit_gen/2, audit_set/1, audit_select/1, audit_deselect/1]).

:- use_module(library(http/http_client)).

% This defines the set of possible auditable events
auditable_events([ngac_start, pq_grant, pq_deny,
                  ngac_error  % do not remove general ngac_error
                 ]).
% in module param: audit_selection/1 is defined as initially []
% This is the set of currently selected events to generate audit records.

init(basic) :- !,
    param:setparam(audit_selection, [ngac_start,pq_grant,pq_deny,ngac_error]).
init(full) :- !,
    auditable_events(InitEvents), % turn all events on
    param:setparam(audit_selection,InitEvents).

% ngac audit operations
%   audit_gen generates audit record info for ngac audit
%     it leaves time stamp generation to the system audit function
%   audit_set unconditionally sets the parameter auditable_events
%     to the given list, except it will not permit the audit event
%     ngac_error to not be included.
%   audit_select addes the given list of ngac audit events to the
%     audit_selection
%   audit_deselect removes the given list of ngac audit events from the
%     current audit_selection

audit_gen(Event, Data) :-
    param:audit_selection(AS),
    (   memberchk(Event, AS)
    ->  sys_audit(ngac, Event, Data)
    ;   true
    ).

audit_set(Events) :-
    ground(Events), is_set(Events),
    auditable_events(Auditable),
    subset(Events,Auditable),
    union(Events,[ngac_error],SetEvents), % ngac_error cannot be removed from ngac audit_selection
    param:setparam(audit_selection,SetEvents), !.
audit_set(_) :-
    sys_audit(ngac, ngac_error, 'Failure to set audit_selection.').

audit_select(Event) :- atom(Event), !, audit_select([Event]).
audit_select(Events) :-
    ground(Events), is_set(Events),
    auditable_events(Auditable),
    subset(Events,Auditable),
    param:audit_selection(CurrentSelection),
    union(Events,CurrentSelection,SetEvents),
    param:setparam(audit_selection,SetEvents), !.
audit_select(_) :-
    sys_audit(ngac, ngac_error, 'Failure to add to audit_selection.').

audit_deselect(Event) :- atom(Event), !, audit_deselect([Event]).
audit_deselect(Events) :-
    ground(Events), is_set(Events),
    delete(Events,ngac_error,DeSelection), % cannot deselect ngac_error
    auditable_events(Auditable),
    subset(DeSelection,Auditable),
    param:audit_selection(CurrentSelection),
    subtract(CurrentSelection,DeSelection,NewSelection),
    param:setparam(audit_selection,NewSelection), !.
audit_deselect(_) :-
    sys_audit(ngac, ngac_error, 'Failure to delete from audit_selection.').

%
% Customise below for local system audit
% sys_audit always succeeds
%

sys_audit(Source, Event, EventData) :- atom(Source), atom(Event), ground(EventData),
    % for general use without a specific system audit service, write to local audit
    % std error is default audit_stream if audit_logging(on)
    % a local file is created for the log if audit_logging(file)
    (	\+ param:audit_logging(off)
    ->	param:audit_stream(Audit),
	gen_time_stamp(TS), % use own time stamp only for own log
	format(Audit, 'audit ~a: ~q, ~q, ~q~n', [TS,Source,Event,EventData]),
	flush_output(Audit)
    ;	true
    ), % for general use or for testing

    %
    % Call system-specific audit
    %

    % phantom_audit(Source,Event,EventData),

    !.
sys_audit(_,_,_).

phantom_audit(Source,Event,EventData) :-
    % for PHANTOM use the PHANTOM Monitoring Framework API to create an audit log record
    %
    % the server is a MF logger at the address AuditServ at port AuditPort and path AuditAPIpath
    % the address info is only representative
    Serv='141.58.0.8', RepoPort=2777, LogAPI=new_log,
    atomic_list_concat([Serv,':',RepoPort], AuditServer),
    atomic_list_concat([AuditServer,'/',LogAPI],AuditLocn),
    param:mf_token(Token),
%    format(atom(AuthHeader),'Authorization: OAuth ~a',Token),
    AuthHeader=authorization(bearer(Token)),
%    ContentHeader='Content-Type: text/plain',
    ContentHeader=header('Content-Type','text/plain'),
    % map (Source, Event, EventData) to (Code, IP, Message, User)
    % the Source is some part of ngac
    atom_concat(Source,'@ngac.org',User),
    % encode Events as numbers based on 100
    auditable_events(Auditable), nth1(N,Auditable,Event),
    Code is 100 + N,
    term_to_atom(EventData,Message),
    Ip = '1.1.1.1',
    format(atom(Qdata),'code=~a&ip=~a&message=~a&user=~a',[Code,Ip,Message,User]),
    !,
    atomic_list_concat([AuditLocn,'?',Qdata],URL),
    Data = '',
    Options = [AuthHeader,ContentHeader/*,method(post)*/],
    format(atom(_HReq),'-> http_post(~w, ~w, -, ~w)~n',[URL,Data,Options]),
%    http_post(URL,Data,Reply,Options), % log the audit record
%    http_get(URL,Reply,Options), % log the audit record
%    format('Reply: ~w~n',Reply),
    true.
phantom_audit(_,_,_).

gen_time_stamp(TS) :-
	get_time(T),
	stamp_date_time(T,date(YYYY,MM,DD,H,M,S,_,_,_),local),
	format(atom(TS), '~d-~d-~d_~d:~d:~d', [YYYY,MM,DD,H,M,truncate(S)]).
