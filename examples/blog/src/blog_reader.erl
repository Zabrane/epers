%%% @doc A blog reader (user).
%%%
%%% Copyright 2012 Marcelo Gornstein &lt;marcelog@@gmail.com&gt;
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%% @end
%%% @copyright Marcelo Gornstein <marcelog@gmail.com>
%%% @author Marcelo Gornstein <marcelog@gmail.com>
%%%
-module(blog_reader).
-author("Marcelo Gornstein <marcelog@gmail.com>").
-github("https://github.com/marcelog").
-homepage("http://marcelog.github.com/").
-license("Apache License 2.0").

-include_lib("include/epers_doc.hrl").

-behavior(epers_doc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Exports.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-export([epers_schema/0, epers_sleep/1, epers_wakeup/1]).
-export([new/2]).
-export([id/1, email/1, name/1]).
-export([update_email/2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Types.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-type reader() :: proplists:proplist().
-type id() :: pos_integer().
-export_type([reader/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Public API.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% @doc Returns a new reader.
-spec new(string(), string()) -> reader().
new(Name, Email) when is_list(Name), is_list(Email) ->
  create(undefined, Name, Email).

%% @doc Returns a new reader (internal).
-spec create(id(), string(), string()) -> reader().
create(Id, Name, Email) when is_list(Name), is_list(Email) ->
  [{id, Id}, {name, Name}, {email, Email}].

%% @doc Returns the id of the given reader.
-spec id(reader()) -> id().
id(Reader) when is_list(Reader) ->
  get(id, Reader).

%% @doc Returns the email of the given reader.
-spec email(reader()) -> string().
email(Reader) when is_list(Reader) ->
  get(email, Reader).

%% @doc Returns the name of the given reader.
-spec name(reader()) -> string().
name(Reader) when is_list(Reader) ->
  get(name, Reader).

%% @doc Updated the email for the given reader.
-spec update_email(string(), reader()) -> reader().
update_email(Email, Reader) when is_list(Email) ->
  set(email, Email, Reader).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Private functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% @doc Generically returns an attibute of the given reader.
-spec get(atom(), reader()) -> reader().
get(Key, Reader) when is_atom(Key), is_list(Reader) ->
  proplists:get_value(Key, Reader).

%% @doc Generically set an attribute of the given reader.
-spec set(atom(), term(), reader()) -> reader().
set(Key, Value, Reader) when is_atom(Key), is_list(Reader) ->
  lists:keyreplace(Key, 1, Reader, {Key, Value}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% eper behavior follows.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% @doc Part of the epers_doc behavior.
-spec epers_wakeup(proplists:proplist()) -> reader().
epers_wakeup(Data) ->
  Data.

%% @doc Part of the epers_doc behavior.
-spec epers_sleep(reader()) -> proplists:proplist().
epers_sleep(Reader) ->
  Reader.

%% @doc Part of the epers_doc behavior.
-spec epers_schema() -> #epers_schema{}.
epers_schema() ->
  epers:new_schema(?MODULE, [
    epers:new_field(id, integer, [not_null, auto_increment, id]),
    epers:new_field(name, string, [{length, 128}, not_null, unique]),
    epers:new_field(email, string, [index])
  ]).
