--
-- Drop datamodel
-- @author Vinod Kurup <vinod@kurup.com>
-- @creation-date 2003-09-17
-- @cvs-id $Id: rl-tables-drop.sql,v 1.2 2004/02/16 21:19:28 vinod Exp $
--

-- get rid of any runner objects
create function inline_0()
returns integer as '
declare
    v_runner_rec        record;
begin
    for v_runner_rec in select object_id from acs_objects 
                           where object_type=''rl_runner''
    loop
        perform rl_runner__del(v_runner_rec.object_id);
    end loop;

    return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

select acs_object_type__drop_type (
    'rl_runner',           -- object_type
    't'                     -- cascade_p
);

create or replace function inline_1()
returns integer as '
declare
    item_rec    record;
    folder_rec  record;
begin
    for item_rec in select item_id from cr_items 
                    where content_type=''rl_workout'' loop
        perform content_item__delete(item_rec.item_id);
    end loop;

    for folder_rec in select folder_id from cr_folder_type_map
                    where content_type=''rl_workout'' 
                    order by folder_id desc loop
        perform content_folder__delete(folder_rec.folder_id);
    end loop;

    return 0;
end;' language 'plpgsql';

select inline_1();
drop function inline_1();

select content_type__drop_type(
    'rl_workout',       -- content_type
    't',                -- drop_children_p
    't'                 -- drop_table_p
);

-- drop the cr_folder
create function inline_2 ()
returns integer as '
declare
    v_folder_id         cr_folders.folder_id%TYPE;
begin
    v_folder_id := content_item__get_id(
        ''/running-log'',            -- item_path
        content_item__get_root_folder(null), -- root_folder_id
        ''f''                   -- resolve_index
    );

    perform content_folder__unregister_content_type(
        v_folder_id,                -- folder_id
        ''rl_workout'',              -- content_type
        ''t''                       -- include_subtypes
    );

    perform content_folder__delete(v_folder_id);

    return 0;
end;' language 'plpgsql';

select inline_2();

drop function inline_2();

drop sequence rl_type_id_sequence;
drop table rl_types;
drop sequence rl_shoe_id_sequence;
drop table rl_shoes;
drop sequence rl_course_id_sequence;
drop table rl_courses;
drop table rl_runners;

