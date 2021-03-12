SUBCHARTS := $(wildcard charts/*)

dev:
	bash make.sh upgrade-dev

deploy:
	bash make.sh upgrade

create-secrets: $(SUBCHARTS)
	bash make.sh create-secrets

$(SUBCHARTS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(SUBCHARTS)
