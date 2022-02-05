.PHONY: coverage t

lr = luarocks --tree .luarocks

coverage: t
	luacov src
	@tail -n+$$(cat luacov.report.out | grep -m 1 -n 'Summary' | cut -d: -f 1) luacov.report.out

# Busted has no expected failure feature so let's fake it for now.
# This isn't great because it hides tests instead of skipping them
# and showing that they were skipped.
t:
	busted --exclude-tags xfail

build:
	$(lr) install busted
	$(lr) install LuaCov
	$(lr) install --server https://luarocks.org/dev luaformatter
	$(lr) make

atlas:
	$(lr) make

bootstrap:
	$(lr) install luacheck
