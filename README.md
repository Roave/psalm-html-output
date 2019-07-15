# Psalm HTML Output

Takes the XML output from [Psalm](https://psalm.dev/) and renders it as HTML.

## Installation

First, install `xsltproc` on your machine (for example, `apt install xsltproc`).

Then `composer require --dev roave/paslm-html-output` (note: not yet set up)

## Usage

```bash
vendor/bin/psalm --output-format=xml | xsltproc psalm.xsl - > psalm-report.html
```
