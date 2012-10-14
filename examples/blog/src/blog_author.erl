%%% @doc A blog post author.
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
-module(blog_author).
-author("Marcelo Gornstein <marcelog@gmail.com>").
-github("https://github.com/marcelog").
-homepage("http://marcelog.github.com/").
-license("Apache License 2.0").

-include_lib("include/epers_doc.hrl").

-behavior(epers_doc).

-export([epers_schema/0, epers_wakeup/1]).
-export([new/1, new/2]).
-export([id/1, name/1, photo/1, update_photo/2]).

-type author() :: [attr()].
-type attr() :: {key(), term()}.
-type key() :: id|name|photo.
-type id() :: pos_integer().

-export_type([author/0]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Public API.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new(Name) when is_list(Name) ->
  create(undefined, Name, <<>>).

new(Name, Photo) when is_list(Name), is_binary(Photo) ->
  create(undefined, Name, Photo).

create(Id, Name, Photo) when is_list(Name), is_binary(Photo) ->
  [{id, Id}, {name, Name}, {photo, Photo}].

id(State) when is_list(State) ->
  get(id, State).

name(State) when is_list(State) ->
  get(name, State).

photo(State) when is_list(State) ->
  get(photo, State).

update_photo(Photo, State) when is_binary(Photo), is_list(State) ->
  set(photo, Photo, State).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Private functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get(Key, State) when is_atom(Key), is_list(State) ->
  proplists:get_value(Key, State).

set(Key, Value, State) when is_atom(Key), is_list(State) ->
  lists:keyreplace(Key, 1, State, {Key, Value}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% eper behavior follows.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epers_wakeup(#epers_doc{}=Doc) ->
  [
    {id, epers:get_field(id, Doc)},
    {name, epers:get_field(name, Doc)},
    {photo, epers:get_field(photo, Doc)}
  ].

epers_schema() ->
  epers:new_schema(?MODULE, [
    epers:new_field(id, integer, [not_null, auto_increment, id]),
    epers:new_field(name, string, [{length, 128}, not_null]),
    epers:new_field(photo, binary)
  ]).