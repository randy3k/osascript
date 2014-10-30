all:
	git add -A \
	&& git commit -m "Update osascript at $$(date)" \
	&& git push
