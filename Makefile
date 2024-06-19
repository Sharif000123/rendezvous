dev: venv app/static/style.css
	venv/bin/flask run --debug # error messages & auto-reload on code change

venv: requirements.txt
	python -m venv venv
	venv/bin/pip install --upgrade pip
	venv/bin/pip install pip-tools
	venv/bin/pip install -r requirements.txt
	touch venv

.PHONY: update
update: venv
	venv/bin/pip-compile --strip-extras --quiet
	venv/bin/pip install -r requirements.txt
	touch venv

clean:
	rm -rf venv
	rm -f app/static/style.css

app/static/style.css:
	wget https://raw.githubusercontent.com/andybrewer/mvp/v1.15/mvp.css -O $@

deploy:
	git remote rm tmp-deploy || true
	git remote add tmp-deploy dokku@dokku.sandbox.sgckn.pkel.dev:kn-city-logistik
	git push tmp-deploy main
	git remote rm tmp-deploy
