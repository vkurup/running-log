--
-- Drop functions
-- @author Vinod Kurup <vinod@kurup.com>
-- @creation-date 2003-09-17
-- @cvs-id $Id: rl-pl-drop.sql,v 1.2 2004/02/16 21:19:28 vinod Exp $
--

drop function rl_runner__new(integer,integer,real,integer,varchar,varchar,varchar,timestamptz,integer,varchar,integer);
drop function rl_runner__edit(integer,real,integer,varchar,varchar,varchar,timestamptz,integer,varchar,integer);
drop function rl_runner__del(integer);
drop function rl_runner__name(integer);

drop function rl_workout__new(integer,timestamptz,real,interval,real,integer,integer,integer,integer,varchar,text,integer,varchar,varchar,integer)
drop function rl_workout__del(integer);
drop function rl_workout__edit(integer,timestamptz,real,interval,real,integer,integer,integer,integer,varchar,text,integer,varchar,varchar);
drop function rl_workout__convert_distance(real,varchar);
drop function rl_workout__convert_weight(real,varchar);

drop function rl_shoe__distance(integer);
