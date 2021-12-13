install:
	mix deps.get

compile:
	mix compile

release:
	mix distillery.release --env=prod

run:
	mix run --no-halt
