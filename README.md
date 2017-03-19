# Extract matplotlib documentation in XML format

Rough POC to extract matplotlib documentation in xml format.

```
docker pull python:3.5

git clone git@github.com:matplotlib/matplotlib.git matplotlib
git checkout v2.0.0

cp ./run.sh ./matplotlib/
docker run --name mpl-docs -i -t -v $PWD/matplotlib:/data python:3.5 /bin/bash
$ ./run.sh
```

Find xml docs in `matplotlib/doc/build/xml`.
