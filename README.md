drf-dash
========

Build Django REST framework docset for Dash (http://kapeli.com/dash/)

Dependencies
------------

- [pipenv](https://pipenv.readthedocs.io/en/latest/)
- wget

Building DocSet
------------

```shell
pipenv install mkdocs
pipenv shell
make run version=3.14.0
ls build
```

Using DocSet
------------

1. Open Dash preferences
2. Open the DocSets tab
3. Click + and locate the `django-rest-framework-x.x.x.docset` file in the build dir 