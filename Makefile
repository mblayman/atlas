.PHONY: coverage

coverage:
	busted
	luacov src
	cat luacov.report.out
