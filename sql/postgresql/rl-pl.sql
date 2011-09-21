--
-- Create functions
-- @author Vinod Kurup <vinod@kurup.com>
-- @creation-date 2003-09-17
-- @cvs-id $Id: rl-pl.sql,v 1.2 2004/02/16 21:19:28 vinod Exp $
--

create or replace function rl_runner__new(integer,integer,real,integer,varchar,varchar,varchar,timestamptz,integer,varchar,integer)
returns integer as '
declare
    p_runner_id                 alias for $1;   -- default null
    p_user_id                   alias for $2;
    p_height                    alias for $3;   -- default null
    p_start_week                alias for $4;   -- default 1
    p_distance_units            alias for $5;   -- default m
    p_weight_units              alias for $6;   -- default lb
    p_object_type               alias for $7;  -- default rl_runner
    p_creation_date             alias for $8;  -- default current_timestamp
    p_creation_user             alias for $9;  -- default null
    p_creation_ip               alias for $10;  -- default null
    p_context_id                alias for $11;  -- default null
    v_runner_id                 rl_runners.runner_id%TYPE;
    v_start_week                rl_runners.start_week%TYPE;
    v_distance_units            rl_runners.distance_units%TYPE;
    v_weight_units              rl_runners.weight_units%TYPE;
    v_object_type               acs_objects.object_type%TYPE;
    v_creation_date             acs_objects.creation_date%TYPE;
begin
    v_start_week = coalesce(p_start_week, 1);
    v_distance_units = coalesce(p_distance_units, ''m'');
    v_weight_units = coalesce(p_weight_units, ''lb'');
    v_object_type = coalesce(p_object_type, ''rl_runner'');
    v_creation_date = coalesce(p_creation_date, current_timestamp);

    -- see if this user already has a log - if so, just return
    -- the correct runner_id
    select into v_runner_id runner_id from rl_runners 
      where user_id = p_user_id;

    if v_runner_id is not null then
        return v_runner_id;
    end if;

    v_runner_id = acs_object__new(
        p_runner_id,            -- object_id
        v_object_type,          -- object_type
        v_creation_date,        -- creation_date
        p_creation_user,        -- creation_user
        p_creation_ip,          -- creation_ip
        p_context_id            -- context_id
    );

    insert into rl_runners (
        runner_id,
        user_id,
        height,
        start_week,
        distance_units,
        weight_units
    ) values (
        v_runner_id, 
        p_user_id, 
        p_height,
        v_start_week, 
        v_distance_units, 
        v_weight_units
    );

    return v_runner_id;
end;' language 'plpgsql';

create or replace function rl_runner__edit(integer,real,integer,varchar,varchar,varchar,timestamptz,integer,varchar,integer)
returns integer as '
declare
    p_runner_id                 alias for $1;   -- default null
    p_height                    alias for $2;   -- default null
    p_start_week                alias for $3;   -- default 1
    p_distance_units            alias for $4;   -- default m
    p_weight_units              alias for $5;   -- default lb
    p_object_type               alias for $6;   -- default rl_runner
    p_creation_date             alias for $7;   -- default current_timestamp
    p_creation_user             alias for $8;   -- default null
    p_creation_ip               alias for $9;   -- default null
    p_context_id                alias for $10;  -- default null
    v_start_week                rl_runners.start_week%TYPE;
    v_distance_units            rl_runners.distance_units%TYPE;
    v_weight_units              rl_runners.weight_units%TYPE;
    v_object_type               acs_objects.object_type%TYPE;
    v_creation_date             acs_objects.creation_date%TYPE;
begin
    v_start_week = coalesce(p_start_week, 1);
    v_distance_units = coalesce(p_distance_units, ''m'');
    v_weight_units = coalesce(p_weight_units, ''lb'');
    v_object_type = coalesce(p_object_type, ''rl_runner'');
    v_creation_date = coalesce(p_creation_date, current_timestamp);

    perform acs_object__update_last_modified (
        p_runner_id,            -- object_id
        p_creation_user,        -- modifying_user
        p_creation_ip          -- modifying_ip
    );

    update rl_runners 
    set height = p_height,
        start_week = v_start_week,
        distance_units = v_distance_units,
        weight_units = v_weight_units
    where runner_id = p_runner_id;

    return p_runner_id;
end;' language 'plpgsql';

create or replace function rl_runner__del(integer)
returns integer as '
declare
    p_runner_id                 alias for $1;
begin
    delete from acs_permissions where object_id = p_runner_id;
    delete from rl_shoes where runner_id = p_runner_id;
    delete from rl_workouts where runner_id = p_runner_id;
    perform acs_object__delete(p_runner_id);

    return 0;
end;' language 'plpgsql';

create or replace function rl_runner__name(integer)
returns varchar as '
declare
    p_runner_id                 alias for $1;
    v_name                      varchar;
begin
    select first_names || '' '' || last_name || ''''''s Running Log'' 
      into v_name
      from persons, rl_runners
      where person_id = user_id
        and runner_id = p_runner_id;

    return v_name;
end;' language 'plpgsql';

-- rl_workout

create or replace function rl_workout__new(integer,timestamptz,real,interval,real,integer,integer,integer,integer,varchar,text,integer,varchar,varchar,integer)
returns integer as '
declare
    p_runner_id         alias for $1;
    p_workout_date      alias for $2;   -- default current_timestamp
    p_distance          alias for $3;
    p_time              alias for $4;
    p_weight            alias for $5;
    p_resting_hr        alias for $6;
    p_type_id           alias for $7;
    p_shoe_id           alias for $8;
    p_course_id         alias for $9;
    p_course_desc       alias for $10;
    p_comments          alias for $11;
    p_user_id           alias for $12;
    p_creation_ip       alias for $13;
    p_mime_type         alias for $14;  -- default ''text/plain''
    p_folder_id         alias for $15;
    v_workout_date      rl_workouts.workout_date%TYPE;
    v_item_id           cr_items.item_id%TYPE;
    v_workout_id        rl_workouts.workout_id%TYPE;
    v_mime_type         cr_revisions.mime_type%TYPE;
