<?xml version="1.0" encoding="UTF-8" ?>
<!--
<![CDATA[
Psalm XML to HTML renderer

 See - https://github.com/Roave/psalm-html-output

]]>
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="report">
        <html>
            <head>
                <title>Psalm Report</title>
                <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/themes/prism.css" rel="stylesheet" />
                <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/plugins/line-numbers/prism-line-numbers.min.css" rel="stylesheet" />
                <style>
                    html {
                        font-family: sans-serif;
                    }
                    pre > code.language-php {
                      font-size: 1em;
                    }
                    code[class*="language-"] .psalm-errored-code {
                        background-color: red;
                        color: white;
                        text-shadow: none;
                    }
                    ul.tags {
                        padding: 0;
                        margin: 0;
                        font-size: 0.9em;
                    }
                    ul.tags li {
                        display: inline;
                        background-color: #e5e6d9;
                        padding: 3px 5px;
                        border-radius: 5px;
                        text-shadow: 0 1px white;
                        margin-right: 10px;
                    }
                    .severity {
                        text-transform: lowercase;
                    }
                    .severity.error {
                        color: #ff0000;
                    }
                    .severity.warning {
                        color: #ff6e00;
                    }
                    .severity.info {
                        color: #0079ff;
                    }
                    ul#psalmErrors li.hidden {
                        display: none;
                    }
                </style>
            </head>
            <body>
                <section>
                    <h1>Total violations: <xsl:value-of select="count(//report/item)" /></h1>
                </section>
                <form>
                    <label>
                        <select class="filterable" data-filter-type="severity">
                            <option value="">-- show all --</option>
                        </select>
                        <select class="filterable" data-filter-type="psalm-type">
                            <option value="">-- show all --</option>
                        </select>
                    </label>
                </form>
                <ul id="psalmErrors">
                    <xsl:apply-templates />
                </ul>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/prism.min.js" />
<!--                <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/plugins/autoloader/prism-autoloader.min.js" />-->
<!--                <script>Prism.plugins.autoloader.languages_path = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/components/'</script>-->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/components/prism-markup-templating.min.js" />
                <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/components/prism-php.min.js" />
                <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.16.0/plugins/line-numbers/prism-line-numbers.min.js" />
                <script type="text/javascript">
                <![CDATA[
                    Prism.hooks.add('before-insert', function(env) {
                        // Note; "higlighting" is problematic due to regex/html nonsense
                        //env.highlightedCode = env.highlightedCode.replace(/##\(##([\w\W]*)##\)##/gs, 'HERE<span class="psalm-errored-code">$1</span>THERE');
                        // Alternate approach is to indicate with raquo/laquo for now...
                        env.highlightedCode = env.highlightedCode.replace(/##\(##/g, '<span class="psalm-errored-code">&#187;&#187;&#187;</span>');
                        env.highlightedCode = env.highlightedCode.replace(/##\)##/g, '<span class="psalm-errored-code">&#171;&#171;&#171;</span>');
                    });
                    function subtractUnmatchedItems(filterType, filterValue) {
                        var items = document.querySelectorAll('#psalmErrors > li');

                        for (var i = 0; i < items.length; i++) {
                            var itemTag = items[i].getAttribute('data-' + filterType);

                            if (filterValue !== '' && itemTag !== filterValue) {
                                items[i].setAttribute('class', 'hidden');
                            }
                        }
                    }
                    function showAllItems() {
                        var items = document.querySelectorAll('#psalmErrors > li');

                        for (var i = 0; i < items.length; i++) {
                            items[i].setAttribute('class', '');
                        }
                    }
                    document.querySelectorAll('.filterable').forEach(function (itemToApplyClickHandlerTo) {

                        var foundItems = [];
                        var filterType = itemToApplyClickHandlerTo.getAttribute('data-filter-type');
                        var items = document.querySelectorAll('#psalmErrors > li');
                        var uniqueCounts = [];
                        for (var i = 0; i < items.length; i++) {
                            var itemAttributeValue = items[i].getAttribute('data-' + filterType);
                            if (itemAttributeValue in uniqueCounts) {
                                uniqueCounts[itemAttributeValue]++;
                            } else {
                                uniqueCounts[itemAttributeValue] = 1;
                            }
                            foundItems.push(itemAttributeValue);
                        }
                        var uniqueFoundItems = foundItems.filter(function (value, index, self) {
                            return self.indexOf(value) === index;
                        });
                        for (var i = 0; i < uniqueFoundItems.length; i++) {
                            var newOpt = document.createElement('option');
                            newOpt.value = uniqueFoundItems[i];
                            newOpt.innerHTML = uniqueFoundItems[i] + ' (' + uniqueCounts[uniqueFoundItems[i]] + ')';
                            itemToApplyClickHandlerTo.appendChild(newOpt);
                        }

                        itemToApplyClickHandlerTo.onclick = function () {
                            showAllItems();
                            document.querySelectorAll('.filterable').forEach(function (filteringDropdown) {
                                subtractUnmatchedItems(
                                    filteringDropdown.getAttribute('data-filter-type'),
                                    filteringDropdown.options[filteringDropdown.selectedIndex].value
                                );
                            });
                        };
                    });
                ]]>
                </script>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="item">
        <li data-severity="{severity}" data-psalm-type="{type}">
            <h3>
                <xsl:value-of select="file_name"/>:<xsl:value-of select="line_from"/>
            </h3>
            <ul class="tags">
                <li class="severity {severity}"><xsl:value-of select="severity"/></li>
                <li><xsl:value-of select="type"/></li>
            </ul>
            <p><xsl:value-of select="message"/></p>
            <pre data-start='{line_from}' class="line-numbersx">
                <code class="language-php"><xsl:value-of select="substring(snippet, 0, from - snippet_from + 1)" />##(##<xsl:value-of select="substring(snippet, from - snippet_from + 1, to - from)" />##)##<xsl:value-of select="substring(snippet, to - snippet_from + 1)" /></code>
            </pre>
        </li>
    </xsl:template>
</xsl:stylesheet>
