SUBCHARTS := $(wildcard charts/*)

create-namespace:
	bash make.sh create-namespace

dev:
	bash make.sh upgrade-dev

deploy:
	bash make.sh upgrade

create-secrets: create-namespace $(SUBCHARTS)
	bash make.sh create-secrets

recreate-dev:
	bash make.sh recreate-dev

test:
	bash make.sh $(MAKECMDGOALS)

$(SUBCHARTS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(SUBCHARTS)
