.PHONY: build
build:
	go build

.PHONY: install/checks/spell-and-markdown
install/checks/spell-and-markdown:
	yarn

.PHONY: run/checks/spell-and-markdown
run/checks/spell-and-markdown:
	yarn check-trailing-whitespaces
	yarn check-word-lists
	yarn cspell --no-progress '**/**'
	yarn markdownlint --ignore 'node_modules/' '**/*.md'

.PHONY: install/checks/schema-validation
install/checks/schema-validation:
	cd schema-test && go mod download

.PHONY: run/checks/schema-validation
run/checks/schema-validation:
	cd schema-test && go clean -testcache && go test .

.PHONY: build/go-code-from-openapi-schema
build/go-code-from-openapi-schema:
	GO_POST_PROCESS_FILE="/usr/local/bin/gofmt -w" openapi-generator generate -i schemas/v1/schema.yaml -g go -o dist/oag-go/ --inline-schema-name-mappings AlertPolicyCondition_inner=AlertPolicyCondition,AlertPolicyNotificationTarget_inner=AlertPolicyNotificationTarget --global-property models,modelDocs=false --package-name openslo_v1

.PHONY: build/go-code-from-jsonschema
build/go-code-from-jsonschema:
	mkdir -p dist/quicktype-go
	quicktype --quiet --telemetry disable --just-types -l go -s schema -o dist/quicktype-go/openslo_v1.go --package openslo_v1 \
	    schemas/v1/alertcondition.schema.json \
	    schemas/v1/alertnotificationtarget.schema.json \
	    schemas/v1/alertpolicy.schema.json \
	    schemas/v1/budgetadjustment.schema.json \
	    schemas/v1/datasource.schema.json \
	    schemas/v1/service.schema.json \
	    schemas/v1/sli.schema.json \
	    schemas/v1/slo.schema.json \
	    -S schemas/v1/parts/alertcondition-spec.schema.json \
	    -S schemas/v1/parts/alertnotificationtarget-spec.schema.json \
	    -S schemas/v1/parts/alertpolicy-spec.schema.json \
	    -S schemas/v1/parts/budgetadjustment-spec.schema.json \
	    -S schemas/v1/parts/datasource-spec.schema.json \
	    -S schemas/v1/parts/description.schema.json \
	    -S schemas/v1/parts/duration-shorthand.schema.json \
	    -S schemas/v1/parts/general.schema.json \
	    -S schemas/v1/parts/metadata.schema.json \
	    -S schemas/v1/parts/metricsource.schema.json \
	    -S schemas/v1/parts/name.schema.json \
	    -S schemas/v1/parts/service-spec.schema.json \
	    -S schemas/v1/parts/sli-spec.schema.json \
	    -S schemas/v1/parts/slo-spec.schema.json \
	    -S schemas/v1/parts/timewindow.schema.json
