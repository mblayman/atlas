.PHONY: coverage t

lr = luarocks --tree .luarocks

coverage: clean t
	luacov src
	@tail -n+$$(cat luacov.report.out | grep -m 1 -n 'Summary' | cut -d: -f 1) luacov.report.out | grep -v '100.00'

clean:
	@rm -f luacov.*

build:
	$(lr) install luatest
	$(lr) install LuaCov
	which lua-format || $(lr) install --server https://luarocks.org/dev luaformatter
	$(lr) make

atlas:
	$(lr) make

bootstrap:
	$(lr) install luacheck
