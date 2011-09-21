--
-- Datamodel
-- @author Vinod Kurup <vinod@kurup.com>
-- @creation-date 2003-09-17
-- @cvs-id $Id: rl-tables.sql,v 1.2 2004/02/16 21:19:28 vinod Exp $
--

--
-- each user with a log is represented in rl_runners
-- extending acs_objects so that we can apply perms
--

create table rl_runners (
    runner_id           integer
                        constraint rlr_runner_id_fk
                        references acs_objects
                        on delete cascade
                        constraint rlr_runner_id_pk
                        primary key,
    user_id             integer
                        constraint rlr_user_id_fk
                        references users
                        on delete cascade
                        constraint rlr_user_id_un
                        unique,
    height              real,
    start_week          integer
                        default 1,
    distance_units      varchar(10)
                        default 'm',
    weight_units        varchar(10)
                        default 'lb'
);

comment on table rl_runners is '
    Extend the users table with some more info.
';

comment on column rl_runners.height is '
    Runner''s height in inches. Used to calculate BMI.
';

comment on column rl_runners.start_week is '
    Start the week on Sunday (0) or Monday (1). Weekly mileage will be
    calculated differently based on this setting.
';

comment on column rl_runners.distance_units is '
    How does the runner prefer entering and seeing distance data? KM or miles.
    Doesn''t affect the data model, calculations are done in TCL layer.
';

comment on column rl_runners.weight_units is '
    How does the runner prefer their weight - kg or lb.
';

select acs_object_type__create_type (
    'rl_runner',            -- object_type
    'Running Log',          -- pretty_name
    'Running Logs',         -- pretty_plural
    'acs_object',           -- supertype
    'rl_runners',           -- table_name
    'runner_id',            -- id_column
    null,                   -- package_name
    'f',                    -- abstract_p
    null,                   -- type_extension_table
    'rl_runner__name'       -- name_method
);

create table rl_types (
    type_id             integer
                        constraint rlt_type_id_pk
                        primary key,
    runner_id           integer
                        constraint rlt_runner_id_fk
                        references rl_runners
                        on delete cascade,
    type                varchar(100),
    constraint rlt_runner_type_un
    unique (runner_id, type)
);

comment on table rl_types is '
    Keep track of workout types.
';

create sequence rl_type_id_sequence;

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Race');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Long Run');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Intervals');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Easy Run');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Hills');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Fartlek');

insert into rl_types 
(type_id, runner_id, type)
values
(nextval('rl_type_id_sequence'),null,'Tempo');

create table rl_shoes (
    shoe_id             integer
                        constraint rls_shoe_id_pk
                        primary key,
    runner_id           integer
                        constraint rls_runner_id_fk
                        references rl_runners
                        on delete cascade,
    name                varchar(100)
                        constraint rls_name_un
                        unique
                        constraint rls_name_nn
                        not null,
    start_date          timestamptz,
    comments            text,
    deleted_p           boolean default false
);

comment on table rl_shoes is '
    Keep track of shoes.
';

comment on column rl_shoes.start_date is '
    When were the shoes first used?
';

create sequence rl_shoe_id_sequence;

create table rl_courses (
    course_id           integer
                        constraint rlc_course_id_pk
                        primary key,
    runner_id           integer
                        constraint rls_runner_id_fk
                        references rl_runners
                        on delete cascade,
    name                varchar(100),
    distance            real,
    comments            text,
    deleted_p           boolean default false,
    constraint rlc_runner_name_dist_un
    unique (runner_id, name, distance)
);

comment on table rl_courses is '
    Keep track of courses. runner_id/name/distance combination defines
    uniqueness, so you can have a 5 mile Lake loop and a 10 mile Lake loop.
    Keeping track of courses allows the user to generate reports/data about
    a particular course and also simplifies data entry. But, the user
    should also be able to freeform entry about a course that they don''t
    want to store in rl_courses.
';

comment on column rl_courses.name is '
    A short name for the course.
';

comment on column rl_courses.distance is '
    The distance of this course. You can have multiple courses with the same 
    name as long as they are of different distances.
';

create sequence rl_course_id_sequence;

-- rl_workouts will store each workout. We'll use the content repository,
-- but without using versioning - just one version per workout.

-- instead of having a workout_type column, we'll use cr_keywords to 
-- categorize the type of workout. I've never used cr_keywords before, so
-- this is a risk. I'm not sure how efficient or usable they are. Let's find
-- out.

