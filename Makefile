# ---------------------
# -- Code generation --
# ---------------------

.PHONY: gen

gen:
	echo "Generating SwiftGen files"
	swiftgen config run --config "./swiftgen.yml"
