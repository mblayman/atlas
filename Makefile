.PHONY: coverage

# Busted has no expected failure feature so let's fake it for now.
# This isn't great because it hides tests instead of skipping them
# and showing that they were skipped.
coverage:
	busted --exclude-tags xfail
	luacov src
	cat luacov.report.out