create table rl_workouts (
    workout_id          integer
                        constraint rlw_workout_id_fk
                        references cr_revisions
                        on delete cascade
                        constraint rlw_workout_id_pk
                        primary key,
    runner_id           integer
                        constraint rlw_runner_id_fk
                        references rl_runners
                        on delete cascade
                        constraint rlw_runner_id_nn
                        not null,
    workout_date        timestamptz
                        constraint rlw_workout_date_nn
                        not null,
    distance            real,
    time                interval,
    weight              real,
    resting_hr          integer,
    type_id             integer
                        constraint rlw_type_id_fk
                        references rl_types
                        on delete set null,
    shoe_id             integer
                        constraint rlw_shoe_id_fk
                        references rl_shoes
                        on delete set null,
    course_id           integer
                        constraint rlw_course_id_fk
                        references rl_courses
                        on delete set null,
    course_desc         text
);

comment on table rl_workouts is '
    Each row is an individual workout
';

comment on column rl_workouts.runner_id is '
    Whose workout is this?
';

comment on column rl_workouts.distance is '
    How far in miles? Even if the user prefers seeing metric, use miles
    here for consistency. Do the conversion in TCL. Using datatype real
    instead of numeric, because numeric is meant for high precision data.
    real is faster.
';

comment on column rl_workouts.time is '
    How long did it take? in seconds.
';

comment on column rl_workouts.weight is '
    How much does the runner weigh in pounds?
';

comment on column rl_workouts.resting_hr is '
    What was the runners resting HR today? in beats/minute
';

comment on column rl_workouts.type_id is '
    What type of workout was this?
';

comment on column rl_workouts.shoe_id is '
    Which shoe did the runner use today?
';

comment on column rl_workouts.course_id is '
    Which course did the runner run today?
';

comment on column rl_workouts.course_desc is '
    If course_id refers to an Unfiled course, then course_desc may contain
    free-form info about the course.
';

-- create the content_type and content_attributes

select content_type__create_type (
    'rl_workout',           -- content_type
    'content_revision',     -- supertype
    'Workout Entry',        -- pretty_name
    'Workout Entries',      -- pretty_plural
    'rl_workouts',          -- table_name
    'workout_id',           -- id_column
    null                    -- name_method
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'runner_id',            -- attribute_name
    'integer',              -- datatype
    'Running Log',          -- pretty_name
    'Running Logs',         -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'integer'               -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'workout_date',         -- attribute_name
    'timestamp',            -- datatype
    'Workout Date',         -- pretty_name
    'Workout Dates',        -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'timestamptz'           -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'distance',             -- attribute_name
    'number',               -- datatype
    'Distance',             -- pretty_name
    'Distances',            -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'real'                  -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'time',                 -- attribute_name
    'timestamp',            -- datatype
    'Time',                 -- pretty_name
    'Times',                -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'interval'              -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'weight',               -- attribute_name
    'number',               -- datatype
    'Weight',               -- pretty_name
    'Weights',              -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'real'                  -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'resting_hr',           -- attribute_name
    'integer',              -- datatype
    'Resting HR',           -- pretty_name
    'Resting HRs',          -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'integer'               -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'type_id',              -- attribute_name
    'integer',              -- datatype
    'Workout Type',         -- pretty_name
    'Workout Types',        -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'integer'               -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'shoe_id',              -- attribute_name
    'integer',              -- datatype
    'Shoe',                 -- pretty_name
    'Shoes',                -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'integer'               -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'course_id',            -- attribute_name
    'integer',              -- datatype
    'Course',               -- pretty_name
    'Courses',              -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'integer'               -- column_spec
);

select content_type__create_attribute(
    'rl_workout',           -- content_type
    'course_desc',          -- attribute_name
    'text',                 -- datatype
    'Course Description',   -- pretty_name
    'Course Descriptions',  -- pretty_plural
    null,                   -- sort_order
    null,                   -- default_value
    'text'                  -- column_spec
);


-- create a content folder underneath root folder
-- name it 'running-log'. Each instance will have a 
-- separate folder at 'running-log/${package_id}' 
-- So package_id 9282 will be at '/running-log/9282'

create function inline_1 ()
returns integer as '
declare
    v_folder_id         cr_folders.folder_id%TYPE;
begin
    v_folder_id := content_folder__new(
        ''running-log'',                    -- name
        ''Running Log Workouts'',           -- label
        ''Running Log Root Folder'',        -- description
        content_item__get_root_folder(null) -- parent_id
    );

    perform content_folder__register_content_type (
        v_folder_id,                        -- folder_id
        ''rl_workout'',                     -- content_type
        ''t''                               -- include_subtypes
    );

    -- allow subfolders
    perform content_folder__register_content_type (
        v_folder_id,                        -- folder_id
        ''content_folder'',                 -- content_type
        ''t''                               -- include_subtypes
    );

    return 0;
end;' language 'plpgsql';

select inline_1();

drop function inline_1();
