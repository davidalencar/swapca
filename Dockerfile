# syntax=docker/dockerfile:1
FROM elixir:1.12
RUN mkdir swap
WORKDIR swap
COPY . .
RUN mix local.hex --force deps.get &&\                                              
 mix local.rebar --force &&\                                                     
 mix deps.get &&\                                                                
 mix compile                                                                     
                  
CMD mix run --no-halt 
