.PHONY: coverage t

coverage: t
	luacov src
	@tail -n+$$(cat luacov.report.out | grep -m 1 -n 'Summary' | cut -d: -f 1) luacov.report.out

# Busted has no expected failure feature so let's fake it for now.
# This isn't great because it hides tests instead of skipping them
# and showing that they were skipped.
t:
	busted --exclude-tags xfail

build:
	luarocks install --tree .luarocks busted
	luarocks install --tree .luarocks LuaCov
	luarocks install --tree .luarocks --server https://luarocks.org/dev luaformatter
	luarocks make --tree .luarocks

atlas:
	luarocks make --tree .luarocks

bootstrap:
	luarocks install --tree .luarocks luacheck
