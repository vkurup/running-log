-- simple script to add some data to the package so
-- I can test that drop script works properly

-- run running-log-create.sql
-- run this script
-- run running-log-drop.sql
-- make sure all data was cleared from cr_items, acs_objects

create function inline_0()
returns integer as '
declare
    v_max_id        integer;
    v_user_id       integer;
    v_runner_id     integer;
    v_folder_id     integer;
    v_workout_id    integer;
begin
    select max(object_id) into v_max_id from acs_objects;

    select user_id into v_user_id
    from users order by user_id limit 1;

    raise notice ''Using user_id %'', v_user_id;

    v_runner_id := rl_runner__new(
        null,v_user_id,null,null,null,null,null,null,null,null,null
    );

    raise notice ''Created runner_id %'', v_runner_id;

    -- get the running-log content folder for these workouts.
    -- in reality, this will be done at package instantiate time
    -- to tie workouts to a package-specific folder (site-node?)

    v_folder_id := content_item__get_id(
        ''/running-log'',     -- path
        content_item__get_root_folder(null), -- root_folder_id
        ''f''
    );

    raise notice ''Created folder %'', v_folder_id;

    perform content_folder__register_content_type (
        v_folder_id,            -- folder_id
        ''rl_workout'',         -- content_type
        ''t''                   -- include_subtypes
    );

    v_workout_id := rl_workout__new(
        v_runner_id,            -- runner_id
        null,                   -- workout_date
        ''5.33'',               -- distance
        ''0:46:07'',            -- time
        ''165'',                -- weight
        56,                     -- resting_hr
        null,                   -- shoe_id
        null,                   -- course_id
        null,                   -- course_desc
        ''Great run today'',    -- comments
        null,                   -- user_id
        null,                   -- creation_ip
        null,                   -- mime_type
        v_folder_id             -- folder_id
    );

    raise notice ''Workout % added'', v_workout_id;

    v_workout_id := rl_workout__new(
        v_runner_id,            -- runner_id
        null,                   -- workout_date
        ''5.3'',                -- distance
        ''0:46:07'',            -- time
        ''165'',                -- weight
        56,                     -- resting_hr
        null,                   -- shoe_id
        null,                   -- course_id
        null,                   -- course_desc
        ''Good run today'',     -- comments
        null,                   -- user_id
        null,                   -- creation_ip
        null,                   -- mime_type
        v_folder_id             -- folder_id
    );

    raise notice ''Another Workout % added'', v_workout_id;

    raise notice ''now run the drop script and check that there are no object_id > % related to this package'', v_max_id;
 
    return 0;
end;' language 'plpgsql';

select inline_0();

drop function inline_0();

