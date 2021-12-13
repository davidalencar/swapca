install:
	mix deps.get compile

release:
	mix distillery.release --env=prod

run:
	mix run --no-halt
