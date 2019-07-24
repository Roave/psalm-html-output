# Psalm HTML Output

Takes the XML output from [Psalm](https://psalm.dev/) and renders it as HTML.

[![CircleCI](https://circleci.com/gh/Roave/psalm-html-output/tree/master.svg?style=svg)](https://circleci.com/gh/Roave/psalm-html-output/tree/master)

## Installation

First, install `xsltproc` on your machine (for example, `apt install xsltproc`).

Then `composer require --dev roave/psalm-html-output`

## Usage

```bash
vendor/bin/psalm --output-format=xml | xsltproc vendor/roave/psalm-html-output/psalm-html-output.xsl - > psalm-report.html
```

## Run with Docker

To avoid having to install `xsltproc` if you already have Docker, first build the image with:

```bash
docker build . -t psalm-html-output:latest
```

Then to generate the HTML:

```bash
vendor/bin/psalm --output-format=xml | docker run --rm -i psalm-html-output:latest > psalm-report.html
```
