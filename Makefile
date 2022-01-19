.PHONY: coverage

# Busted has no expected failure feature so let's fake it for now.
# This isn't great because it hides tests instead of skipping them
# and showing that they were skipped.
coverage:
	busted --exclude-tags xfail
	luacov src
	@tail -n+$$(cat luacov.report.out | grep -m 1 -n 'Summary' | cut -d: -f 1) luacov.report.out

build:
	luarocks install --tree .luarocks busted
	luarocks install --tree .luarocks LuaCov
	luarocks install --tree .luarocks --server https://luarocks.org/dev luaformatter
	luarocks build --tree .luarocks

atlas:
	luarocks build --tree .luarocks

bootstrap:
	luarocks install --tree .luarocks luacheck