begin
    v_workout_date = coalesce(p_workout_date, current_timestamp);
    v_mime_type = coalesce(p_mime_type, ''text/plain'');

    select nextval(''t_acs_object_id_seq'') into v_item_id;

    v_item_id := content_item__new(
        ''workout''||v_item_id, -- name
        p_folder_id,            -- parent_id
        v_item_id,              -- item_id
        null,                   -- locale
        current_timestamp,      -- creation_date
        p_user_id,              -- creation_user
        p_runner_id,            -- context_id
        p_creation_ip,          -- creation_ip
        ''content_item'',       -- item_subtype
        ''rl_workout'',         -- content_type
        ''Workout ''||v_item_id, -- title
        null,                   -- description
        v_mime_type,            -- mime_type
        null,                   -- nls_language
        p_comments,             -- text
        ''text''                -- storage_type
    );

    v_workout_id := content_item__get_latest_revision(v_item_id);
    
    insert into rl_workouts (
      workout_id, runner_id, workout_date, distance, time, 
      weight, resting_hr, type_id, shoe_id, course_id, course_desc
    ) values (
      v_workout_id, p_runner_id, v_workout_date, p_distance, p_time,
      p_weight, p_resting_hr, p_type_id, p_shoe_id, p_course_id, p_course_desc
    );

    return v_workout_id;
    
end;' language 'plpgsql';

create or replace function rl_workout__edit(integer,timestamptz,real,interval,real,integer,integer,integer,integer,varchar,text,integer,varchar,varchar)
returns integer as '
declare
    p_workout_id        alias for $1;
    p_workout_date      alias for $2;   -- default current_timestamp
    p_distance          alias for $3;
    p_time              alias for $4;
    p_weight            alias for $5;
    p_resting_hr        alias for $6;
    p_type_id           alias for $7;
    p_shoe_id           alias for $8;
    p_course_id         alias for $9;
    p_course_desc       alias for $10;
    p_comments          alias for $11;
    p_user_id           alias for $12;
    p_creation_ip       alias for $13;
    p_mime_type         alias for $14;  -- default ''text/plain''
    v_workout_date      rl_workouts.workout_date%TYPE;
    v_item_id           cr_items.item_id%TYPE;
    v_workout_id        rl_workouts.workout_id%TYPE;
    v_mime_type         cr_revisions.mime_type%TYPE;
begin
    v_workout_date = coalesce(p_workout_date, current_timestamp);
    v_mime_type = coalesce(p_mime_type, ''text/plain'');

    update acs_objects
    set modifying_user = p_user_id,
        last_modified = current_timestamp,
        modifying_ip = p_creation_ip
    where object_id = p_workout_id;

    update cr_revisions
    set mime_type = v_mime_type,
        content = p_comments
    where revision_id = p_workout_id;

    update rl_workouts
    set workout_date = v_workout_date,
        distance = p_distance,
        time = p_time,
        weight = p_weight,
        resting_hr = p_resting_hr,
        type_id = p_type_id,
        shoe_id = p_shoe_id,
        course_id = p_course_id,
        course_desc = p_course_desc
    where workout_id = p_workout_id;

    return p_workout_id;
    
end;' language 'plpgsql';

create or replace function rl_workout__del(integer)
returns integer as '
declare
    p_workout_id    alias for $1;
    v_item_id       cr_items.item_id%TYPE;
    v_rec           record;
begin
    select item_id into v_item_id from cr_revisions 
      where revision_id = p_workout_id;

    perform content_item__delete(v_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function rl_workout__convert_distance(real,varchar)
returns real as '
declare
    p_distance      alias for $1;
    p_units         alias for $2;
    v_distance      numeric;
begin
    -- values are stored in db as miles. convert to km if requested.
    if p_units = ''m'' then
        return p_distance;
    else 
        if p_units = ''km'' then
            -- round only takes type: numeric
            v_distance := p_distance * 1.609;
            return round(v_distance, 1);
        else
            raise warning ''rl_workout__convert_distance: invalid unit %. returning miles'',p_units;
            return p_distance;
        end if;
    end if;
end;' language 'plpgsql';

create or replace function rl_workout__convert_weight(real,varchar)
returns real as '
declare
    p_weight        alias for $1;
    p_units         alias for $2;
    v_weight        numeric;
begin
    -- values are stored in db as pounds. convert to kg if requested.
    if p_units = ''lb'' then
        return p_weight;
    else 
        if p_units = ''kg'' then
            -- round only takes type: numeric
            v_weight := p_weight / 2.2;
            return round(v_weight, 1);
        else
            raise warning ''rl_workout__convert_weight: invalid unit %. returning pounds'', p_units;
            return p_weight;
        end if;
    end if;
end;' language 'plpgsql';


create or replace function rl_shoe__distance(integer)
returns real as '
declare
    p_shoe_id       alias for $1;
    v_distance      rl_workouts.distance%TYPE;
begin
    select sum(distance) into v_distance
      from rl_workouts where shoe_id = p_shoe_id;

    v_distance = coalesce(v_distance,0);

    return v_distance;
end;' language 'plpgsql';
