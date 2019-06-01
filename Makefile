APPS=todo hello
INITS=$(APPS:%=%-init)
RUNS=$(APPS:%=%-run)

$(INITS):
	cd $(subst -init,,$@); npm install

$(RUNS):
	cd $(subst -run,,$@); npm run dev
