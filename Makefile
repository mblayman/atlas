.PHONY: coverage

# Busted has no expected failure feature so let's fake it for now.
# This isn't great because it hides tests instead of skipping them
# and showing that they were skipped.
coverage:
	.luarocks/bin/busted --exclude-tags xfail
	.luarocks/bin/luacov src
	cat luacov.report.out

build:
	luarocks install --tree .luarocks busted
	luarocks install --tree .luarocks luacheck
	luarocks install --tree .luarocks LuaCov
	luarocks build --tree .luarocks
