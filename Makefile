# ---------------------
# -- Code generation --
# ---------------------

.PHONY: gen

gen:
	@echo "Generating SwiftGen files"
	swiftgen config run --config "./.swiftgen.yml"

# ------------------------
# -- Push notifications --
# ------------------------

.PHONY: push

push:
	@echo "Sending push notification to simulator"
	xcrun simctl push booted app.wroclive "./misc/simulator-push-payload.json"

# -----------------
# -- Lint/format --
# -----------------

.PHONY: lint format

# If you are using any other reporter than 'emoji' then you are doing it wrong...
lint:
	SwiftLint lint --reporter emoji

format:
	SwiftFormat --config ./.swiftformat "./Wroclive" "./WrocliveFramework" "./WrocliveTests"
