.PHONY: coverage t

lr = luarocks --tree .luarocks

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
