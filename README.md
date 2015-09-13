![Travis CI Status](https://travis-ci.org/fauxton/docker_dna.svg)

DockerDna
=========

When preparing production Docker images, it's wise to avoid directly linking to someone else's
images from within your Dockerfile. The first (and obvious) reason is security. But even if
you trust the source, the other issue is upgrades. Because we typically use the image tagged as
*latest*, this means that an upstream change can modify your next production deploy. It happens.

Docker DNA gives you the convenience of referencing another developer's Dockerfile without the
risk. Instead of your image being directly generated from someone else's directives, it assembles
a new Dockerfile by tracing the ancestors of a given repository image and concatenating the results.

The result is a Dockerfile that you are in total control of and whose source is in a single place
(not spread across repos/hub pages).

# Usage
To generate a Dockerfile, simply invoke the included binary with the name of the image you'd
like to use:

```bash
$ ./docker_dna <user>/<image>
```

By default, this will generate a file called `Dockerfile.dna`.  You can then use that file to build/run a Docker
container like so:

```bash
$ docker build -t my_awesome_image -f Dockerfile.dna .
$ docker run my_awesome_image
```

## Flags

To override the default filename, you can pass the `-o` flag:

```bash
$ ./docker_dna <user>/<image> -o MyCustomDockerFile
```

# Caveats

Docker image tags are currently unsupported.  The assumption is that the latest version of a given ancestor should be used.
