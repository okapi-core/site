.PHONY: test-run

test-run:
	hugo server --logLevel debug --disableFastRender -p 1313
